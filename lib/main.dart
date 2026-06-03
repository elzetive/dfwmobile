import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // WAJIB: Untuk mengaktifkan format tanggal Indonesia

import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';

import 'pages/dashboard/main_page.dart' as dashboard;

import 'pages/laporan/main_page.dart' as laporan;
import 'pages/laporan/detail_page.dart' as laporan_detail;

import 'pages/operasional/main_page.dart' as operasional;
import 'pages/operasional/konsol/main_page.dart' as konsol;
import 'pages/operasional/konsol/tambah_page.dart' as konsol_tambah;
import 'pages/operasional/tv/main_page.dart' as tv;
import 'pages/operasional/tv/tambah_page.dart' as tv_tambah;
import 'pages/operasional/unit/tambah_page.dart' as unit_tambah;

import 'pages/pelanggan/main_page.dart' as pelanggan;
import 'pages/pelanggan/tambah_page.dart' as pelanggan_tambah;

import 'pages/pengaturan/main_page.dart' as pengaturan;

import 'pages/transaksi/main_page.dart' as transaksi;
import 'pages/transaksi/tambah_page.dart' as transaksi_tambah;
import 'pages/transaksi/pengembalian/main_page.dart' as pengembalian;

import 'core/app_colors.dart';

void main() async {
  // Memastikan binding Flutter siap sebelum melakukan inisialisasi asinkronous
  WidgetsFlutterBinding.ensureInitialized();

  // Menginisialisasi format bahasa Indonesia agar DateFormat('...', 'id_ID') tidak error di Flutter Web
  await initializeDateFormatting('id_ID', null);

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
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),

        '/dashboard': (context) => const dashboard.DashboardPage(),

        '/transaksi': (context) => const transaksi.TransaksiPage(),
        '/tambah-transaksi': (context) =>
            const transaksi_tambah.TambahTransaksiPage(),
        '/pengembalian': (context) => const pengembalian.PengembalianPage(),

        '/operasional': (context) => const operasional.OperasionalPage(),
        '/daftar-konsol': (context) => const konsol.DaftarKonsolPage(),
        '/tambah-konsol': (context) => const konsol_tambah.TambahKonsolPage(),
        '/daftar-tv': (context) => const tv.DaftarTVPage(),
        '/tambah-tv': (context) => const tv_tambah.TambahTVPage(),
        '/tambah-unit': (context) => const unit_tambah.TambahUnitPage(),

        '/pelanggan': (context) => const pelanggan.PelangganPage(),
        '/tambah-pelanggan': (context) =>
            const pelanggan_tambah.TambahPelangganPage(),

        '/laporan': (context) => const laporan.LaporanPage(),
        '/detail-laporan': (context) =>
            const laporan_detail.DetailLaporanPage(),

        '/pengaturan': (context) => const pengaturan.PengaturanPage(),
      },
    );
  }
}
