import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreenPage extends StatelessWidget {
  final VoidCallback onFinish;
  const IntroScreenPage({Key? key, required this.onFinish}) : super(key: key);

  Widget _buildImage(BuildContext context, IconData icon, {String? assetPath, double size = 160}) {
    final primary = Theme.of(context).colorScheme.primary;

    if (assetPath != null) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: size,
            height: size,
            color: Colors.grey.shade100,
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(icon, size: size * 0.5, color: primary),
                );
              },
            ),
          ),
        ),
      );
    }

    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, size: size * 0.5, color: primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      PageViewModel(
        title: 'Selamat datang di EcoScan',
        body:
            'Aplikasi ini membantu mengklasifikasikan sampah menjadi organik atau non-organik menggunakan model yang telah dilatih.',
        image: _buildImage(
          context,
          Icons.eco_outlined,
          assetPath: 'assets/images/ecoscan.png',
        ),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          bodyTextStyle: TextStyle(fontSize: 16),
        ),
      ),
      PageViewModel(
        title: 'Cara Pakai',
        body: 'Ambil foto atau pilih gambar dari galeri, lalu aplikasi akan menampilkan hasil klasifikasi.',
        image: _buildImage(context, Icons.photo_camera_rounded),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          bodyTextStyle: TextStyle(fontSize: 16),
        ),
      ),
      PageViewModel(
        title: 'Tips',
        body: 'Pastikan foto jelas dan objek sampah menutupi sebagian besar area foto untuk hasil terbaik.',
        image: _buildImage(context, Icons.lightbulb_outline),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          bodyTextStyle: TextStyle(fontSize: 16),
        ),
      ),
    ];

    return IntroductionScreen(
      pages: pages,
      onDone: onFinish,
      onSkip: onFinish,
      showSkipButton: true,
      skip: const Text('Lewati'),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Selesai", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
        size: const Size(8.0, 8.0),
        activeSize: const Size(22.0, 8.0),
        activeColor: Theme.of(context).colorScheme.primary,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      globalBackgroundColor: Theme.of(context).colorScheme.surface,
      animationDuration: 300,
      controlsPadding: const EdgeInsets.all(16),
    );
  }
}
