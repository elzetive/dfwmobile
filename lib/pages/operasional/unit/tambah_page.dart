import 'package:flutter/material.dart';
import 'package:dfw_playstation/core/app_colors.dart';
import 'package:dfw_playstation/services/api_service.dart';

class TambahUnitPage extends StatefulWidget {
  const TambahUnitPage({super.key});

  @override
  State<TambahUnitPage> createState() => _TambahUnitPageState();
}

class _TambahUnitPageState extends State<TambahUnitPage> {
  final ApiService _apiService = ApiService();
  late TextEditingController namaUnitController;

  String? selectedKonsolId;
  String? selectedTVId;

  List<dynamic> _konsols = [];
  List<dynamic> _tvs = [];
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    namaUnitController = TextEditingController();
    _loadRelations();
  }

  void _loadRelations() async {
    final allKonsols = await _apiService.fetchKonsolData();
    final allTvs = await _apiService.fetchTvData();

    final registeredUnits = await _apiService.fetchUnitData();

    if (!mounted) return;

    setState(() {
      final usedKonsolIds = registeredUnits
          .map((u) => u['konsol_id'].toString())
          .toSet();
      final usedTvIds = registeredUnits
          .map((u) => u['tv_id'].toString())
          .toSet();

      _konsols = allKonsols.where((k) {
        return k['status'] == 'Tersedia' &&
            !usedKonsolIds.contains(k['id'].toString());
      }).toList();

      _tvs = allTvs.where((t) {
        return t['status'] == 'Tersedia' &&
            !usedTvIds.contains(t['id'].toString());
      }).toList();

      _isLoading = false;
    });
  }

  @override
  void dispose() {
    namaUnitController.dispose();
    super.dispose();
  }

  void _handleSimpan() async {
    if (namaUnitController.text.trim().isEmpty ||
        selectedKonsolId == null ||
        selectedTVId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon isi nama unit dan pasangkan Konsol serta TV!'),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    bool sukses = await _apiService.tambahUnit(
      namaUnitController.text.trim(),
      'Tersedia',
      'Baik',
      selectedKonsolId!,
      selectedTVId!,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (sukses) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unit Kombinasi Play Berhasil Ditambahkan!'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );

      if (Navigator.canPop(context)) {
        Navigator.pop(context, true);
      } else {
        Navigator.pushReplacementNamed(context, '/operasional');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan Kombinasi Unit Play!'),
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
          'Tambah Unit Baru',
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
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
                    _buildLabel('Nama Tempat/Unit Play'),
                    _buildInputField(
                      'Contoh: VIP Room - Unit 5',
                      namaUnitController,
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('Pilih Konsol Terpasang'),
                    _konsols.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Semua Hardware Konsol sudah terpakai di Unit lain.',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : _buildDropdown(
                            hint: 'Pilih Hardware Konsol',
                            value: selectedKonsolId,
                            items: _konsols
                                .map(
                                  (k) => DropdownMenuItem<String>(
                                    value: k['id'].toString(),
                                    child: Text(
                                      '${k['id']} - ${k['nama_unit']} (${k['tipe']})',
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                setState(() => selectedKonsolId = val),
                          ),
                    const SizedBox(height: 24),
                    _buildLabel('Pilih TV Terpasang'),
                    _tvs.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Semua Hardware TV sudah terpakai di Unit lain.',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : _buildDropdown(
                            hint: 'Pilih Hardware TV',
                            value: selectedTVId,
                            items: _tvs
                                .map(
                                  (t) => DropdownMenuItem<String>(
                                    value: t['id'].toString(),
                                    child: Text('${t['id']} - ${t['nama_tv']}'),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                setState(() => selectedTVId = val),
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
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    } else {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/operasional',
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade300,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
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
                                  onPressed: (_konsols.isEmpty || _tvs.isEmpty)
                                      ? null
                                      : _handleSimpan,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryGreen,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
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
        ),
      );

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<DropdownMenuItem<String>> items,
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
        items: items,
        onChanged: onChanged,
      ),
    ),
  );
}
