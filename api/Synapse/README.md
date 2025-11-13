# Synapse
Synapse dikembangkan menggunakan [Django](https://www.djangoproject.com). API ini dirancang untuk memfasilitasi pengembangan aplikasi yang akan digunakan dalam proyek akhir praktikum Pemrograman Mobile dan Kecerdasan Buatan. API ini disusun agar dapat dengan mudah dikostumisasi sesuai kebutuhan proyek akhir yang akan dilaksanakan.

## Instalasi
API ini dikembangkan pada sebuah conda environment. Untuk menginstall environment yang digunakan, jalankan perintah berikut:
- **Clone repository ini**
```bash
git clone https://github.com/praktikuminformatikaunmul/Synapse.git
cd Synapse
```

- **Import environment**
```bash
conda env create -n <nama-env-baru> -f environment.yml
```

- **Aktifkan environment**
```bash
conda activate <nama-env-baru>
```

- **Jalankan server**
```bash
python manage.py runserver
```

## Endpoint
API ini memiliki beberapa endpoint yang dapat digunakan untuk melakukan prediksi. Endpoint yang tersedia adalah:
- **/api/predict**
- **/api/predict-image**

## Penggunaan
Untuk menggunakan endpoint, lakukan request dengan metode POST. Berikut adalah contoh penggunaan endpoint:
1. **Prediksi Data Tabular**  
    - **URL**: &nbsp;&nbsp;`/api/predict`
    - **Method**: &nbsp;&nbsp;`POST`
    - **Deskripsi**: &nbsp;&nbsp; Mengirim data numerik/tabular untuk diproses oleh model, mengembalikan hasil prediksi dalam format JSON.
    - **Headers**: &nbsp;&nbsp;`Content-Type: application/json`
    - **Body**: &nbsp;&nbsp;
        ```json
        {
            "data": [6.4, 2.9, 4.3, 1.3]
        }
        ```
    - **Request**: &nbsp;&nbsp;
        ```bash
        curl -X POST <url>/api/predict -H "Content-Type: application/json" -d "{\"data\": [6.4, 2.9, 4.3, 1.3]}"
        ```
    - **Response**: &nbsp;&nbsp;
        ```json
        {
            "message": "Data received",
            "prediction": [
                1
            ]
        }
        ```

2. **Prediksi Gambar**
    - **URL**: &nbsp;&nbsp;`/api/predict-image`
    - **Method**: &nbsp;&nbsp;`POST`
    - **Deskripsi**: &nbsp;&nbsp; Mengirim gambar untuk diproses oleh model, mengembalikan hasil prediksi dalam format JSON.
    - **Headers**: &nbsp;&nbsp;`Content-Type: multipart/form-data`
    - **Body**: &nbsp;&nbsp;
        ```json
        {
            "image": "image.jpg"
        }
        ```
    - **Request**: &nbsp;&nbsp;
        ```bash
        curl -X POST <url>/api/predict_image -F "image=@/path/to/image.jpg"
        ```
    - **Response**: &nbsp;&nbsp;
        ```json
        {
            "message": "Image received",
            "prediction": [
                5
            ]
        }
        ```
