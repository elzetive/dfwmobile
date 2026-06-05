import 'package:flutter/material.dart';
import 'package:dfw_playstation/core/app_colors.dart';
import 'package:dfw_playstation/widgets/side_bar.dart';
import 'package:dfw_playstation/services/api_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver {
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>> _dashboardData;
  late Future<List<dynamic>> _transactionData;
  late Future<Map<String, dynamic>> _settingData;

  @override
  void initState() {
    super.initState();
    _loadAllData();
    WidgetsBinding.instance.addObserver(this);
  }

  void _loadAllData() {
    _dashboardData = _apiService.fetchDashboardData();
    _transactionData = _apiService.fetchSemuaTransaksi();
    _settingData = _apiService.fetchPengaturan();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshData();
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _dashboardData = _apiService.fetchDashboardData();
      _transactionData = _apiService.fetchSemuaTransaksi();
      _settingData = _apiService.fetchPengaturan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      drawer: const SideBar(),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 30),
            const SizedBox(width: 10),
            FutureBuilder<Map<String, dynamic>>(
              future: _settingData,
              builder: (context, snapshot) {
                String namaUsaha = 'DFW Playstation';

                if (snapshot.hasData && snapshot.data!['success'] == true) {
                  if (snapshot.data!['data'] != null &&
                      snapshot.data!['data']['nama_usaha'] != null) {
                    namaUsaha = snapshot.data!['data']['nama_usaha'].toString();
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
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppColors.primaryGreen,
        child: FutureBuilder<Map<String, dynamic>>(
          future: _dashboardData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGreen),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        'Gagal terhubung ke server backend.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        '${snapshot.error}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                      ),
                      onPressed: _refreshData,
                      child: const Text(
                        'Coba Lagi',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasData) {
              debugPrint('Dashboard Data: ${snapshot.data}');
              final responseData = snapshot.data!['data'] ?? {};
              final stats = responseData['statistics'] ?? {};

              String totalUnit = (stats['total_unit'] ?? '0').toString();
              String sedangAktif = (stats['sedang_aktif'] ?? '0').toString();
              String tersedia = (stats['tersedia'] ?? '0').toString();
              String dalamPerawatan = (stats['dalam_perawatan'] ?? '0')
                  .toString();

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.5,
                      children: [
                        _buildStatCard('Total Unit', totalUnit, Colors.black),
                        _buildStatCard(
                          'Sedang Aktif',
                          sedangAktif,
                          AppColors.primaryGreen,
                        ),
                        _buildStatCard('Tersedia', tersedia, Colors.blue),
                        _buildStatCard(
                          'Dalam Perawatan',
                          dalamPerawatan,
                          Colors.orange,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                    const Text(
                      'Kelola Peralatan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    _buildMenuCard(
                      title: 'Daftar Konsol',
                      subtitle: 'Kelola data aset konsol game',
                      icon: Icons.videogame_asset,
                      onTap: () {
                        Navigator.pushNamed(context, '/daftar-konsol');
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildMenuCard(
                      title: 'Daftar TV',
                      subtitle: 'Kelola data monitor dan TV terpasang',
                      icon: Icons.tv,
                      onTap: () {
                        Navigator.pushNamed(context, '/daftar-tv');
                      },
                    ),

                    const SizedBox(height: 30),
                    const Text(
                      'Transaksi Terbaru',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    FutureBuilder<List<dynamic>>(
                      future: _transactionData,
                      builder: (context, txSnapshot) {
                        if (txSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryGreen,
                            ),
                          );
                        }

                        final List transactions = txSnapshot.data ?? [];

                        if (transactions.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                'Belum ada riwayat transaksi sewa hari ini.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final tx = transactions[index];
                            return _buildTransactionItem(
                              tx['nama_pelanggan'] ?? 'Anonim',
                              tx['nama_unit'] ?? '-',
                              '${tx['durasi_jam'] ?? 0} Jam',
                              tx['status'] ?? 'Aktif',
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('Data kosong'));
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          Text(
            count,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderGrey),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 28, color: AppColors.primaryGreen),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.darkGrey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
    String name,
    String konsol,
    String durasi,
    String status,
  ) {
    final bool isAktif = status.toLowerCase() == 'aktif';
    final Color statusColor = isAktif ? AppColors.primaryGreen : Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: statusColor),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Unit : $konsol\nDurasi : $durasi',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: statusColor),
              borderRadius: BorderRadius.circular(20),
              color: isAktif ? Colors.white : Colors.grey.shade100,
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
