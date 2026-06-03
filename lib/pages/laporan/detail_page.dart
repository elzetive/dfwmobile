import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dfw_playstation/core/app_colors.dart';
import 'package:dfw_playstation/services/api_service.dart';

class DetailLaporanPage extends StatefulWidget {
  const DetailLaporanPage({super.key});

  @override
  State<DetailLaporanPage> createState() => _DetailLaporanPageState();
}

class _DetailLaporanPageState extends State<DetailLaporanPage> {
  final ApiService _apiService = ApiService();

  String formatRupiah(dynamic amount) {
    if (amount == null) return 'Rp 0';
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(int.parse(amount.toString()));
  }

  @override
  Widget build(BuildContext context) {
    final String rawTanggal =
        ModalRoute.of(context)!.settings.arguments as String;

    String tanggalJudul = rawTanggal;
    try {
      DateTime dt = DateTime.parse(rawTanggal);
      tanggalJudul = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(dt);
    } catch (e) {
      // Abaikan kalo error parse
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // FIX BLANK SCREEN: Proteksi tombol back utama bawaan AppBar
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/laporan');
            }
          },
        ),
        title: const Text(
          'Detail Laporan',
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _apiService.fetchDetailLaporan(rawTanggal),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Gagal mengambil detail laporan: ${snapshot.error}'),
            );
          }

          final response = snapshot.data ?? {};
          final summary = response['summary'] ?? {};
          final List listTransaksi = response['data'] ?? [];

          final int totalTransaksi = summary['total_transaksi'] ?? 0;
          final int totalPendapatan = summary['total_pendapatan'] ?? 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tanggalJudul,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // FIX BLANK SCREEN: Proteksi tombol kembali custom
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacementNamed(context, '/laporan');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Kembali',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        'Total Transaksi',
                        '$totalTransaksi',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryCard(
                        'Total Pendapatan',
                        formatRupiah(totalPendapatan),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                listTransaksi.isEmpty
                    ? const Center(
                        child: Text('Tidak ada rincian data transaksi.'),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listTransaksi.length,
                        itemBuilder: (context, index) {
                          final trx = listTransaksi[index];

                          String waktuMulai = '-';
                          if (trx['created_at'] != null) {
                            try {
                              DateTime dtTrx = DateTime.parse(
                                trx['created_at'].toString(),
                              );
                              waktuMulai = DateFormat('HH:mm').format(dtTrx);
                            } catch (e) {
                              waktuMulai = trx['created_at']
                                  .toString()
                                  .split(' ')
                                  .last;
                            }
                          }

                          return _buildTransactionCard(
                            pelanggan:
                                trx['nama_pelanggan'] ?? 'Pelanggan Umum',
                            konsol: trx['nama_unit'] ?? '-',
                            waktuMulai: waktuMulai,
                            durasi: '${trx['durasi_jam'] ?? 0} jam',
                            total: formatRupiah(trx['total_harga']),
                            adaBukti: trx['bukti_transaksi'] != null,
                          );
                        },
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard({
    required String pelanggan,
    required String konsol,
    required String waktuMulai,
    required String durasi,
    required String total,
    required bool adaBukti,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow('Pelanggan', pelanggan, isBold: true),
          const Divider(height: 16),
          _buildDetailRow('Konsol', konsol),
          const SizedBox(height: 8),
          _buildDetailRow('Waktu Mulai', waktuMulai),
          const SizedBox(height: 8),
          _buildDetailRow('Durasi', durasi),
          const SizedBox(height: 8),
          _buildDetailRow('Total', total, isTotal: true),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bukti Transaksi',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              adaBukti
                  ? Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Icon(Icons.receipt_long, color: Colors.grey),
                    )
                  : const Text(
                      '-',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isBold = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? AppColors.primaryGreen : Colors.black87,
            fontSize: isTotal ? 16 : 14,
            fontWeight: isBold || isTotal ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
