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

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        notifyListeners();
      } else {
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

  Future<bool> predictImage() async {
    if (imageFile == null) {
      predictionMessage = 'Tidak ada gambar yang dipilih.';
      isSuccess = false;
      notifyListeners();
      return false;
    }

    isSuccess = false;
    predictionMessage = 'Memproses gambar...';
    notifyListeners();

    try {
      final url = Uri.parse('https://ecoscan.loca.lt/api/predict-image');
      final request = http.MultipartRequest(
        'POST',
        url,
      )..files.add(await http.MultipartFile.fromPath('image', imageFile!.path));
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
      });

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        final data = jsonDecode(responseData);
        if (data['prediction'] != null &&
            data['prediction'].toString().isNotEmpty) {
          final prediction = data['prediction'].toString();
          predictionMessage = prediction; 
          isSuccess = true;
          notifyListeners();
          return true;
        } else {
          predictionMessage = 'Prediksi gagal: Response tidak valid.';
          isSuccess = false;
          notifyListeners();
          return false;
        }
      } else {
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

  void clear() {
    imageFile = null;
    predictionMessage = null;
    isSuccess = false;
    notifyListeners();
  }
}
