import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class PredictionProvider with ChangeNotifier {
  File? imageFile;
  String? predictionMessage;
  bool isSuccess = false;
  final ImagePicker _picker = ImagePicker();

  // Fungsi untuk mengambil gambar dari galeri atau kamera dengan error handling
  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        notifyListeners();
      } else {
        // User membatalkan
        imageFile = null;
        predictionMessage = 'Pengambilan gambar dibatalkan.';
        notifyListeners();
      }
    } catch (e) {
      imageFile = null;
      predictionMessage = 'Terjadi error saat mengambil gambar: $e';
      notifyListeners();
    }
  }

  // Fungsi untuk mengirim gambar ke API dan mendapatkan prediksi dengan error handling
  Future<bool> predictImage() async {
    if (imageFile == null) {
      predictionMessage = 'Tidak ada gambar yang dipilih.';
      isSuccess = false;
      notifyListeners();
      return false;
    }

    // Reset status sebelum prediksi
    isSuccess = false;
    predictionMessage = 'Memproses gambar...';
    notifyListeners();

    try {
      final url = Uri.parse('https://ecoscan.loca.lt/api/predict-image');
      final request = http.MultipartRequest(
        'POST',
        url,
      )..files.add(await http.MultipartFile.fromPath('image', imageFile!.path));
      // (Optional) Tambahkan header jika API memerlukannya
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        // 'Authorization': 'Bearer YOUR_TOKEN', // Tambahkan jika perlu
      });

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        final data = jsonDecode(responseData);
        if (data['prediction'] != null &&
            data['prediction'].toString().isNotEmpty) {
          // prediction: "organik" atau "non-organik"
          final prediction = data['prediction'].toString();
          predictionMessage =
              'Jenis sampah: ${prediction[0].toUpperCase()}${prediction.substring(1)}';
          isSuccess = true; // Prediksi berhasil
          notifyListeners();
          return true;
        } else {
          predictionMessage = 'Prediction failed';
          isSuccess = false;
          notifyListeners();
          return false;
        }
      } else {
        // Jika error, tampilkan pesan error
        predictionMessage = 'Error ${response.statusCode}: $responseData';
        isSuccess = false;
        notifyListeners();
        return false;
      }
    } on SocketException catch (e) {
      predictionMessage = 'Tidak dapat terhubung ke server: $e';
      isSuccess = false;
      notifyListeners();
      return false;
    } on FormatException catch (e) {
      predictionMessage = 'Format response dari server tidak valid: $e';
      isSuccess = false;
      notifyListeners();
      return false;
    } on http.ClientException catch (e) {
      predictionMessage = 'Client error: $e';
      isSuccess = false;
      notifyListeners();
      return false;
    } catch (e) {
      predictionMessage = 'Terjadi error saat prediksi: $e';
      isSuccess = false;
      notifyListeners();
      return false;
    }
  }

  // Fungsi untuk menghapus gambar dan prediksi
  void clear() {
    imageFile = null;
    predictionMessage = null;
    isSuccess = false;
    notifyListeners();
  }
}
