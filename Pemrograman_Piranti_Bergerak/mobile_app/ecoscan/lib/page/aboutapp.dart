import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  final bool isDarkMode;

  const AboutAppPage({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Gunakan flag isDarkMode yang dikirim dari main.dart
    final iconColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        // Pakai primary agar hijau terang di light, hijau gelap di dark (didefinisikan di main.dart)
        backgroundColor: cs.primaryContainer,
        // Gunakan warna ikon yang sesuai tema
        foregroundColor: iconColor,
        iconTheme: IconThemeData(color: iconColor),
        actionsIconTheme: IconThemeData(color: iconColor),
        elevation: 0,
        // biarkan title kosong — judul utama ada di body sesuai permintaan
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Judul utama di bawah AppBar
                  Text(
                    'Tentang Aplikasi',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Deskripsi aplikasi (justify)
                  Text(
                    'EcoScan adalah aplikasi sederhana yang membantu pengguna '
                    'mengklasifikasikan sampah menjadi kategori organik dan non-organik menggunakan '
                    'kamera perangkat atau gambar dari galeri. Aplikasi ini dirancang untuk memudahkan '
                    'pembuangan sampah dan meningkatkan kesadaran lingkungan. Data gambar diproses secara '
                    'lokal di perangkat (atau sesuai model yang diintegrasikan), dan aplikasi tidak mengirimkan '
                    'gambar ke server tanpa persetujuan pengguna. Harap gunakan aplikasi ini sebagai panduan; '
                    'hasil klasifikasi tidak menggantikan kebijakan atau aturan pengelolaan sampah setempat.',
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 24),

                  // Logo aplikasi (fallback FlutterLogo jika tidak ada asset)
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          // Jika nanti ada asset logo, ganti dengan Image.asset('assets/logo.png')
                          FlutterLogo(size: 72),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Optional: versi atau hak cipta kecil di bawah
                  Text(
                    '© ${DateTime.now().year} EcoScan',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
