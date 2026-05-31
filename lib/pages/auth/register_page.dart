import 'package:flutter/material.dart';
import 'package:dfw_playstation/core/app_colors.dart';
import 'package:dfw_playstation/widgets/custom_button.dart';
import 'package:dfw_playstation/services/api_service.dart'; // IMPORT API SERVICE

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final ApiService _apiService = ApiService(); // Instansiasi ApiService
  bool _isSubmitting = false; // Menangani state loading button

  // State untuk mengontrol visibilitas password
  bool _obscureKataSandi = true;
  bool _obscureUlangiKataSandi = true;

  // Controller untuk menangkap teks inputan
  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _namaPenggunaController = TextEditingController();
  final TextEditingController _kataSandiController = TextEditingController();
  final TextEditingController _ulangiKataSandiController =
      TextEditingController();

  @override
  void dispose() {
    // Membersihkan controller saat halaman ditutup agar memori tidak bocor
    _namaLengkapController.dispose();
    _emailController.dispose();
    _namaPenggunaController.dispose();
    _kataSandiController.dispose();
    _ulangiKataSandiController.dispose();
    super.dispose();
  }

  void _prosesDaftar() async {
    final nama = _namaLengkapController.text.trim();
    final email = _emailController.text.trim();
    final username = _namaPenggunaController.text.trim();
    final password = _kataSandiController.text;
    final confirmPassword = _ulangiKataSandiController.text;

    // 1. Validasi Input Kosong lokal
    if (nama.isEmpty || email.isEmpty || username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi seluruh formulir!')),
      );
      return;
    }

    // 2. Validasi Kesamaan Kata Sandi
    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Kata sandi tidak cocok!')));
      return;
    }

    // Aktifkan animasi loading spinner
    setState(() => _isSubmitting = true);

    // 3. Kirim data via HTTP POST ke Laravel
    final response = await _apiService.register(
      nama,
      email,
      username,
      password,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    // 4. Cek response dari server backend
    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran Berhasil! Silakan masuk.'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );

      // Menghindari layar blank putih di web dengan memaksa pindah ke rute login
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      // Tampilkan pesan kegagalan dari response Laravel (contoh: email/username duplikat)
      String errorMsg = response['message'] ?? 'Gagal mendaftarkan akun!';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/logo.png',
                  height: 120,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.videogame_asset,
                    size: 80,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 10),
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
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryGreen,
                      ),
                    );
                  },
                ),
                const Text(
                  'Form Pendaftaran',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                _buildLabel('Nama Lengkap'),
                _buildInputField(
                  'Nama Lengkap',
                  Icons.person_outline,
                  _namaLengkapController,
                ),

                const SizedBox(height: 15),
                _buildLabel('Email'),
                _buildInputField(
                  'Email',
                  Icons.email_outlined,
                  _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 15),
                _buildLabel('Nama Pengguna'),
                _buildInputField(
                  'Nama Pengguna',
                  Icons.account_circle_outlined,
                  _namaPenggunaController,
                ),

                const SizedBox(height: 15),
                _buildLabel('Kata Sandi'),
                _buildInputField(
                  'Kata Sandi',
                  Icons.lock_outline,
                  _kataSandiController,
                  isPasswordField: true,
                  obscureText: _obscureKataSandi,
                  onToggleVisibility: () {
                    setState(() => _obscureKataSandi = !_obscureKataSandi);
                  },
                ),

                const SizedBox(height: 15),
                _buildLabel('Ulangi Kata Sandi'),
                _buildInputField(
                  'Ulangi Kata Sandi',
                  Icons.lock_clock_outlined,
                  _ulangiKataSandiController,
                  isPasswordField: true,
                  obscureText: _obscureUlangiKataSandi,
                  onToggleVisibility: () {
                    setState(
                      () => _obscureUlangiKataSandi = !_obscureUlangiKataSandi,
                    );
                  },
                ),

                const SizedBox(height: 40),
                _isSubmitting
                    ? const CircularProgressIndicator(
                        color: AppColors.primaryGreen,
                      )
                    : CustomButton(text: 'Daftar', onPressed: _prosesDaftar),
                const SizedBox(height: 25),

                // Menggunakan Wrap agar susunan teks bawah adaptif dan bebas dari overflow
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text("Sudah punya akun? "),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, '/login'),
                        child: const Text(
                          "Masuk",
                          style: TextStyle(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Container(
    alignment: Alignment.centerLeft,
    margin: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    ),
  );

  Widget _buildInputField(
    String hint,
    IconData icon,
    TextEditingController controller, {
    bool isPasswordField = false, // Menentukan apakah ini input tipe password
    bool obscureText = false, // Mengontrol status sembunyi teks
    VoidCallback? onToggleVisibility, // Callback ketika ikon mata diklik
    TextInputType keyboardType = TextInputType.text,
  }) => TextField(
    controller: controller,
    obscureText: isPasswordField ? obscureText : false,
    keyboardType: keyboardType,
    style: const TextStyle(fontSize: 14),
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.black54, size: 20),
      // Tambahkan tombol mata jika ini adalah field password
      suffixIcon: isPasswordField
          ? IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.black54,
                size: 20,
              ),
              onPressed: onToggleVisibility,
            )
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
      ),
    ),
  );
}
