import numpy as np
import pandas as pd
import pickle
import joblib
import tensorflow as tf
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler, MinMaxScaler
from sklearn.compose import ColumnTransformer
from PIL import Image

class Model:
    def __init__(self, model_path):
        if model_path.endswith('.pkl'):
            with open(model_path, 'rb') as f:
                self.model = pickle.load(f)
            self.model_type = 'sklearn'
        elif model_path.endswith('.joblib'):
            self.model = joblib.load(model_path)
            self.model_type = 'sklearn'
        elif model_path.endswith('.h5'):
            self.model = tf.keras.models.load_model(model_path)
            self.model_type = 'keras'
        elif model_path.endswith('.tflite'):
            self.model = tf.lite.Interpreter(model_path=model_path)
            self.model.allocate_tensors()
            self.model_type = 'tflite'
        else:
            raise ValueError(f"Model format '{model_path.split('.')[-1]}' not supported. Please use '.pkl', '.joblib', '.h5', or '.tflite'.")

    def data_pipeline(self, numerical_features=None, scaler_type="standard"):
        '''
        Method ini berfungsi untuk membuat pipeline yang mencakup preprocessing data dan model.  
        Jenis preprocessing yang diterapkan bergantung pada kebutuhan model yang digunakan.  
        Pada method ini, contoh preprocessing yang disertakan adalah StandardScaler dan MinMaxScaler.  
        Parameter `scaler_type` dipilih karena kedua scaler ini adalah yang paling umum digunakan.  
        Baik data tabular maupun data gambar dapat direpresentasikan dalam bentuk numerik, sehingga kedua tipe data tersebut  
        dapat diproses dalam method ini menggunakan StandardScaler dan MinMaxScaler.
        '''
        if self.model_type != 'sklearn':
            raise ValueError("Data pipeline is only supported for scikit-learn models.")
        
        transformers = []
        
        if numerical_features:
            if scaler_type == "standard":
                transformers.append(('scaler', StandardScaler(), numerical_features))
            elif scaler_type == "minmax":
                transformers.append(('scaler', MinMaxScaler(), numerical_features))
            else:
                raise ValueError(f"Unsupported scaler type: '{scaler_type}'. Use 'standard' or 'minmax'.")

        preprocessor = ColumnTransformer(transformers, remainder='passthrough')
        
        pipeline = Pipeline([
            ('preprocessor', preprocessor),
            ('model', self.model)
        ])
        
        return pipeline

    def predict_from_image(self, image_file):
        '''
        Melakukan prediksi klasifikasi sampah dari gambar menjadi kategori organik atau non-organik.
        
        Preprocessing yang dilakukan:
        - Konversi ke format RGB
        - Resize gambar ke ukuran (128, 128) piksel
        - Normalisasi nilai pixel ke rentang [0,1]

        Args:
            image_file: Path file gambar, PIL Image instance, atau numpy array
            
        Returns:
            str: Label hasil prediksi berupa 'organik' atau 'non-organik'
        '''
        # Load dan normalisasi gambar
        if isinstance(image_file, np.ndarray):
            # Konversi numpy array ke PIL Image
            # Jika array 3 channel, asumsikan format BGR dan konversi ke RGB
            if image_file.ndim == 3 and image_file.shape[2] == 3:
                # Konversi BGR ke RGB
                img_rgb = image_file[:, :, ::-1]  # Balik urutan channel terakhir
                img = Image.fromarray(img_rgb.astype('uint8'))
            else:
                img = Image.fromarray(image_file.astype('uint8'))
        elif isinstance(image_file, Image.Image):
            img = image_file
        else:
            # Input berupa path file
            img = Image.open(image_file)

        # Konversi ke RGB dan resize menggunakan PIL
        img = img.convert('RGB')
        img = img.resize((128, 128), Image.LANCZOS)
        
        # Konversi ke numpy array dan normalisasi
        img_array = np.array(img).astype('float32') / 255.0
        image_array = np.expand_dims(img_array, axis=0)  # Bentuk (1,128,128,3)

        # Prediksi menggunakan model TensorFlow Lite
        if self.model_type == 'tflite':
            input_details = self.model.get_input_details()
            output_details = self.model.get_output_details()

            inp_dtype = input_details[0]['dtype']
            quant = input_details[0].get('quantization', (0.0, 0))
            scale, zero_point = quant

            # Persiapan data sesuai dengan tipe input model
            img_for_model = image_array
            if scale and scale != 0:
                # Terapkan kuantisasi jika diperlukan
                img_for_model = (image_array / scale + zero_point).astype(inp_dtype)
            else:
                img_for_model = image_array.astype(inp_dtype)

            self.model.set_tensor(input_details[0]['index'], img_for_model)
            self.model.invoke()
            prediction = self.model.get_tensor(output_details[0]['index'])
            prediction = np.array(prediction)

            # Binary classification dengan sigmoid output
            # Berdasarkan training: O (Organic) = 0, R (Recyclable) = 1
            # Output sigmoid: < 0.5 = Organic, >= 0.5 = Recyclable
            if prediction.ndim == 2 and prediction.shape[1] == 1:
                prob = float(prediction[0][0])
                label = 'organik' if prob < 0.5 else 'non-organik'
                return label

            # Untuk softmax dengan 2 output
            if prediction.ndim == 2 and prediction.shape[1] == 2:
                probs = prediction[0]
                label = 'organik' if probs[0] > probs[1] else 'non-organik'
                return label

            # Untuk argmax approach
            flat = prediction.flatten()
            idx = int(np.argmax(flat))
            label = 'organik' if idx == 0 else 'non-organik'
            return label

        else:
            raise ValueError("This method is only supported for TensorFlow Lite models.")

    def predict_from_data(self, data, numerical_features=None):
        '''
        Method ini digunakan untuk memprediksi data tabular yang diberikan. Contoh yang digunakan dalam method ini adalah
        dataset iris dan model yang digunakan adalah random forest classifier yang telah di-training pada dataset iris.
        '''
        if self.model_type == 'sklearn':
            if isinstance(data, (list, np.ndarray)):
                data = pd.DataFrame([data])

            elif not isinstance(data, pd.DataFrame):
                raise ValueError("Data format not supported for sklearn model. Use list, NumPy array, or DataFrame.")
            
            # Pipeline digunakan jika pada saat model training data telah melalui preprocessing
            # pipeline = self.data_pipeline(numerical_features=numerical_features) 

            # Hasil prediksi berbentuk angka
            prediction = self.model.predict(data)

            # Parsing hasil prediksi menjadi label (case: iris dataset)
            prediction = "setosa" if prediction == 0 else "versicolor" if prediction == 1 else "virginica"

            return prediction

        elif self.model_type == 'keras':
            data = np.array(data)
            if data.ndim == 1:
                data = data.reshape(1, -1) 
            prediction = self.model.predict(data)
            return prediction.tolist()

        elif self.model_type == 'tflite':
            '''
            Model TensorFlow Lite pada contoh ini adalah model yang telah di-training pada dataset iris.
            Model ini menerima input berupa data numerik dan menghasilkan output berupa angka.
            '''
            input_details = self.model.get_input_details()
            output_details = self.model.get_output_details()
            
            data = np.array(data, dtype=input_details[0]['dtype'])
            if data.ndim == 1:
                data = np.expand_dims(data, axis=0)
            self.model.set_tensor(input_details[0]['index'], data)
            self.model.invoke()
            prediction = self.model.get_tensor(output_details[0]['index'])
            prediction = np.argmax(prediction, axis=1)
            return prediction.tolist()

        else:
            raise ValueError("Model type not supported.")
        
    @staticmethod
    def from_path(model_path):
        return Model(model_path)
