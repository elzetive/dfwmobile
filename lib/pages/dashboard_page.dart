import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'pelanggan_page.dart';
import 'laporan_page.dart';
import 'pengaturan_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      drawer: _buildSideBar(context),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.jpg', height: 30),
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
              'Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                _buildStatCard('Total Unit', '5', Colors.black),
                _buildStatCard('Sedang Aktif', '5', AppColors.primaryGreen),
                _buildStatCard('Tersedia', '5', Colors.blue),
                _buildStatCard('Dalam Perawatan', '0', Colors.orange),
              ],
            ),

            const SizedBox(height: 30),
            const Text(
              'Transaksi Terbaru',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            _buildTransactionItem('Dimas Riyan', 'PS4-01', '2 Jam'),
            _buildTransactionItem('Dimas Riyan', 'PS4-01', '2 Jam'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PengaturanPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: '',
          ),
        ],
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
                  Image.asset('assets/images/logo.jpg', height: 60),
                  const SizedBox(height: 10),
                  const Text(
                    'DFW Menu',
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildDrawerItem(Icons.dashboard_outlined, 'Dashboard', () {
            Navigator.pop(context);
          }),
          _buildDrawerItem(Icons.list_alt_outlined, 'Transaksi', () {
            Navigator.pushNamed(context, '/transaksi');
          }),
          _buildDrawerItem(
            Icons.settings_input_component_outlined,
            'Operasional',
            () {},
          ),
          _buildDrawerItem(Icons.people_outline, 'Pelanggan', () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const PelangganPage()),
            );
          }),
          _buildDrawerItem(Icons.bar_chart_outlined, 'Laporan', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LaporanPage()),
            );
          }),
          const Spacer(),
          _buildDrawerItem(Icons.logout, 'Keluar', () {
            Navigator.pushReplacementNamed(context, '/');
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

  Widget _buildStatCard(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(10),
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

  Widget _buildTransactionItem(String name, String konsol, String durasi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryGreen),
        borderRadius: BorderRadius.circular(10),
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
                'Konsol : $konsol\nDurasi : $durasi',
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
