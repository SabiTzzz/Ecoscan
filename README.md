# EcoScan

<p align="center">
  <img src="Pemrograman_Piranti_Bergerak/mobile_app/ecoscan/assets/images/ecoscan.png" alt="EcoScan Logo" width="180" />
</p>

##  Tentang Aplikasi

**EcoScan** adalah aplikasi mobile sederhana yang membantu pengguna mengklasifikasikan sampah menjadi kategori **organik** dan **non-organik** menggunakan teknologi machine learning. Aplikasi ini dirancang untuk memudahkan pembuangan sampah yang tepat dan meningkatkan kesadaran lingkungan.

###  Fitur Utama

-  **Foto Sampah**: Ambil foto sampah menggunakan kamera perangkat
-  **Upload dari Galeri**: Gunakan gambar yang sudah ada di galeri
-  **AI Classification**: Menggunakan model machine learning untuk klasifikasi akurat
-  **Ramah Lingkungan**: Membantu pengguna membuang sampah dengan benar

>  **Catatan Penting**: Harap gunakan aplikasi ini sebagai panduan hasil klasifikasi namun tidak menggantikan kebijakan atau aturan pengelolaan sampah setempat.

---

## 📋 Daftar Isi

- [Prasyarat](#-prasyarat)
- [Instalasi API Backend](#-instalasi-api-backend)
- [Instalasi Aplikasi Mobile](#-instalasi-aplikasi-mobile)
- [Cara Menggunakan Aplikasi](#-cara-menggunakan-aplikasi)
- [Teknologi yang Digunakan](#-teknologi-yang-digunakan)
- [Kontribusi](#-kontribusi)
- [Lisensi](#-lisensi)

---

## Kebutuhan

- **Python**
- **Miniconda**
- **Node.js** dan **npm** (untuk LocalTunnel)
- **Flutter SDK** (untuk menjalankan aplikasi mobile)

---

## Konfigurasi API 

### 1. Clone Repository

```bash
git clone https://github.com/SabiTzzz/Ecoscan.git
cd Pemrograman_Piranti_Bergerak\api\Synapse
```

### 2. Import Environment

Buat environment Conda baru dengan file `environment.yml`:

```bash
conda env create -n ecoscan -f environment.yml
```

### 3. Aktifkan Environment

```bash
conda activate ecoscan
```

### 4. Jalankan Server Django

```bash
python manage.py runserver
```

Server akan berjalan di `http://localhost:8000`

### 5. Setup LocalTunnel

Untuk mengakses API dari perangkat mobile, gunakan LocalTunnel:

#### Install LocalTunnel (jika belum terinstal)

```bash
npm install -g localtunnel
```

#### Jalankan LocalTunnel

Buka terminal baru dan jalankan:

```bash
lt --port 8000 --subdomain ecoscan
```

API Anda sekarang dapat diakses di: `https://ecoscan.loca.lt`

> **Tip**: Simpan URL LocalTunnel untuk dikonfigurasi di aplikasi mobile.

---

##  Konfigurasi Aplikasi Mobile

### 1. Pindah Direktori ke Mobile

```bash
cd Pemrograman_Piranti_Bergerak\mobile_app\ecoscan
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Konfigurasi API Endpoint

Buka file konfigurasi API (contoh: `Pemrograman_Piranti_Bergerak\mobile_app\ecoscan\lib\controller\controller.dart`) dan sesuaikan dengan URL LocalTunnel Anda:

```dart
final url = Uri.parse('https://ecoscan.loca.lt/api/predict-image');
```

### 4. Jalankan Aplikasi

#### Android

```bash
flutter run
```

---

##  Cara Menggunakan Aplikasi

### 1. **Halaman Utama**

<img src="screenshots/home_screen.png" width="250" alt="Home Screen">

- Setelah membuka aplikasi, Anda akan melihat halaman utama dengan dua opsi utama

### 2. **Ambil Foto dengan Kamera**

<img src="screenshots/camera_screen.png" width="250" alt="Camera Screen">

1. Tap tombol **"Ambil Foto"** atau ikon kamera
2. Arahkan kamera ke sampah yang ingin diklasifikasikan
3. Tekan tombol capture untuk mengambil foto
4. Konfirmasi foto atau ambil ulang jika diperlukan

### 3. **Upload dari Galeri**

<img src="screenshots/gallery_screen.png" width="250" alt="Gallery Screen">

1. Tap tombol **"Pilih dari Galeri"** atau ikon galeri
2. Pilih foto sampah dari galeri perangkat Anda
3. Konfirmasi pilihan foto

### 4. **Hasil Klasifikasi**

<img src="screenshots/result_screen.png" width="250" alt="Result Screen">

- Aplikasi akan menampilkan hasil klasifikasi:
  - **Kategori**: Organik atau Non-Organik
  - **Tingkat Kepercayaan**: Persentase akurasi klasifikasi
  - **Rekomendasi**: Saran pembuangan sampah yang tepat

### 5. **Fitur Tambahan**

- **Riwayat**: Lihat riwayat klasifikasi sebelumnya *(opsional)*
- **Edukasi**: Pelajari lebih lanjut tentang jenis-jenis sampah *(opsional)*
- **Pengaturan**: Sesuaikan preferensi aplikasi *(opsional)*

---

## Ecoscan

### API
- **Django** - API framework
- **Miniconda** - Environment management
- **LocalTunnel** - API tunneling

### Mobile App
- **Flutter** - UI framework
- **Dart** - Bahasa pemrograman
- **Image Picker** - Akses galeri dan foto
- **HTTP** - API communication
- **Provider** - State management untuk API
- **Shared Preferences** - Intro Screen

---

---

##  Anggota Kelompok

- **[Nama Anda]** - nim - *Developer* 
- **[Nama Anggota 2]** - nim - *Designer* 

---

## Dataset

- Dataset sampah dari [Sumber Dataset]
- Link google drive: 

---