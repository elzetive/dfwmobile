// lib/main.dart
import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/transaksi_page.dart';
import 'pages/tambah_transaksi_page.dart';
import 'pages/pengembalian_page.dart';
import 'pages/operasional_page.dart';
import 'pages/daftar_konsol.dart';
import 'pages/daftar_tv.dart';
import 'pages/tambah_konsol.dart';
import 'pages/tambah_tv.dart';
import 'pages/tambah_unit.dart';
import 'pages/pelanggan_page.dart';
import 'pages/tambah_pelanggan_page.dart';
import 'pages/laporan_page.dart';
import 'pages/detail_laporan_page.dart';
import 'pages/pengaturan_page.dart';
import 'core/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DFW Playstation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primaryGreen,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
          primary: AppColors.primaryGreen,
        ),
      ),
      // Gunakan initialRoute, jangan campur dengan parameter home:
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/transaksi': (context) => const TransaksiPage(),
        '/tambah-transaksi': (context) => const TambahTransaksiPage(),
        '/pengembalian': (context) => const PengembalianPage(),
        '/operasional': (context) => const OperasionalPage(),
        '/daftar-konsol': (context) => const DaftarKonsolPage(),
        '/daftar-tv': (context) => const DaftarTVPage(),
        '/tambah-konsol': (context) => const TambahKonsolPage(),
        '/tambah-tv': (context) => const TambahTVPage(),
        '/tambah-unit': (context) => const TambahUnitPage(),
        '/pelanggan': (context) => const PelangganPage(),
        '/tambah-pelanggan': (context) => const TambahPelangganPage(),
        '/laporan': (context) => const LaporanPage(),
        '/detail-laporan': (context) => const DetailLaporanPage(),
        '/pengaturan': (context) => const PengaturanPage(),
      },
    );
  }
}
