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
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        foregroundColor: iconColor,
        elevation: 0,
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
                      fontSize: 24,
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
                  ),

                  const SizedBox(height: 24),

                  // Logo aplikasi (pakai asset jika ada, fallback FlutterLogo)
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/ecoscan.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const FlutterLogo(size: 72);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Optional: versi atau hak cipta kecil di bawah
                  Text(
                    '© ${DateTime.now().year} EcoScan',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 24),
                  // Tombol Kembali di bawah mirip HasilDeteksi
                  SizedBox(
                    width: 160,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: cs.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Kembali',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: cs.onPrimary,
                        ),
                      ),
                    ),
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
