import 'package:flutter/material.dart';
import 'package:dfw_playstation/core/app_colors.dart';
import 'package:dfw_playstation/widgets/side_bar.dart';
import 'package:dfw_playstation/services/api_service.dart'; // 1. Import Service API Laravel

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

  @override
  void initState() {
    super.initState();
    // Panggil API saat halaman dimuat pertama kali
    _dashboardData = _apiService.fetchDashboardData();
    _transactionData = _apiService.fetchSemuaTransaksi();
    // Tambahkan observer untuk mendeteksi ketika app kembali di-focus
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Hapus observer saat halaman ditutup
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Refresh data ketika app kembali ke foreground
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshData();
    }
  }

  // Fungsi Pull to Refresh untuk memperbarui data saat layar ditarik ke bawah
  Future<void> _refreshData() async {
    setState(() {
      _dashboardData = _apiService.fetchDashboardData();
      _transactionData = _apiService.fetchSemuaTransaksi();
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
              future: _apiService.fetchPengaturan(),
              builder: (context, snapshot) {
                String namaUsaha = '';

                if (snapshot.hasData && snapshot.data!['success'] == true) {
                  namaUsaha = snapshot.data!['data']['nama_usaha'].toString();
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
      // 2. Bungkus body dengan RefreshIndicator dan FutureBuilder
      body: RefreshIndicator(
        onRefresh:
            _refreshData, // PERBAIKAN: Menggunakan onRefresh, bukan onPressed
        color: AppColors.primaryGreen,
        child: FutureBuilder<Map<String, dynamic>>(
          future: _dashboardData,
          builder: (context, snapshot) {
            // Skenario A: Server Laravel sedang merespon (Loading)
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGreen),
              );
            }

            // Skenario B: Error koneksi (misal server mati / IP salah)
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

            // Skenario C: Sukses menarik data JSON dari MySQL via Laravel
            if (snapshot.hasData) {
              debugPrint('Dashboard Data: ${snapshot.data}');
              final responseData = snapshot.data!['data'];
              final stats = responseData['statistics'];

              debugPrint('Stats: $stats');

              // Ekstrak data statistik riil backend
              String totalUnit = stats['total_unit'].toString();
              String sedangAktif = stats['sedang_aktif'].toString();
              String tersedia = stats['tersedia'].toString();
              String dalamPerawatan = stats['dalam_perawatan'].toString();

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

                    // GRID STATISTIK (Menggunakan data riil dari API)
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

                    // LIST TRANSAKSI DINAMIS dari API yang benar
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
                        debugPrint(
                            'Transactions from API: $transactions');
                        debugPrint(
                            'Transactions count: ${transactions.length}');

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
                              '${tx['durasi_jam']} Jam',
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

  // --- Widget Komponen Suku Cadang UI Asli Kelompok Kalian ---
  Widget _buildStatCard(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        // PERBAIKAN: Menggunakan .withValues() untuk menghindari warning deprecated di Flutter baru
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
                // PERBAIKAN: Menggunakan .withValues() untuk menghindari warning deprecated di Flutter baru
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

  Widget _buildTransactionItem(String name, String konsol, String durasi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryGreen),
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
              border: Border.all(color: AppColors.primaryGreen),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Aktif',
              style: TextStyle(
                color: AppColors.primaryGreen,
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
