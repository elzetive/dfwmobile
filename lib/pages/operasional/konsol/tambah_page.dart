import 'package:flutter/material.dart';
import 'package:dfw_playstation/core/app_colors.dart';
import 'package:dfw_playstation/services/api_service.dart';

class TambahKonsolPage extends StatefulWidget {
  const TambahKonsolPage({super.key});

  @override
  State<TambahKonsolPage> createState() => _TambahKonsolPageState();
}

class _TambahKonsolPageState extends State<TambahKonsolPage> {
  final ApiService _apiService = ApiService();
  late TextEditingController idController;
  late TextEditingController namaUnitController;
  String? selectedTipe;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    namaUnitController = TextEditingController();
  }

  @override
  void dispose() {
    idController.dispose();
    namaUnitController.dispose();
    super.dispose();
  }

  void _handleSimpan() async {
    if (idController.text.trim().isEmpty ||
        namaUnitController.text.trim().isEmpty ||
        selectedTipe == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi seluruh formulir data konsol!'),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    // Mengirimkan 5 argumen sesuai struktur ApiService yang baru
    bool sukses = await _apiService.tambahKonsol(
      idController.text.trim(),
      namaUnitController.text.trim(),
      selectedTipe!,
      'Baik', // Argumen ke-4: Kondisi awal otomatis
      'Tersedia', // Argumen ke-5: Status awal otomatis
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (sukses) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konsol Baru Berhasil Terdaftar!'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );

      // SOLUSI BLANK SCREEN: Cek tumpukan navigasi web browser terlebih dahulu
      if (Navigator.canPop(context)) {
        Navigator.pop(context, true);
      } else {
        Navigator.pushReplacementNamed(context, '/daftar-konsol');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan konsol. ID mungkin duplikat!'),
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
          'Tambah Konsol Baru',
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
              _buildLabel('ID / Kode Unit Konsol'),
              _buildInputField('Contoh: KSL-03', idController),
              const SizedBox(height: 24),
              _buildLabel('Nama Unit Konsol'),
              _buildInputField(
                'Masukkan nama unit (Contoh: PS3 Super Slim 01)',
                namaUnitController,
              ),
              const SizedBox(height: 24),
              _buildLabel('Tipe Konsol'),
              _buildDropdown(
                hint: 'Pilih Tipe',
                value: selectedTipe,
                items: ['PS3', 'PS4', 'PS5'],
                onChanged: (val) => setState(() => selectedTipe = val),
              ),
              const SizedBox(height: 50),
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
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              } else {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/daftar-konsol',
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
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primaryGreen),
          ),
        ),
      );

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(8),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        value: value,
        hint: Text(hint),
        items: items
            .map((val) => DropdownMenuItem(value: val, child: Text(val)))
            .toList(),
        onChanged: onChanged,
      ),
    ),
  );
}
