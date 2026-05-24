import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class TambahTransaksiPage extends StatefulWidget {
  const TambahTransaksiPage({super.key});

  @override
  State<TambahTransaksiPage> createState() => _TambahTransaksiPageState();
}

class _TambahTransaksiPageState extends State<TambahTransaksiPage> {
  String? selectedUnit;
  String? selectedCustomer;
  String selectedType = 'Main di Tempat';
  String selectedDuration = '1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      drawer: _buildSideBar(context),
      appBar: AppBar(
        title: const Text(
          'Mulai Transaksi Baru',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Pilih Unit Play'),
            _buildDropdown(
              selectedUnit,
              'Pilih Unit Play',
              ['PS4-01', 'PS4-02', 'PS5-01'],
              (val) => setState(() => selectedUnit = val),
            ),

            const SizedBox(height: 20),
            _buildLabel('Pilih Pelanggan'),
            _buildDropdown(
              selectedCustomer,
              'Pilih Pelanggan',
              ['Dimas Riyan', 'Ilham Bagus', 'Figo'],
              (val) => setState(() => selectedCustomer = val),
            ),

            const SizedBox(height: 20),
            _buildLabel('Tipe Penyewaan'),
            _buildDropdown(selectedType, null, [
              'Main di Tempat',
              'Dibawa Pulang',
            ], (val) => setState(() => selectedType = val!)),

            const SizedBox(height: 20),
            _buildLabel('Durasi Jam'),
            _buildDropdown(selectedDuration, null, [
              '1',
              '2',
              '3',
              '4',
              '5',
            ], (val) => setState(() => selectedDuration = val!)),

            const SizedBox(height: 30),
            const Text(
              'Total Estimasi Harga',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            const Text(
              'Rp. 12.000',
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),

            const SizedBox(height: 80),
            Row(
              children: [
                Expanded(
                  child: _buildFooterButton(
                    'Batal',
                    Colors.grey.shade300,
                    Colors.black,
                    () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildFooterButton(
                    'Mulai',
                    AppColors.primaryGreen,
                    Colors.white,
                    () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
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
          _buildDrawerItem(
            Icons.dashboard_outlined,
            'Dashboard',
            () => Navigator.pushReplacementNamed(context, '/dashboard'),
          ),
          _buildDrawerItem(
            Icons.list_alt_outlined,
            'Transaksi',
            () => Navigator.pushReplacementNamed(context, '/transaksi'),
          ),
          _buildDrawerItem(
            Icons.settings_input_component_outlined,
            'Operasional',
            () {},
          ),
          _buildDrawerItem(Icons.people_outline, 'Pelanggan', () {}),
          _buildDrawerItem(Icons.bar_chart_outlined, 'Laporan', () {}),
          const Spacer(),
          _buildDrawerItem(
            Icons.logout,
            'Keluar',
            () => Navigator.pushReplacementNamed(context, '/'),
          ),
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

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  Widget _buildDropdown(
    String? value,
    String? hint,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: hint != null ? Text(hint) : null,
          items: items
              .map((val) => DropdownMenuItem(value: val, child: Text(val)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildFooterButton(
    String text,
    Color bg,
    Color textColor,
    VoidCallback onTap,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
