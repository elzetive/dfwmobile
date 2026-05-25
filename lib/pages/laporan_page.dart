import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'detail_laporan_page.dart';
import 'dashboard_page.dart';
import 'transaksi_page.dart';
import 'pelanggan_page.dart';

class LaporanPage extends StatelessWidget {
  const LaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      drawer: _buildSideBar(context),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.jpg',
              height: 30,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.sports_esports, color: AppColors.primaryGreen),
            ),
            const SizedBox(width: 10),
            const Text(
              'DFW Playstation',
              style: TextStyle(
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Laporan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: const Text(
                      'Laporan Harian',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildLaporanItem('Jumat, 12 Desember 2025', context),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  _buildLaporanItem('Kamis, 11 Desember 2025', context),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  _buildLaporanItem('Rabu, 10 Desember 2025', context, isLast: true),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: 3,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: ''),
        ],
      ),
    );
  }

  Widget _buildLaporanItem(String tanggal, BuildContext context, {bool isLast = false}) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DetailLaporanPage()),
        );
      },
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(isLast ? 10 : 0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tanggal,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSideBar(BuildContext context) {
  return Drawer(
    child: Column(
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(color: Colors.white),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.jpg',
                  height: 60,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.sports_esports, size: 60, color: Colors.green),
                ),
                const SizedBox(height: 10),
                const Text('DFW Menu', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        _buildDrawerItem(Icons.dashboard_outlined, 'Dashboard', () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardPage()));
        }),
        _buildDrawerItem(Icons.list_alt_outlined, 'Transaksi', () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TransaksiPage()));
        }),
        _buildDrawerItem(Icons.settings_input_component_outlined, 'Operasional', () {}), // Kosongin dulu kalo blm ada
        _buildDrawerItem(Icons.people_outline, 'Pelanggan', () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PelangganPage()));
        }),
        _buildDrawerItem(Icons.bar_chart_outlined, 'Laporan', () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LaporanPage()));
        }),
        const Spacer(),
        _buildDrawerItem(Icons.logout, 'Keluar', () {
          Navigator.pushReplacementNamed(context, '/'); // Atau '/login' tergantung format ketua lu
        }),
        const SizedBox(height: 20),
      ],
    ),
  );
}

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        onTap: onTap,
      ),
    );
  }
}