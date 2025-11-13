import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'controller/controller.dart';
import 'page/aboutapp.dart';
import 'page/hasildeteksi.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (context) => PredictionProvider(),
    child: const EcoScanApp(),
  ),
);

class EcoScanApp extends StatefulWidget {
  const EcoScanApp({super.key});

  @override
  State<EcoScanApp> createState() => _EcoScanAppState();
}

class _EcoScanAppState extends State<EcoScanApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF8AB08A),
      brightness: Brightness.light,
    );
    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF404940),
      brightness: Brightness.dark,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoScan',
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 50, fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(fontSize: 12.5, height: 1.2),
          labelLarge: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 50, fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(fontSize: 12.5, height: 1.2),
          labelLarge: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      home: EcoScanHome(
        onToggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class EcoScanHome extends StatelessWidget {
  const EcoScanHome({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CircleIconButton(
                        icon: isDarkMode
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        onTap: onToggleTheme,
                      ),
                      _CircleIconButton(
                        icon: Icons.info_outline_rounded,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AboutAppPage(isDarkMode: isDarkMode),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // JUDUL
                  Text(
                    'EcoScan',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 30),
                  // DESKRIPSI
                  Text(
                    'mengklasifikasikan sampah\norganik atau non organik',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 30),
                  // TOMBOL PILIH GAMBAR
                  FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      backgroundColor: cs.primaryContainer,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        useSafeArea: true,
                        isScrollControlled: false,
                        showDragHandle: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        // MODIFIKASI: Hapus const
                        builder: (context) => EcoBottomSheet(),
                      );
                    },
                    child: const Text('Pilih Gambar'),
                  ),
                  const SizedBox(height: 30),
                  // KARTU PANDUAN
                  _GuideCard(
                    title: Text(
                      'Panduan Penggunaan',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.5,
                      ),
                    ),
                    accent: cs.primaryContainer,
                    children: const [
                      _PreviewArea(),
                      SizedBox(height: 10),
                      _DividerShort(),
                      SizedBox(height: 6),
                      _StepsGrid(),
                    ],
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

/* === Komponen Kecil === */

// _CircleIconButton, _GuideCard, _PreviewArea, _DividerShort, _StepsGrid
// TIDAK ADA PERUBAHAN DI SINI
// ... (salin semua widget _CircleIconButton s/d _StepsGrid dari kode lama Anda)
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).colorScheme.onSurface;
    return InkResponse(
      onTap: onTap,
      radius: 20,
      child: Icon(icon, size: 24, color: iconColor),
    );
  }
}

class _GuideCard extends StatelessWidget {
  final Widget title;
  final List<Widget> children;
  final Color accent;

  const _GuideCard({
    required this.title,
    required this.children,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header title
          Center(child: title),
          const SizedBox(height: 20),
          // Inner white panel
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewArea extends StatelessWidget {
  const _PreviewArea();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE7E7E7),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}

class _DividerShort extends StatelessWidget {
  const _DividerShort();

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        width: 140,
        height: 6,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class _StepsGrid extends StatelessWidget {
  const _StepsGrid();

  @override
  Widget build(BuildContext context) {
    final item = Column(
      children: [
        Container(
          height: 90,
          decoration: BoxDecoration(
            color: const Color(0xFFE7E7E7),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 6,
          width: 90,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: item),
            const SizedBox(width: 10),
            Expanded(child: item),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: item),
            const SizedBox(width: 10),
            Expanded(child: item),
          ],
        ),
      ],
    );
  }
}
// --- Akhir dari komponen yang tidak berubah ---

class EcoBottomSheet extends StatelessWidget {
  // MODIFIKASI: Hapus const
  EcoBottomSheet({super.key});

  // MODIFIKASI: Logika _pickImage diganti total
  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    // 1. Dapatkan provider dan navigator context
    final provider = Provider.of<PredictionProvider>(context, listen: false);
    final navigator = Navigator.of(context);

    // 2. Panggil fungsi pickImage dari provider
    await provider.pickImage(source);

    // 3. Tutup bottom sheet terlebih dahulu
    if (context.mounted) {
      navigator.pop(); // Tutup bottom sheet

      if (provider.imageFile != null) {
        try {
          // 4. Panggil predictImage dan tunggu hasil
          final success = await provider.predictImage();

          // 5. Jika berhasil, navigasi ke halaman hasil
          if (success && provider.predictionMessage != null) {
            navigator.push(
              MaterialPageRoute(builder: (context) => const HasilDeteksi()),
            );
          }
        } catch (e) {
          // Jika ada error, abaikan saja (error sudah di-handle di controller)
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 25, 24, 80),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Judul
          Text(
            'Pilih Gambar Sampah',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 30),
          // Tombol Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _PhotoOptionButton(
                icon: Icons.photo_library_rounded,
                label: 'Galeri',
                onTap: () => _pickImage(context, ImageSource.gallery),
              ),
              const SizedBox(width: 50),
              _PhotoOptionButton(
                icon: Icons.camera_alt_rounded,
                label: 'Kamera',
                onTap: () => _pickImage(context, ImageSource.camera),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PhotoOptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PhotoOptionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.primary.withOpacity(0.5), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 56, color: cs.primary),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
