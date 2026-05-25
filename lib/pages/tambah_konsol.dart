import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class TambahKonsolPage extends StatefulWidget {
  const TambahKonsolPage({super.key});

  @override
  State<TambahKonsolPage> createState() => _TambahKonsolPageState();
}

class _TambahKonsolPageState extends State<TambahKonsolPage> {
  late TextEditingController namaUnitController;
  String? selectedTipe;
  String? selectedKondisi;
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    namaUnitController = TextEditingController();
  }

  @override
  void dispose() {
    namaUnitController.dispose();
    super.dispose();
  }

  void _handleSimpan() {
    if (namaUnitController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi Nama Unit Konsol')),
      );
      return;
    }

    if (selectedTipe == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Mohon pilih Tipe Konsol')));
      return;
    }

    if (selectedKondisi == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Mohon pilih Kondisi Unit')));
      return;
    }

    if (selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih Status Ketersediaan')),
      );
      return;
    }

    // Save logic here
    debugPrint(
      "Konsol baru: $namaUnitController.text, Tipe: $selectedTipe, Kondisi: $selectedKondisi, Status: $selectedStatus",
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.darkGrey),
          onPressed: () {},
        ),
        title: Image.asset(
          'assets/images/logo.png',
          height: 35,
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              'DFW Playstation',
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
            );
          },
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
                'Tambah Konsol Baru',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 30),
              _buildLabel('Nama Unit Konsol'),
              _buildInputField('Masukkan nama unit', namaUnitController),
              const SizedBox(height: 24),
              _buildLabel('Tipe Konsol'),
              _buildDropdown(
                hint: 'Pilih Tipe',
                value: selectedTipe,
                items: ['PS4', 'PS5', 'Xbox One', 'Nintendo Switch'],
                onChanged: (val) => setState(() => selectedTipe = val),
              ),
              const SizedBox(height: 24),
              _buildLabel('Kondisi Unit'),
              _buildDropdown(
                hint: 'Pilih Kondisi',
                value: selectedKondisi,
                items: ['Baik', 'Rusak', 'Dalam Perbaikan'],
                onChanged: (val) => setState(() => selectedKondisi = val),
              ),
              const SizedBox(height: 24),
              _buildLabel('Status Ketersediaan'),
              _buildDropdown(
                hint: 'Pilih Status',
                value: selectedStatus,
                items: ['Tersedia', 'Tidak Tersedia', 'Maintenance'],
                onChanged: (val) => setState(() => selectedStatus = val),
              ),
              const SizedBox(height: 60),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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

  Widget _buildLabel(String text) => Container(
    alignment: Alignment.centerLeft,
    margin: const EdgeInsets.only(bottom: 12),
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
