import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/operasional_page.dart';
import 'pages/daftar_konsol.dart';
import 'pages/daftar_tv.dart';
import 'pages/tambah_konsol.dart';
import 'pages/tambah_tv.dart';
import 'pages/tambah_unit.dart';

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
        primaryColor: const Color(0xFF00A36C),
      ),
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/operasional': (context) => const OperasionalPage(),
        '/daftar-konsol': (context) => const DaftarKonsolPage(),
        '/daftar-tv': (context) => const DaftarTVPage(),
        '/tambah-konsol': (context) => const TambahKonsolPage(),
        '/tambah-tv': (context) => const TambahTVPage(),
        '/tambah-unit': (context) => const TambahUnitPage(),
      },
    );
  }
}
