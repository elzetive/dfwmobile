import 'package:flutter/material.dart';
import 'package:dfw_playstation/core/app_colors.dart';
import 'package:dfw_playstation/widgets/side_bar.dart';
import 'package:dfw_playstation/services/api_service.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({super.key});

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  final ApiService _apiService = ApiService();
  bool _isEditing = false;
  bool _isLoading = true;

  late TextEditingController _namaController;
  late TextEditingController _jamController;
  late TextEditingController _ps4Controller;
  late TextEditingController _ps5Controller;
  late TextEditingController _xboxController;
  late TextEditingController _nintendoController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController();
    _jamController = TextEditingController();
    _ps4Controller = TextEditingController();
    _ps5Controller = TextEditingController();
    _xboxController = TextEditingController();
    _nintendoController = TextEditingController();
    _loadData();
  }

  // # Fungsi narik data pertama kali halaman dibuka
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final response = await _apiService.fetchPengaturan();
    
    if (response['success'] == true) {
      final data = response['data'];
      _namaController.text = data['nama_usaha'].toString();
      _jamController.text = data['jam_operasional'].toString();
      _ps4Controller.text = data['harga_ps4'].toString();
      _ps5Controller.text = data['harga_ps5'].toString();
      _xboxController.text = data['harga_xbox'].toString();
      _nintendoController.text = data['harga_nintendo'].toString();
    }
    setState(() => _isLoading = false);
  }

  // # Fungsi nyimpen data ke Laravel
  Future<void> _simpanPengaturan() async {
    setState(() => _isLoading = true);
    
    bool sukses = await _apiService.editPengaturan(
      _namaController.text,
      _jamController.text,
      _ps4Controller.text,
      _ps5Controller.text,
      _xboxController.text,
      _nintendoController.text,
    );

    setState(() {
      _isLoading = false;
      if (sukses) _isEditing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(sukses ? 'Pengaturan berhasil disimpan!' : 'Gagal menyimpan pengaturan!'),
          backgroundColor: sukses ? AppColors.primaryGreen : Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jamController.dispose();
    _ps4Controller.dispose();
    _ps5Controller.dispose();
    _xboxController.dispose();
    _nintendoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      drawer: const SideBar(),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 30,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.sports_esports,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(width: 10),
            // # Bikin nama usaha di AppBar ikut dinamis
            Text(
              _namaController.text.isNotEmpty ? _namaController.text : '',
              style: const TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pengaturan',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _isEditing ? _buildEditMode() : _buildViewMode(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildViewMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildViewText('Nama Usaha', _namaController.text),
        const Divider(color: Color(0xFFEEEEEE), height: 24),
        _buildViewText('Jam Operasional', _jamController.text),
        const Divider(color: Color(0xFFEEEEEE), height: 24),
        const Text(
          'Harga Konsol (Per Jam)',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        _buildHargaCardView('Playstation 4', 'Rp ${_ps4Controller.text}'),
        _buildHargaCardView('Playstation 5', 'Rp ${_ps5Controller.text}'),
        _buildHargaCardView('Xbox One', 'Rp ${_xboxController.text}'),
        _buildHargaCardView('Nintendo Switch', 'Rp ${_nintendoController.text}'),
        const SizedBox(height: 32),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () => setState(() => _isEditing = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Edit Pengaturan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildEditMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Nama Usaha', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildTextField(_namaController),
        const SizedBox(height: 16),
        
        const Text('Jam Operasional', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildTextField(_jamController),
        const SizedBox(height: 24),
        
        const Text('Harga Konsol (Per Jam)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildHargaCardEdit('Playstation 4', _ps4Controller),
        _buildHargaCardEdit('Playstation 5', _ps5Controller),
        _buildHargaCardEdit('Xbox One', _xboxController),
        _buildHargaCardEdit('Nintendo Switch', _nintendoController),
        const SizedBox(height: 32),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => setState(() {
                _isEditing = false;
                _loadData(); // # Kalo batal, balikin datanya seperti semula
              }),
              style: TextButton.styleFrom(backgroundColor: Colors.grey.shade200),
              child: const Text('Batal', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _simpanPengaturan,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
              child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildViewText(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 16, color: Colors.black54)),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryGreen),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildHargaCardView(String konsol, String harga) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(konsol, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          Text(harga, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
        ],
      ),
    );
  }

  Widget _buildHargaCardEdit(String konsol, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(konsol, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
          Expanded(
            flex: 3,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: 'Rp ',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primaryGreen),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}