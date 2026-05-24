import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class TambahUnitPage extends StatefulWidget {
  const TambahUnitPage({super.key});

  @override
  State<TambahUnitPage> createState() => _TambahUnitPageState();
}

class _TambahUnitPageState extends State<TambahUnitPage> {
  late TextEditingController namaUnitController;
  String? selectedStatus;
  String? selectedKondisi;
  String? selectedKonsol;
  String? selectedTV;

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
        const SnackBar(content: Text('Mohon isi Nama Unit')),
      );
      return;
    }

    if (selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih Status Unit')),
      );
      return;
    }

    if (selectedKondisi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih Kondisi')),
      );
      return;
    }

    if (selectedKonsol == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih Konsol Terpasang')),
      );
      return;
    }

    if (selectedTV == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih TV Terpasang')),
      );
      return;
    }

    // Save logic here
    debugPrint("Unit baru: Nama=${namaUnitController.text}, Status=$selectedStatus, Kondisi=$selectedKondisi, Konsol=$selectedKonsol, TV=$selectedTV");
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
          'assets/images/logo.jpg',
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
                'Tambah Unit Play',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 30),
              _buildLabel('Nama Unit'),
              _buildInputField('Masukkan nama unit', namaUnitController),
              const SizedBox(height: 24),
              _buildLabel('Status Unit'),
              _buildDropdown(
                hint: 'Tersedia',
                value: selectedStatus,
                items: ['Tersedia', 'Tidak Tersedia', 'Maintenance'],
                onChanged: (val) => setState(() => selectedStatus = val),
              ),
              const SizedBox(height: 24),
              _buildLabel('Kondisi'),
              _buildDropdown(
                hint: 'Baik',
                value: selectedKondisi,
                items: ['Baik', 'Rusak', 'Dalam Perbaikan'],
                onChanged: (val) => setState(() => selectedKondisi = val),
              ),
              const SizedBox(height: 24),
              _buildLabel('Konsol Terpasang'),
              _buildDropdown(
                hint: 'Pilih Konsol',
                value: selectedKonsol,
                items: ['PS4-01', 'PS4-02', 'PS5-01', 'Xbox-01'],
                onChanged: (val) => setState(() => selectedKonsol = val),
              ),
              const SizedBox(height: 24),
              _buildLabel('TV Terpasang'),
              _buildDropdown(
                hint: 'Pilih TV',
                value: selectedTV,
                items: ['TV-01', 'TV-02', 'TV-03', 'TV-04'],
                onChanged: (val) => setState(() => selectedTV = val),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      );

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) =>
      Container(
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
