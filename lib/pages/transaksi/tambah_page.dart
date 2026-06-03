import 'package:flutter/material.dart';
import 'package:dfw_playstation/core/app_colors.dart';
import 'package:dfw_playstation/services/api_service.dart';

class TambahTransaksiPage extends StatefulWidget {
  const TambahTransaksiPage({super.key});

  @override
  State<TambahTransaksiPage> createState() => _TambahTransaksiPageState();
}

class _TambahTransaksiPageState extends State<TambahTransaksiPage> {
  final ApiService _apiService = ApiService();

  String? selectedUnitId;
  String? selectedPelangganId;
  String selectedType = 'Main di Tempat';
  String selectedDuration = '1';
  int totalEstimasi = 0;
  int hargaPerJamAktif = 12000;

  List<dynamic> _units = [];
  List<dynamic> _customers = [];
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadFormData();
  }

  void _loadFormData() async {
    final u = await _apiService.fetchUnitData();
    final p = await _apiService.fetchPelangganData();
    if (!mounted) return;
    setState(() {
      _units = u.where((element) => element['status'] == 'Tersedia').toList();
      _customers = p;
      _isLoading = false;
    });
  }

  // FIX INTEGRASI: Mendeteksi tipe asli konsol dari data join objek database
  void _onUnitChanged(String? unitId) async {
    if (unitId == null) return;

    // 1. Cari data unit yang dipilih admin
    final selectedUnit = _units.firstWhere((u) => u['id'].toString() == unitId);

    // 2. Baca string tipe konsol murni ('PS3', 'PS4', 'PS5') dari object API
    // Kita cek field 'tipe' atau ekstraksi nama unitnya secara berlapis agar aman
    String tipeKonsolMurni = selectedUnit['tipe']?.toString() ?? '';

    if (tipeKonsolMurni.isEmpty) {
      String namaUnitLengkap =
          selectedUnit['nama_unit']?.toString().toUpperCase() ?? '';
      String kodeKonsol =
          selectedUnit['konsol_id']?.toString().toUpperCase() ?? '';

      if (namaUnitLengkap.contains('PS5') || kodeKonsol.contains('PS5')) {
        tipeKonsolMurni = 'PS5';
      } else if (namaUnitLengkap.contains('PS3') ||
          kodeKonsol.contains('PS3')) {
        tipeKonsolMurni = 'PS3';
      } else {
        tipeKonsolMurni = 'PS4'; // Default fallback aman
      }
    }

    // 3. Ambil harga sewa per jam real-time dari menu Pengaturan Laravel
    int tarifRealTime = await _apiService.getTarifByTipe(tipeKonsolMurni);

    setState(() {
      selectedUnitId = unitId;
      hargaPerJamAktif = tarifRealTime;
      // Hitung total estimasi harga baru secara presisi
      totalEstimasi = int.parse(selectedDuration) * hargaPerJamAktif;
    });
  }

  void _hitungHarga(String durasi) {
    setState(() {
      selectedDuration = durasi;
      totalEstimasi = int.parse(durasi) * hargaPerJamAktif;
    });
  }

  void _prosesSewa() async {
    if (selectedPelangganId == null || selectedUnitId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi Unit dan Pelanggan!')),
      );
      return;
    }

    setState(() => _isSaving = true);

    bool sukses = await _apiService.tambahTransaksi(
      selectedPelangganId!,
      selectedUnitId!,
      selectedType,
      selectedDuration,
      totalEstimasi.toString(),
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (sukses) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaksi Berhasil Dimulai!'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );

      if (Navigator.canPop(context)) {
        Navigator.pop(context, true);
      } else {
        Navigator.pushReplacementNamed(context, '/transaksi');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal membuat transaksi!'),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/transaksi');
            }
          },
        ),
        title: const Text(
          'Mulai Transaksi Baru',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Pilih Unit Play'),
                  _buildDropdown(
                    selectedUnitId,
                    'Pilih Unit Play',
                    _units
                        .map(
                          (u) => DropdownMenuItem<String>(
                            value: u['id'].toString(),
                            child: Text(
                              '${u['nama_unit']} (${u['konsol_id'] ?? '-'})',
                            ),
                          ),
                        )
                        .toList(),
                    (val) => _onUnitChanged(val),
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Pilih Pelanggan'),
                  _buildDropdown(
                    selectedPelangganId,
                    'Pilih Pelanggan',
                    _customers
                        .map(
                          (c) => DropdownMenuItem<String>(
                            value: c['id'].toString(),
                            child: Text(c['nama_pelanggan'] ?? '-'),
                          ),
                        )
                        .toList(),
                    (val) => setState(() => selectedPelangganId = val),
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Tipe Penyewaan'),
                  _buildDropdown(
                    selectedType,
                    null,
                    ['Main di Tempat', 'Dibawa Pulang']
                        .map(
                          (val) =>
                              DropdownMenuItem(value: val, child: Text(val)),
                        )
                        .toList(),
                    (val) => setState(() => selectedType = val!),
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Durasi Jam'),
                  _buildDropdown(
                    selectedDuration,
                    null,
                    ['1', '2', '3', '4', '5']
                        .map(
                          (val) => DropdownMenuItem(
                            value: val,
                            child: Text('$val Jam'),
                          ),
                        )
                        .toList(),
                    (val) => _hitungHarga(val!),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Total Estimasi Harga',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Rp ${totalEstimasi.toString()}',
                    style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
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
                              child: _buildFooterButton(
                                'Batal',
                                Colors.grey.shade300,
                                Colors.black,
                                () {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  } else {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/transaksi',
                                    );
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildFooterButton(
                                'Mulai Sewa',
                                AppColors.primaryGreen,
                                Colors.white,
                                _prosesSewa,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  Widget _buildDropdown(
    String? value,
    String? hint,
    List<DropdownMenuItem<String>> items,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: hint != null ? Text(hint) : null,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildFooterButton(
    String text,
    Color bg,
    Color textColor,
    VoidCallback onTap,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
