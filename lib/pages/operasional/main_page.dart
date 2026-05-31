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

  @override
  void initState() {
    super.initState();
    _unitData = _apiService.fetchUnitData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _unitData = _apiService.fetchUnitData();
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
                      'Operasional',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/daftar-konsol',
                            ).then((_) => _refreshData()),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.primaryGreen,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Daftar Konsol',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/daftar-tv',
                            ).then((_) => _refreshData()),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.primaryGreen,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Daftar TV',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/tambah-unit',
                      ).then((_) => _refreshData()),
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text('Tambah Unit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Unit Play yang Terdaftar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    list.isEmpty
                        ? const Center(
                            child: Text('Belum ada kombinasi unit play.'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return _buildUnitCard(list[index]);
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

  Widget _buildUnitCard(Map<String, dynamic> unit) {
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
                  unit['nama_unit'] ?? '-',
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
                    border: Border.all(color: AppColors.primaryGreen),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    unit['status'] ?? 'Tersedia',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Konsol Aktif : ${unit['nama_konsol']}',
              style: const TextStyle(fontSize: 14, color: AppColors.darkGrey),
            ),
            const SizedBox(height: 4),
            Text(
              'Monitor TV  : ${unit['nama_tv']}',
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
