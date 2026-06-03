import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';

  // ==================== DASHBOARD & PELANGGAN ====================
  Future<Map<String, dynamic>> fetchDashboardData() async {
    return _getMap('$baseUrl/dashboard-data');
  }

  Future<List<dynamic>> fetchPelangganData() async {
    return _getList('$baseUrl/pelanggan');
  }

  Future<bool> tambahPelanggan(
    String nama,
    String telepon,
    String alamat,
  ) async {
    return _post('$baseUrl/pelanggan', {
      'nama_pelanggan': nama,
      'telepon': telepon,
      'alamat': alamat,
    }, 201);
  }

  Future<bool> hapusPelanggan(String id) async {
    try {
      final res = await http.delete(
        Uri.parse('$baseUrl/pelanggan/$id'),
        headers: {'Accept': 'application/json'},
      );
      if (res.statusCode != 200) {
        debugPrint("Gagal Hapus Pelanggan $id. Status: ${res.statusCode}");
      }
      return res.statusCode == 200;
    } catch (e) {
      debugPrint("Error hapusPelanggan: $e");
      return false;
    }
  }

  Future<bool> editPelanggan(
    String id,
    String nama,
    String telepon,
    String alamat,
    String status,
  ) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/pelanggan/$id'),
        headers: {'Accept': 'application/json'},
        body: {
          'nama_pelanggan': nama,
          'telepon': telepon,
          'alamat': alamat,
          'status': status,
        },
      );
      if (res.statusCode != 200) {
        debugPrint("Gagal Edit Pelanggan $id. Status: ${res.statusCode}");
      }
      return res.statusCode == 200;
    } catch (e) {
      debugPrint("Error editPelanggan: $e");
      return false;
    }
  }

  // ==================== INVENTARIS & OPERASIONAL ====================
  Future<List<dynamic>> fetchKonsolData() async {
    return _getList('$baseUrl/konsol');
  }

  Future<List<dynamic>> fetchTvData() async {
    return _getList('$baseUrl/tv');
  }

  Future<List<dynamic>> fetchUnitData() async {
    return _getList('$baseUrl/unit');
  }

  Future<bool> tambahKonsol(
    String id,
    String nama,
    String tipe,
    String kondisi,
    String status,
  ) async {
    return _post('$baseUrl/konsol', {
      'id': id,
      'nama_unit': nama,
      'tipe': tipe,
      'kondisi': kondisi,
      'status': status,
    }, 201);
  }

  Future<bool> editKonsol(
    String id,
    String nama,
    String tipe,
    String kondisi,
    String status,
  ) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/konsol/$id'),
        headers: {'Accept': 'application/json'},
        body: {
          'nama_unit': nama,
          'tipe': tipe,
          'kondisi': kondisi,
          'status': status,
        },
      );
      return res.statusCode == 200;
    } catch (e) {
      debugPrint("Error editKonsol: $e");
      return false;
    }
  }

  Future<bool> hapusKonsol(String id) async {
    try {
      final res = await http.delete(
        Uri.parse('$baseUrl/konsol/$id'),
        headers: {'Accept': 'application/json'},
      );
      return res.statusCode == 200;
    } catch (e) {
      debugPrint("Error hapusKonsol: $e");
      return false;
    }
  }

  Future<bool> tambahTv(
    String idTv,
    String nama,
    String model,
    String kondisi,
    String status,
  ) async {
    return _post('$baseUrl/tv', {
      'id_tv_manual': idTv,
      'nama_tv': nama,
      'model': model,
      'kondisi': kondisi,
      'status': status,
    }, 201);
  }

  Future<bool> editTv(
    String id,
    String nama,
    String model,
    String kondisi,
    String status,
  ) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/tv/$id'),
        headers: {'Accept': 'application/json'},
        body: {
          'nama_tv': nama,
          'model': model,
          'kondisi': kondisi,
          'status': status,
        },
      );
      return res.statusCode == 200;
    } catch (e) {
      debugPrint("Error editTv: $e");
      return false;
    }
  }

  Future<bool> hapusTv(String id) async {
    try {
      final res = await http.delete(
        Uri.parse('$baseUrl/tv/$id'),
        headers: {'Accept': 'application/json'},
      );
      return res.statusCode == 200;
    } catch (e) {
      debugPrint("Error hapusTv: $e");
      return false;
    }
  }

  Future<bool> tambahUnit(
    String nama,
    String status,
    String kondisi,
    String konsolId,
    String tvId,
  ) async {
    return _post('$baseUrl/unit', {
      'nama_unit': nama,
      'status': status,
      'kondisi': kondisi,
      'konsol_id': konsolId,
      'tv_id': tvId,
    }, 201);
  }

  Future<bool> editUnit(
    String id,
    String nama,
    String konsolId,
    String tvId,
    String status,
  ) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/unit/$id'),
        headers: {'Accept': 'application/json'},
        body: {
          'nama_unit': nama,
          'konsol_id': konsolId,
          'tv_id': tvId,
          'status': status,
        },
      );
      return res.statusCode == 200;
    } catch (e) {
      debugPrint("Error editUnit: $e");
      return false;
    }
  }

  Future<bool> hapusUnit(String id) async {
    try {
      final res = await http.delete(
        Uri.parse('$baseUrl/unit/$id'),
        headers: {'Accept': 'application/json'},
      );
      return res.statusCode == 200;
    } catch (e) {
      debugPrint("Error hapusUnit: $e");
      return false;
    }
  }

  // ==================== TRANSAKSI & PENGEMBALIAN ====================
  Future<List<dynamic>> fetchSemuaTransaksi() async {
    return _getList('$baseUrl/transaksi');
  }

  Future<List<dynamic>> fetchTransaksiAktif() async {
    return _getList('$baseUrl/transaksi/aktif');
  }

  Future<bool> tambahTransaksi(
    String pelangganId,
    String unitId,
    String tipe,
    String durasi,
    String total,
  ) async {
    return _post('$baseUrl/transaksi', {
      'pelanggan_id': pelangganId,
      'unit_id': unitId,
      'tipe_penyewaan': tipe,
      'durasi_jam': durasi,
      'total_harga': total,
      'status': 'Aktif',
    }, 201);
  }

  Future<bool> selesaikanTransaksi(String transaksiId, String unitId) async {
    return _post('$baseUrl/transaksi/selesai', {
      'transaksi_id': transaksiId,
      'unit_id': unitId,
    }, 200);
  }

  // ==================== LAPORAN ====================
  Future<Map<String, dynamic>> fetchLaporanData() async {
    return _getMap('$baseUrl/laporan');
  }

  Future<Map<String, dynamic>> fetchDetailLaporan(String tanggal) async {
    return _getMap('$baseUrl/laporan/$tanggal');
  }

  // ==================== PENGATURAN TARIF DINAMIS ====================
  Future<Map<String, dynamic>> fetchPengaturan() async {
    return _getMap('$baseUrl/pengaturan');
  }

  // PERBAIKAN SINKRONISASI MAPPING: Melempar data PS3 murni ke kolom harga_xbox agar tidak memicu SQL Error 500 di Laravel
  Future<bool> editPengaturan(
    String nama,
    String jam,
    String ps3,
    String ps4,
    String ps5,
    String xbox,
  ) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/pengaturan'),
        headers: {'Accept': 'application/json'},
        body: {
          'nama_usaha': nama,
          'jam_operasional': jam,
          'harga_ps3': ps3,
          'harga_ps4': ps4,
          'harga_ps5': ps5,
          'harga_xbox':
              ps3, // Mengamankan data PS3 ke kolom fisik harga_xbox database
          'harga_nintendo': '0',
        },
      );
      return res.statusCode == 200;
    } catch (e) {
      debugPrint("Error editPengaturan: $e");
      return false;
    }
  }

  // UTILITY HELPER PERBAIKAN FINAL: Memastikan hitungan transaksi membaca field yang pas (PS3 -> harga_xbox)
  Future<int> getTarifByTipe(String tipeKonsol) async {
    final settings = await fetchPengaturan();
    if (settings['success'] == true && settings['data'] != null) {
      final data = settings['data'];
      switch (tipeKonsol.toUpperCase()) {
        case 'PS3':
          return int.tryParse(data['harga_xbox'].toString()) ?? 8000;
        case 'PS4':
          return int.tryParse(data['harga_ps4'].toString()) ?? 12000;
        case 'PS5':
          return int.tryParse(data['harga_ps5'].toString()) ?? 18000;
        default:
          return int.tryParse(data['harga_ps4'].toString()) ?? 12000;
      }
    }
    return 12000;
  }

  // ==================== AUTHENTICATION ====================
  Future<Map<String, dynamic>> register(
    String nama,
    String email,
    String username,
    String password,
  ) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Accept': 'application/json'},
        body: {
          'name': nama,
          'email': email,
          'username': username,
          'password': password,
        },
      );
      return json.decode(res.body);
    } catch (e) {
      debugPrint("Error register: $e");
      return {
        'success': false,
        'message': 'Gagal terhubung ke server backend: $e',
      };
    }
  }

  Future<Map<String, dynamic>> login(String loginInput, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Accept': 'application/json'},
        body: {'login_input': loginInput, 'password': password},
      );
      return json.decode(res.body);
    } catch (e) {
      debugPrint("Error login: $e");
      return {
        'success': false,
        'message': 'Gagal terhubung ke server backend: $e',
      };
    }
  }

  // ==================== GLOBAL REST HELPER METHODS ====================
  Future<Map<String, dynamic>> _getMap(String url) async {
    try {
      final res = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      );
      if (res.statusCode == 200) {
        return json.decode(res.body);
      }
      return {};
    } catch (e) {
      debugPrint("Error _getMap: $e");
      return {};
    }
  }

  Future<List<dynamic>> _getList(String url) async {
    try {
      final res = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        return data['data'] is List ? data['data'] : [];
      }
      return [];
    } catch (e) {
      debugPrint("Error _getList: $e");
      return [];
    }
  }

  Future<bool> _post(
    String url,
    Map<String, String> body,
    int successCode,
  ) async {
    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
        body: body,
      );
      if (res.statusCode != successCode) {
        debugPrint(
          "Gagal POST ke $url. Status: ${res.statusCode}. Res: ${res.body}",
        );
      }
      return res.statusCode == successCode;
    } catch (e) {
      debugPrint("Error _post: $e");
      return false;
    }
  }
}
