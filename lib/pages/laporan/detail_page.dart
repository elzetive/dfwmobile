import 'package:flutter/material.dart';
import 'package:dfw_playstation/core/app_colors.dart';

class DetailLaporanPage extends StatelessWidget {
  const DetailLaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
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
      body: SingleChildScrollView(
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
                  child: const Text(
                    'Jumat, 12 Desember 2025',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
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
                Expanded(child: _buildSummaryCard('Total Transaksi', '6')),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard('Total Pendapatan', 'Rp 492.000'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildTransactionCard(
              pelanggan: 'Dimas Riyan Wirayuda',
              konsol: 'Unit 1 - PS 5',
              waktuMulai: '22:37',
              durasi: '2 jam',
              total: 'Rp 24.000',
              adaBukti: false,
            ),
            _buildTransactionCard(
              pelanggan: 'Dimas Riyan Wirayuda',
              konsol: 'Unit 1 - PS 5',
              waktuMulai: '00:01',
              durasi: '18 jam',
              total: 'Rp 216.000',
              adaBukti: true,
            ),
            _buildTransactionCard(
              pelanggan: 'Dimas Riyan Wirayuda',
              konsol: 'Unit 3 - PS 5',
              waktuMulai: '00:40',
              durasi: '1 jam',
              total: 'Rp 12.000',
              adaBukti: true,
            ),
          ],
        ),
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
            color: AppColors.primaryGreen.withValues(alpha: 0.3),
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
            color: Colors.black.withValues(alpha: 0.02),
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
