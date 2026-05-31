import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dfw_playstation/core/app_colors.dart';
import 'package:dfw_playstation/widgets/custom_button.dart';
import 'package:dfw_playstation/widgets/side_bar.dart';
import 'package:dfw_playstation/services/api_service.dart';
import 'package:dfw_playstation/pages/pelanggan/ubah_page.dart';

class PelangganPage extends StatefulWidget {
  const PelangganPage({super.key});

  @override
  State<PelangganPage> createState() => _PelangganPageState();
}

class _PelangganPageState extends State<PelangganPage> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _pelangganData;

  @override
  void initState() {
    super.initState();
    _pelangganData = _apiService.fetchPelangganData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _pelangganData = _apiService.fetchPelangganData();
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
            Image.asset(
              'assets/images/logo.png',
              height: 30,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.sports_esports,
                color: AppColors.primaryGreen,
              ),
            ),
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
          future: _pelangganData,
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
                        'Gagal mengambil data pelanggan riil.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
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

            final listPelanggan = snapshot.data ?? [];

            int totalPelanggan = listPelanggan.length;
            int pelangganAktif = listPelanggan
                .where((p) => p['status'] == 'Aktif')
                .length;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                      Navigator.pushNamed(
                        context,
                        '/tambah-pelanggan',
                      ).then((_) => _refreshData());
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total Pelanggan',
                          totalPelanggan.toString(),
                          AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatCard(
                          'Pelanggan Aktif',
                          pelangganAktif.toString(),
                          AppColors.accentOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Data Pelanggan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  listPelanggan.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Text(
                              'Belum ada data pelanggan terdaftar di database.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: listPelanggan.length,
                          itemBuilder: (context, index) {
                            final pelanggan = listPelanggan[index];

                            String id = pelanggan['id'].toString();
                            String nama = pelanggan['nama_pelanggan'] ?? '-';
                            String telepon = pelanggan['telepon'] ?? '-';
                            String alamat = pelanggan['alamat'] ?? '-';

                            String tglDaftar = '-';
                            if (pelanggan['created_at'] != null) {
                              try {
                                DateTime dt = DateTime.parse(
                                  pelanggan['created_at'],
                                );
                                tglDaftar = DateFormat(
                                  'dd MMM yyyy',
                                ).format(dt);
                              } catch (e) {
                                tglDaftar = pelanggan['created_at']
                                    .toString()
                                    .substring(0, 10);
                              }
                            }
                            String status = pelanggan['status'] ?? 'Aktif';

                            return _buildPelangganItem(
                              context,
                              id,
                              nama,
                              telepon,
                              alamat,
                              tglDaftar,
                              status,
                            );
                          },
                        ),
                ],
              ),
            );
          },
        ),
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
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            count,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPelangganItem(
    BuildContext context,
    String id,
    String name,
    String phone,
    String alamat,
    String tgl,
    String status,
  ) {
    bool isActive = status == 'Aktif';
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
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
                const SizedBox(
                  width: 105,
                  child: Text(
                    'Status',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Text(
                  ' :  ',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.blue : Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UbahPelangganPage(
                        id: id,
                        namaLama: name,
                        teleponLama: phone,
                        alamatLama: alamat,
                        statusLama: status,
                      ),
                    ),
                  ).then((_) => _refreshData()); 
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryGreen),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  minimumSize: Size.zero,
                ),
                child: const Text(
                  'Ubah',
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: const Text('Konfirmasi Hapus'),
                        content: Text(
                          'Yakin mau hapus data pelanggan "$name"?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text(
                              'Batal',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade400,
                              elevation: 0,
                            ),
                            onPressed: () async {
                              Navigator.pop(dialogContext);

                              bool sukses = await _apiService.hapusPelanggan(
                                id,
                              );

                              if (sukses && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('$name berhasil dihapus!'),
                                    backgroundColor: AppColors.primaryGreen,
                                  ),
                                );
                                _refreshData();
                              } else if (!sukses && context.mounted) {
                                // Munculin notif gagal
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Gagal menghapus data pelanggan.',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'Hapus',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                // --- LOGIKA TOMBOL HAPUS BERAKHIR DI SINI ---
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  minimumSize: Size.zero,
                  elevation: 0,
                ),
                child: const Text(
                  'Hapus',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(
            ' :  ',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
