# 📋 Alur Aplikasi EcoScan

## 🏗️ **Struktur Aplikasi**

### **1. Entry Point (main.dart)**
```dart
void main() => runApp(
  ChangeNotifierProvider(
    create: (context) => PredictionProvider(), // Provider untuk state management
    child: const EcoScanApp(),
  ),
);
```

---

## 🔄 **Alur Lengkap Aplikasi**

### **Phase 1: Startup**
1. **App Launch** → `EcoScanApp` widget dijalankan
2. **Provider Setup** → `PredictionProvider` dibuat dan tersedia di seluruh app
3. **Home Screen** → `EcoScanHome` ditampilkan dengan UI utama

### **Phase 2: User Interaction**
4. **User tap "Pilih Gambar"** → `showModalBottomSheet()` dipanggil
5. **Bottom Sheet** → `EcoBottomSheet` widget muncul dengan 2 opsi:
   - 📷 **Kamera** 
   - 🖼️ **Galeri**

### **Phase 3: Image Selection** 
6. **User pilih sumber** → `_pickImage(context, ImageSource)` dipanggil
7. **Navigator disimpan** → `final navigator = Navigator.of(context)` (untuk navigasi nanti)
8. **Pick image** → `provider.pickImage(source)` dipanggil
9. **Bottom sheet ditutup** → `navigator.pop()`

### **Phase 4: Image Processing**
10. **Validasi gambar** → Cek apakah `provider.imageFile != null`
11. **API Call** → `provider.predictImage()` dipanggil:
    - **HTTP Request** ke `https://ecoscan.loca.lt/api/predict-image`
    - **Multipart upload** gambar ke server
    - **Response** format: `{"message": "Image received", "prediction": "organik"}`

### **Phase 5: Response Processing**
12. **Parse Response** → Controller mengambil field `prediction`
13. **Set State**:
    - `predictionMessage = "Jenis sampah: Organik"`
    - `isSuccess = true`
    - `notifyListeners()` dipanggil
14. **Return Success** → Method return `true`

### **Phase 6: Navigation**
15. **Check Success** → `if (success && provider.predictionMessage != null)`
16. **Navigate** → `navigator.push(MaterialPageRoute(...HasilDeteksi...))`
17. **Show Result** → Halaman `HasilDeteksi` menampilkan:
    - 🖼️ **Gambar** yang di-upload
    - 📝 **Hasil prediksi**: "Jenis sampah: Organik"

---

## 📁 **File Structure & Responsibilities**

### **controller.dart** 
- **PredictionProvider** (State Management)
- **Properties**: `imageFile`, `predictionMessage`, `isSuccess`
- **Methods**: 
  - `pickImage()` - Ambil gambar dari kamera/galeri
  - `predictImage()` - Upload ke API dan parse response
  - `clear()` - Reset state

### **main.dart**
- **App Setup** & **Provider Configuration**
- **UI Components**: `EcoScanHome`, `EcoBottomSheet`
- **Navigation Logic** untuk ke `HasilDeteksi`

### **hasildeteksi.dart**
- **Result Display** 
- **Show Image** + **Prediction Message**
- **Back Button** dengan `provider.clear()`

### **`page/aboutapp.dart`**
- **About Page** dengan informasi aplikasi

---

## 🎯 **Key Points**

### **State Management**
- Menggunakan **Provider** pattern
- **`notifyListeners()`** untuk update UI
- **Context-independent** navigation

### **Error Handling**
- **Network errors** → SocketException
- **API errors** → HTTP status codes  
- **Format errors** → JSON parsing
- **UI feedback** → Error messages di predictionMessage

### **Navigation Strategy**
- **Navigator disimpan** sebelum bottom sheet ditutup
- **Context-safe** navigation untuk menghindari "context not mounted"
- **Async-friendly** dengan proper await/async

### **API Integration**
- **Multipart upload** untuk gambar
- **JSON response** parsing
- **Timeout handling** dan **retry logic**

Alur ini memastikan **user experience** yang smooth dari pemilihan gambar hingga menampilkan hasil prediksi! 🚀

Made changes.
