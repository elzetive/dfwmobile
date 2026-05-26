import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';

  Future<Map<String, dynamic>> fetchDashboardData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/dashboard-data'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Server Laravel merespon dengan kode: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception(
        'Gagal terhubung ke Laravel. Pastikan "php artisan serve" menyala. Error: $e',
      );
    }
  }

  Future<bool> tambahPelanggan(
    String nama,
    String telepon,
    String alamat,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pelanggan'),
        body: {'nama_pelanggan': nama, 'telepon': telepon, 'alamat': alamat},
      );

      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
