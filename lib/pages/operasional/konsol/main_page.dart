import 'package:flutter/material.dart';
import 'package:dfw_playstation/core/app_colors.dart';
import 'package:dfw_playstation/widgets/side_bar.dart';
import 'package:dfw_playstation/services/api_service.dart';

class DaftarKonsolPage extends StatefulWidget {
  const DaftarKonsolPage({super.key});

  @override
  State<DaftarKonsolPage> createState() => _DaftarKonsolPageState();
}

class _DaftarKonsolPageState extends State<DaftarKonsolPage> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _konsolData;

  @override
  void initState() {
    super.initState();
    _konsolData = _apiService.fetchKonsolData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _konsolData = _apiService.fetchKonsolData();
    });
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

  void _showEditDialog(Map<String, dynamic> konsol) {
    final nameCtrl = TextEditingController(text: konsol['nama_unit']);
    String currentTipe = konsol['tipe'] ?? 'PS4';
    String currentKondisi = konsol['kondisi'] ?? 'Baik';
    String currentStatus = konsol['status'] ?? 'Tersedia';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Edit Hardware Konsol #${konsol['id']}',
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
                  'Nama Unit Hardware',
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
                  'Tipe Generasi',
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
                      value: currentTipe,
                      isExpanded: true,
                      items: ['PS3', 'PS4', 'PS5']
                          .map(
                            (t) => DropdownMenuItem(value: t, child: Text(t)),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setDialogState(() => currentTipe = val!),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Kondisi Fisik',
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
                      value: currentKondisi,
                      isExpanded: true,
                      items: ['Baik', 'Rusak', 'Dalam Perbaikan']
                          .map(
                            (t) => DropdownMenuItem(value: t, child: Text(t)),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setDialogState(() => currentKondisi = val!),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Status Ketersediaan',
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
                bool ok = await _apiService.editKonsol(
                  konsol['id'].toString(),
                  nameCtrl.text.trim(),
                  currentTipe,
                  currentKondisi,
                  currentStatus,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  if (ok) _refreshData();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
              ),
              child: const Text(
                'Simpan',
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

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Data Hardware?'),
        content: const Text(
          'Menghapus hardware konsol ini otomatis akan memutuskan Kombinasi Unit Terpasang yang memakainya di menu operasional. Lanjutkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              bool ok = await _apiService.hapusKonsol(id);
              if (context.mounted) {
                Navigator.pop(context);
                if (ok) _refreshData();
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/operasional');
            }
          },
        ),
        title: const Text(
          'Daftar Hardware Konsol',
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: AppColors.primaryGreen,
          child: FutureBuilder<List<dynamic>>(
            future: _konsolData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryGreen,
                  ),
                );
              }
              final list = snapshot.data ?? [];

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
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
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.darkGrey,
                          size: 16,
                        ),
                        label: const Text(
                          'Kembali',
                          style: TextStyle(
                            color: AppColors.darkGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          elevation: 0,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          '/tambah-konsol',
                        ).then((_) => _refreshData()),
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 16,
                        ),
                        label: const Text(
                          'Tambah Konsol',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  if (list.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Text(
                          'Belum ada hardware konsol terdaftar.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...list.map((konsol) => _buildKonsolCard(konsol)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildKonsolCard(Map<String, dynamic> konsol) {
    String status = konsol['status'] ?? 'Tersedia';
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                konsol['nama_unit'] ?? '-',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'ID Unit :  ${konsol['id']}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Tipe Generasi :  ${konsol['tipe']}',
                style: const TextStyle(color: Colors.black87, fontSize: 13),
              ),
              Text(
                'Kondisi Fisik :  ${konsol['kondisi']}',
                style: const TextStyle(color: Colors.black87, fontSize: 13),
              ),
            ],
          ),
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
              const SizedBox(height: 20),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.orange,
                      size: 20,
                    ),
                    onPressed: () => _showEditDialog(konsol),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: () => _confirmDelete(konsol['id'].toString()),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
