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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      drawer: const SideBar(),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.png', height: 30),
            const SizedBox(width: 10),
            FutureBuilder<Map<String, dynamic>>(
              future: _apiService.fetchPengaturan(),
              builder: (context, snapshot) {
                String namaUsaha = '';

                if (snapshot.hasData && snapshot.data!['success'] == true) {
                  namaUsaha = snapshot.data!['data']['nama_usaha'].toString();
                }

                return Text(
                  namaUsaha.isEmpty ? 'Memuat...' : namaUsaha,
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
        centerTitle: true,
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

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final list = snapshot.data ?? [];

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daftar Konsol',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/tambah-konsol',
                        ).then((_) => _refreshData());
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text('Tambah Konsol'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    list.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Text('Belum ada data konsol di database.'),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              final konsol = list[index];
                              return _buildKonsolCard(konsol);
                            },
                          ),
                  ],
                ),
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
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderGrey),
        borderRadius: BorderRadius.circular(12),
        color: AppColors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  konsol['nama_unit'] ?? '-',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGrey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: status == 'Tersedia'
                          ? AppColors.primaryGreen
                          : Colors.orange,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      color: status == 'Tersedia'
                          ? AppColors.primaryGreen
                          : Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'ID Kode: ${konsol['id']}',
              style: const TextStyle(fontSize: 14, color: AppColors.darkGrey),
            ),
            const SizedBox(height: 4),
            Text(
              'Tipe: ${konsol['tipe']}',
              style: const TextStyle(fontSize: 14, color: AppColors.darkGrey),
            ),
            const SizedBox(height: 4),
            Text(
              'Kondisi: ${konsol['kondisi']}',
              style: const TextStyle(fontSize: 14, color: AppColors.darkGrey),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.accentOrange),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      color: AppColors.accentOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dangerRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text(
                    'Hapus',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
