import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class TambahTVPage extends StatefulWidget {
  const TambahTVPage({super.key});

  @override
  State<TambahTVPage> createState() => _TambahTVPageState();
}

class _TambahTVPageState extends State<TambahTVPage> {
  late TextEditingController idTVController;
  late TextEditingController namaTVController;
  late TextEditingController modelTVController;
  String? selectedKondisi;
  String? selectedStatus;

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

  void _handleSimpan() {
    if (idTVController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Mohon isi ID TV')));
      return;
    }

    if (namaTVController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Mohon isi Nama TV')));
      return;
    }

    if (modelTVController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Mohon isi Model TV')));
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
      "TV baru: ID=${idTVController.text}, Nama=${namaTVController.text}, Model=${modelTVController.text}, Kondisi=$selectedKondisi, Status=$selectedStatus",
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
                'Tambah TV Baru',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 30),
              _buildLabel('ID TV'),
              _buildInputField('Masukkan ID TV', idTVController),
              const SizedBox(height: 24),
              _buildLabel('Nama TV'),
              _buildInputField('Masukkan nama TV', namaTVController),
              const SizedBox(height: 24),
              _buildLabel('Model TV'),
              _buildInputField('Masukkan model TV', modelTVController),
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
