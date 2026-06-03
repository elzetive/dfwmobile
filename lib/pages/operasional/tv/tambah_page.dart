import 'package:flutter/material.dart';
import 'package:dfw_playstation/core/app_colors.dart';
import 'package:dfw_playstation/services/api_service.dart';

class TambahTVPage extends StatefulWidget {
  const TambahTVPage({super.key});

  @override
  State<TambahTVPage> createState() => _TambahTVPageState();
}

class _TambahTVPageState extends State<TambahTVPage> {
  final ApiService _apiService = ApiService();
  late TextEditingController idTVController;
  late TextEditingController namaTVController;
  late TextEditingController modelTVController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    idTVController = TextEditingController();
    namaTVController = TextEditingController();
    modelTVController = TextEditingController();
  }

  @override
  void dispose() {
    idTVController.dispose();
    namaTVController.dispose();
    modelTVController.dispose();
    super.dispose();
  }

  void _handleSimpan() async {
    if (idTVController.text.trim().isEmpty ||
        namaTVController.text.trim().isEmpty ||
        modelTVController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi seluruh kolom teks TV!')),
      );
      return;
    }

    setState(() => _isSaving = true);
    bool sukses = await _apiService.tambahTv(
      idTVController.text.trim(),
      namaTVController.text.trim(),
      modelTVController.text.trim(),
      'Baik',
      'Tersedia',
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (sukses) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data Hardware TV Berhasil Disimpan!'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );

      // FIX BLANK SCREEN: Proteksi navigasi web browser
      if (Navigator.canPop(context)) {
        Navigator.pop(context, true);
      } else {
        Navigator.pushReplacementNamed(context, '/daftar-tv');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan TV baru. Periksa ID Kembali.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        title: const Text(
          'Tambah TV Baru',
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tambah TV Baru',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 30),
              _buildLabel('ID / Kode Hardware TV'),
              _buildInputField('Contoh: TV-05', idTVController),
              const SizedBox(height: 24),
              _buildLabel('Nama Merk TV'),
              _buildInputField('Contoh: Samsung Smart TV 43', namaTVController),
              const SizedBox(height: 24),
              _buildLabel('Model Seri TV'),
              _buildInputField(
                'Masukkan nomor seri model TV',
                modelTVController,
              ),
              const SizedBox(height: 60),
              _isSaving
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryGreen,
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // FIX BLANK SCREEN: Proteksi tombol Batal
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              } else {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/daftar-tv',
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade300,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Batal',
                              style: TextStyle(
                                color: AppColors.darkGrey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _handleSimpan,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Simpan',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: AppColors.darkGrey,
      ),
    ),
  );

  Widget _buildInputField(String hint, TextEditingController controller) =>
      TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
      );
}
