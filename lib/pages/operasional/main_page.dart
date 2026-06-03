import 'package:flutter/material.dart';
import 'package:dfw_playstation/core/app_colors.dart';
import 'package:dfw_playstation/widgets/side_bar.dart';
import 'package:dfw_playstation/services/api_service.dart';

class OperasionalPage extends StatefulWidget {
  const OperasionalPage({super.key});

  @override
  State<OperasionalPage> createState() => _OperasionalPageState();
}

class _OperasionalPageState extends State<OperasionalPage> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _unitData;
  List<dynamic> _konsols = [];
  List<dynamic> _tvs = [];

  @override
  void initState() {
    super.initState();
    _unitData = _apiService.fetchUnitData();
    _loadRelations();
  }

  void _loadRelations() async {
    _konsols = await _apiService.fetchKonsolData();
    _tvs = await _apiService.fetchTvData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _unitData = _apiService.fetchUnitData();
    });
    _loadRelations();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Tersedia':
        return AppColors.primaryGreen;
      case 'Tidak Tersedia':
        return Colors.red;
      case 'Maintenance':
      default:
        return Colors.orange;
    }
  }

  void _showEditDialog(Map<String, dynamic> unit) {
    final nameCtrl = TextEditingController(text: unit['nama_unit']);
    String currentKSL =
        unit['konsol_id']?.toString() ??
        (_konsols.isNotEmpty ? _konsols.first['id'].toString() : '');
    String currentTV =
        unit['tv_id']?.toString() ??
        (_tvs.isNotEmpty ? _tvs.first['id'].toString() : '');
    String currentStatus = unit['status'] ?? 'Tersedia';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Edit Kombinasi Unit #${unit['id']}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nama Unit Play',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Konsol Terpasang',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: currentKSL.isEmpty ? null : currentKSL,
                      isExpanded: true,
                      items: _konsols.map((k) {
                        return DropdownMenuItem<String>(
                          value: k['id'].toString(),
                          child: Text('${k['id']} - ${k['nama_unit']}'),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setDialogState(() => currentKSL = val!),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Monitor/TV Terpasang',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: currentTV.isEmpty ? null : currentTV,
                      isExpanded: true,
                      items: _tvs.map((t) {
                        return DropdownMenuItem<String>(
                          value: t['id'].toString(),
                          child: Text('${t['id']} - ${t['nama_tv']}'),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setDialogState(() => currentTV = val!),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Status Operasional',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: currentStatus,
                      isExpanded: true,
                      items: ['Tersedia', 'Tidak Tersedia', 'Maintenance']
                          .map(
                            (t) => DropdownMenuItem(value: t, child: Text(t)),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setDialogState(() => currentStatus = val!),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                bool ok = await _apiService.editUnit(
                  unit['id'].toString(),
                  nameCtrl.text.trim(),
                  currentKSL,
                  currentTV,
                  currentStatus,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  if (ok) {
                    _refreshData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Kombinasi Unit Berhasil Diperbarui!'),
                        backgroundColor: AppColors.primaryGreen,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
              ),
              child: const Text(
                'Simpan Changes',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      drawer: const SideBar(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
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
            FutureBuilder<Map<String, dynamic>>(
              future: _apiService.fetchPengaturan(),
              builder: (context, snapshot) {
                String namaUsaha = 'Operasional';
                if (snapshot.hasData && snapshot.data!['success'] == true) {
                  String fullNama =
                      snapshot.data!['data']['nama_usaha']?.toString() ?? '';
                  if (fullNama.isNotEmpty) {
                    namaUsaha = '${fullNama.split(' ')[0]} Unit';
                  }
                }
                return Text(
                  namaUsaha,
                  style: const TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: AppColors.primaryGreen,
          child: FutureBuilder<List<dynamic>>(
            future: _unitData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryGreen,
                  ),
                );
              }

              final list = snapshot.data ?? [];
              final int totalUnit = list.length;
              final int unitReady = list
                  .where((u) => u['status'] == 'Tersedia')
                  .length;

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'Manajemen Operasional',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ROW SUB-MENU UTAMA (Konsol & TV)
                  Row(
                    children: [
                      Expanded(
                        child: _buildSubMenuCard(
                          title: 'Daftar Hardware\nKonsol',
                          icon: Icons.gamepad,
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/daftar-konsol',
                          ).then((_) => _refreshData()),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildSubMenuCard(
                          title: 'Daftar Hardware\nMonitor TV',
                          icon: Icons.tv,
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/daftar-tv',
                          ).then((_) => _refreshData()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // BADGE SUMMARY CARD INDIKATOR
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatBadge(
                          'Total Kombinasi',
                          '$totalUnit',
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatBadge(
                          'Unit Siap Main',
                          '$unitReady',
                          AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // BUTTON TAMBAH DATA
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      '/tambah-unit',
                    ).then((_) => _refreshData()),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Buat Kombinasi Unit Baru',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(height: 30),

                  const Text(
                    'Kombinasi Unit Play Terdaftar:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (list.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(30),
                      alignment: Alignment.center,
                      child: const Text(
                        'Belum ada susunan kombinasi unit tersimpan.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    ...list.map((unit) => _buildUnitCard(unit)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSubMenuCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryGreen, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.darkGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitCard(Map<String, dynamic> unit) {
    String status = unit['status'] ?? 'Tersedia';
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unit['nama_unit'] ?? 'Unit Tanpa Nama',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.darkGrey,
                  ),
                ),
                const Divider(height: 16),
                Row(
                  children: [
                    const Icon(Icons.gamepad, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Konsol: ${unit['nama_konsol'] ?? '-'}',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.tv, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Monitor: ${unit['nama_tv'] ?? '-'}',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: _getStatusColor(status),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.orange,
                      size: 20,
                    ),
                    onPressed: () => _showEditDialog(unit),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: () {
                      _showKonfirmasiHapus(unit['id'].toString());
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showKonfirmasiHapus(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Unit Kombinasi?'),
        content: const Text(
          'Apakah kamu yakin ingin membongkar kombinasi unit play ini? Perangkat keras konsol dan TV akan dikembalikan ke status bebas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              bool ok = await _apiService.hapusUnit(id);
              if (ok) _refreshData();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Ya, Hapus',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
