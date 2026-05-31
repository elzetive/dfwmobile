import 'package:flutter/material.dart';
import 'package:dfw_playstation/core/app_colors.dart';
import 'package:dfw_playstation/services/api_service.dart';

class UbahPelangganPage extends StatefulWidget {
  final String id;
  final String namaLama;
  final String teleponLama;
  final String alamatLama;
  final String statusLama;

  const UbahPelangganPage({
    super.key,
    required this.id,
    required this.namaLama,
    required this.teleponLama,
    required this.alamatLama,
    required this.statusLama,
  });

  @override
  State<UbahPelangganPage> createState() => _UbahPelangganPageState();
}

class _UbahPelangganPageState extends State<UbahPelangganPage> {
  final ApiService _apiService = ApiService();
  
  late TextEditingController _namaController;
  late TextEditingController _teleponController;
  late TextEditingController _alamatController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.namaLama);
    _teleponController = TextEditingController(text: widget.teleponLama);
    _alamatController = TextEditingController(text: widget.alamatLama);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _teleponController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future<void> _simpanPerubahan() async {
    if (_namaController.text.isEmpty || _teleponController.text.isEmpty || _alamatController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom wajib diisi!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    // # Tetep kirim status lama ke API biar ga error validasi Laravelnya
    bool sukses = await _apiService.editPelanggan(
      widget.id,
      _namaController.text,
      _teleponController.text,
      _alamatController.text,
      widget.statusLama, 
    );

    setState(() => _isLoading = false);

    if (sukses && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil diubah!'), backgroundColor: AppColors.primaryGreen),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengubah data.'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Ubah Pelanggan', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Ubah Data Pelanggan #${widget.id}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 30),
                
                _buildLabel('Nama Pelanggan'),
                TextField(
                  controller: _namaController,
                  decoration: _inputStyle(),
                ),
                const SizedBox(height: 16),
                
                _buildLabel('Nomor Telepon (WhatsApp)'),
                TextField(
                  controller: _teleponController,
                  keyboardType: TextInputType.phone,
                  decoration: _inputStyle(),
                ),
                const SizedBox(height: 16),
                
                _buildLabel('Alamat Lengkap'),
                TextField(
                  controller: _alamatController,
                  maxLines: 3,
                  decoration: _inputStyle(),
                ),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Batal', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _simpanPerubahan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _isLoading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
    );
  }

  InputDecoration _inputStyle() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primaryGreen)),
    );
  }
}