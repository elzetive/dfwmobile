import 'package:flutter/material.dart';
import 'package:dfw_playstation/core/app_colors.dart';
import 'package:dfw_playstation/widgets/side_bar.dart';
import 'package:dfw_playstation/services/api_service.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _transaksiData;

  @override
  void initState() {
    super.initState();
    _transaksiData = _apiService.fetchSemuaTransaksi();
  }

  Future<void> _refreshData() async {
    setState(() {
      _transaksiData = _apiService.fetchSemuaTransaksi();
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
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppColors.primaryGreen,
        child: FutureBuilder<List<dynamic>>(
          future: _transaksiData,
          builder: (context, snapshot) {
            final list = snapshot.data ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Transaksi',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.6,
                    children: [
                      _buildStatCard(
                        'Transaksi Hari Ini',
                        '${list.length}',
                        AppColors.primaryGreen,
                      ),
                      _buildStatCard(
                        'Sesi Aktif',
                        '${list.where((tx) => tx['status'] == 'Aktif').length}',
                        AppColors.primaryGreen,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          'Tambah Transaksi',
                          AppColors.primaryGreen,
                          () => Navigator.pushNamed(
                            context,
                            '/tambah-transaksi',
                          ).then((_) => _refreshData()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildActionButton(
                          'Pengembalian',
                          const Color(0xFF007A54),
                          () => Navigator.pushNamed(
                            context,
                            '/pengembalian',
                          ).then((_) => _refreshData()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Transaksi Hari Ini',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  snapshot.connectionState == ConnectionState.waiting
                      ? const Center(child: CircularProgressIndicator())
                      : list.isEmpty
                      ? const Center(child: Text("Tidak ada transaksi."))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (context, index) =>
                              _buildTransactionItem(list[index]),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> tx) {
    bool isSelesai = tx['status'] == 'Selesai';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelesai ? Colors.grey.shade400 : AppColors.primaryGreen,
        ),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tx['nama_pelanggan'] ?? '-',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelesai ? Colors.grey : AppColors.primaryGreen,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: isSelesai ? Colors.grey.shade100 : Colors.white,
                ),
                child: Text(
                  tx['status'] ?? 'Aktif',
                  style: TextStyle(
                    color: isSelesai ? Colors.grey : AppColors.primaryGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Konsol : ${tx['nama_unit'] ?? '-'}\nDurasi : ${tx['durasi_jam']} Jam\nTipe : ${tx['tipe_penyewaan'] ?? '-'}',
                style: const TextStyle(fontSize: 12, height: 1.5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
