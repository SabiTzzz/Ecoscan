import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/controller.dart';

class HasilDeteksi extends StatefulWidget {
  const HasilDeteksi({super.key});

  @override
  State<HasilDeteksi> createState() => _HasilDeteksiState();
}

class _HasilDeteksiState extends State<HasilDeteksi> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runPrediction();
    });
  }

  Future<void> _runPrediction() async {
    final provider = Provider.of<PredictionProvider>(context, listen: false);
    if (provider.imageFile == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);
    await provider.predictImage();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final provider = Provider.of<PredictionProvider>(context);

    String getPredictionType() {
      if (provider.predictionMessage != null) {
        final message = provider.predictionMessage!.toLowerCase();
        if (message == 'organik') {
          return 'ORGANIK';
        } else if (message == 'non-organik') {
          return 'NON-ORGANIK';
        }
      }
      return _isLoading ? 'MEMPROSES...' : 'TIDAK DITEMUKAN';
    }

    String getDescription() {
      final type = getPredictionType().toLowerCase();
      if (type == 'organik') {
        return 'Dari gambar yang anda berikan terdeteksi bahwa sampah tersebut adalah sampah organik';
      } else if (type == 'non-organik') {
        return 'Dari gambar yang anda berikan terdeteksi bahwa sampah tersebut adalah sampah non-organik';
      } else if (_isLoading) {
        return provider.predictionMessage ?? 'Sedang memproses gambar...';
      } else {
        return provider.predictionMessage ?? 'Tidak ada hasil deteksi.';
      }
    }

    return WillPopScope(
      onWillPop: () async => !_isLoading,
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                if (_isLoading) ...[
                  const SizedBox(height: 8),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                ],
                SizedBox(
                  width: 160,
                  child: FilledButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            provider.clear();
                            Navigator.pop(context);
                          },
                    style: FilledButton.styleFrom(
                      backgroundColor: _isLoading
                          ? cs.onSurface.withOpacity(0.12)
                          : cs.primary,
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
                        color: _isLoading
                            ? cs.onSurface.withOpacity(0.38)
                            : cs.onPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
