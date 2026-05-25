import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/custom_button.dart';
import 'tambah_pelanggan_page.dart';
import 'dashboard_page.dart';
import 'laporan_page.dart';


class PelangganPage extends StatelessWidget {
  const PelangganPage({super.key});

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
              'Daftar Pelanggan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: '+ Tambah Pelanggan Baru',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TambahPelangganPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Total Pelanggan', '2', AppColors.primaryGreen),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard('Pelanggan Aktif', '1', AppColors.accentOrange),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Data Pelanggan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildPelangganItem('1', 'Dimas Riyan Wirayuda', '081226723902', 'Jalan Kemangi No 41', '24-05-2026', 'Aktif'),
            _buildPelangganItem('10', 'Figo Firgiawan', '081226723908', 'Karangtengah, Cilongok, Banyumas', '24-05-2026', 'Nonaktif'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: ''),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 10),
          Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        ],
      ),
    );
  }

  Widget _buildPelangganItem(String id, String name, String phone, String alamat, String tgl, String status) {
    bool isActive = status == 'Aktif';
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('ID', id),
          _buildInfoRow('Nama Pelanggan', name, isBold: true),
          _buildInfoRow('Telepon', phone),
          _buildInfoRow('Alamat', alamat),
          _buildInfoRow('Tgl. Daftar', tgl),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 105, child: Text('Status', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500))),
                const Text(' :  ', style: TextStyle(color: Colors.grey, fontSize: 13)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.blue : Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryGreen),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: Size.zero,
                ),
                child: const Text('Ubah', style: TextStyle(color: AppColors.primaryGreen, fontSize: 13, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: Size.zero,
                  elevation: 0,
                ),
                child: const Text('Hapus', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 105, child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500))),
          const Text(' :  ', style: TextStyle(color: Colors.grey, fontSize: 13)),
          Expanded(child: Text(value, style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: isBold ? FontWeight.bold : FontWeight.normal))),
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
                  Image.asset(
                    'assets/images/logo.jpg',
                    height: 60,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.sports_esports, size: 60, color: AppColors.primaryGreen),
                  ),
                  const SizedBox(height: 10),
                  const Text('DFW Menu', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          _buildDrawerItem(Icons.dashboard_outlined, 'Dashboard', () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardPage()));
          }),
          _buildDrawerItem(Icons.list_alt_outlined, 'Transaksi', () {}),
          _buildDrawerItem(Icons.settings_input_component_outlined, 'Operasional', () {}),
          _buildDrawerItem(Icons.people_outline, 'Pelanggan', () {
            Navigator.pop(context);
          }),
          _buildDrawerItem(Icons.bar_chart_outlined, 'Laporan', () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LaporanPage()));
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
}