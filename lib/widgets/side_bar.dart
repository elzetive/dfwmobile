import 'package:flutter/material.dart';
import 'package:dfw_playstation/core/app_colors.dart';
import 'package:dfw_playstation/services/api_service.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final ApiService apiService = ApiService();

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 60,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.sports_esports,
                        size: 50,
                        color: AppColors.primaryGreen,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<Map<String, dynamic>>(
                    future: apiService.fetchPengaturan(),
                    builder: (context, snapshot) {
                      String namaUsaha = '';

                      if (snapshot.hasData && snapshot.data!['success'] == true) {
                        
                        String fullNama = snapshot.data!['data']['nama_usaha'].toString();
                        String kataPertama = fullNama.split(' ')[0]; 
                        namaUsaha = '$kataPertama Menu'; 
                      }

                      return Text(
                        namaUsaha,
                        style: const TextStyle(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      );
                    },
                  ),
                  // ===============================================
                ],
              ),
            ),
          ),
          _buildDrawerItem(
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            isActive: currentRoute == '/dashboard',
            onTap: () => Navigator.pushReplacementNamed(context, '/dashboard'),
          ),
          _buildDrawerItem(
            icon: Icons.list_alt_outlined,
            title: 'Transaksi',
            isActive: currentRoute == '/transaksi' ||
                currentRoute == '/tambah-transaksi' ||
                currentRoute == '/pengembalian',
            onTap: () => Navigator.pushReplacementNamed(context, '/transaksi'),
          ),
          _buildDrawerItem(
            icon: Icons.settings_input_component_outlined,
            title: 'Operasional',
            isActive: currentRoute == '/operasional' ||
                currentRoute == '/daftar-konsol' ||
                currentRoute == '/daftar-tv',
            onTap: () => Navigator.pushReplacementNamed(context, '/operasional'),
          ),
          _buildDrawerItem(
            icon: Icons.people_outline,
            title: 'Pelanggan',
            isActive: currentRoute == '/pelanggan' ||
                currentRoute == '/tambah-pelanggan',
            onTap: () => Navigator.pushReplacementNamed(context, '/pelanggan'),
          ),
          _buildDrawerItem(
            icon: Icons.bar_chart_outlined,
            title: 'Laporan',
            isActive: currentRoute == '/laporan' || currentRoute == '/detail-laporan',
            onTap: () => Navigator.pushReplacementNamed(context, '/laporan'),
          ),
          _buildDrawerItem(
            icon: Icons.settings_outlined,
            title: 'Pengaturan',
            isActive: currentRoute == '/pengaturan',
            onTap: () => Navigator.pushReplacementNamed(context, '/pengaturan'),
          ),
          const Spacer(),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          _buildDrawerItem(
            icon: Icons.logout,
            title: 'Keluar',
            isActive: false,
            onTap: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? AppColors.primaryGreen : Colors.black87,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? AppColors.primaryGreen : Colors.black87,
          ),
        ),
        selected: isActive,
        selectedTileColor: AppColors.primaryGreen.withValues(alpha: 0.05),
        onTap: onTap,
      ),
    );
  }
}