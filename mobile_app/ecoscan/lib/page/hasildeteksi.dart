import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/controller.dart';

class HasilDeteksi extends StatelessWidget {
  const HasilDeteksi({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Dapatkan provider
    final provider = Provider.of<PredictionProvider>(context);

    // Extract prediction type dari predictionMessage
    String getPredictionType() {
      if (provider.predictionMessage != null) {
        final message = provider.predictionMessage!.toLowerCase();
        if (message.contains('organik') && !message.contains('non')) {
          return 'ORGANIK';
        } else if (message.contains('non-organik') ||
            message.contains('non organik')) {
          return 'NON-ORGANIK';
        }
      }
      return 'MEMPROSES...';
    }

    // Generate deskripsi berdasarkan hasil prediksi
    String getDescription() {
      final type = getPredictionType().toLowerCase();
      if (type == 'organik') {
        return 'Dari gambar yang anda berikan terdeteksi bahwa sampah tersebut adalah sampah organik';
      } else if (type == 'non-organik') {
        return 'Dari gambar yang anda berikan terdeteksi bahwa sampah tersebut adalah sampah non-organik';
      } else {
        return 'Sedang memproses gambar...';
      }
    }

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onSurface),
          onPressed: () {
            provider.clear();
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Judul
              Text(
                getPredictionType(),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 32),

              // Gambar Container
              Container(
                width: double.infinity,
                height: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: cs.outline.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: provider.imageFile != null
                      ? Image.file(
                          provider.imageFile!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: cs.surfaceVariant,
                              child: Center(
                                child: Icon(
                                  Icons.image_outlined,
                                  size: 80,
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: cs.surfaceVariant,
                          child: Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 80,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 40),

              // Deskripsi
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  getDescription(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: cs.onSurface.withOpacity(0.8),
                  ),
                ),
              ),

              const Spacer(),

              // Tombol Kembali
              SizedBox(
                width: 160,
                child: FilledButton(
                  onPressed: () {
                    provider.clear();
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: cs.primaryContainer.withOpacity(0.8),
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

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
