import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class DaftarKonsolPage extends StatefulWidget {
  const DaftarKonsolPage({super.key});

  @override
  State<DaftarKonsolPage> createState() => _DaftarKonsolPageState();
}

class _DaftarKonsolPageState extends State<DaftarKonsolPage> {
  int _selectedIndex = 2;

  // Sample data konsol
  final List<Map<String, String>> konsolList = [
    {
      'title': 'PS4 - 01',
      'tipe': 'PS4-01',
      'kondisi': 'Baik',
    },
    {
      'title': 'PS4 - 01',
      'tipe': 'PS4-01',
      'kondisi': 'Baik',
    },
    {
      'title': 'PS4 - 01',
      'tipe': 'PS4-01',
      'kondisi': 'Baik',
    },
  ];

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = index);
    // Handle navigation based on index
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/operasional');
        break;
      case 2:
        // Already on daftar
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.darkGrey),
          onPressed: () {},
        ),
        title: Image.asset(
          'assets/images/logo.jpg',
          height: 35,
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              'DFW Playstation',
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                  Navigator.pushNamed(context, '/tambah-konsol');
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
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: konsolList.length,
                itemBuilder: (context, index) {
                  final konsol = konsolList[index];
                  return _buildKonsolCard(konsol);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Daftar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildKonsolCard(Map<String, String> konsol) {
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
                  konsol['title']!,
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
                  child: const Text(
                    'Aktif',
                    style: TextStyle(
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
              'Tipe: ${konsol['tipe']}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Kondisi: ${konsol['kondisi']}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    debugPrint("Edit konsol");
                  },
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
                  onPressed: () {
                    debugPrint("Hapus konsol");
                  },
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
