import 'package:flutter/material.dart';
import 'package:dfw_playstation/core/app_colors.dart';
import 'package:dfw_playstation/widgets/custom_button.dart';
import 'package:dfw_playstation/services/api_service.dart'; // IMPORT API SERVICE

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiService _apiService = ApiService(); // Instansiasi ApiService
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  bool _isSubmitting = false; // State loading button
  bool _obscurePassword = true; // State sembunyikan password

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final loginInput = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (loginInput.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi username/email dan password')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Kirim request ke API Laravel
    final response = await _apiService.login(loginInput, password);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Berhasil! Selamat Datang.'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
      // Pindah ke Dashboard
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      String errorMsg =
          response['message'] ?? 'Username/Email atau password salah';
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
                const SizedBox(height: 30),
                Image.asset(
                  'assets/images/logo.png',
                  height: 150,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.videogame_asset,
                      size: 100,
                      color: AppColors.primaryGreen,
                    );
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  'DFW Playstation',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Selamat datang',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Login ke dalam akun',
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                const SizedBox(height: 40),

                _buildLabel('Username atau Email'),
                _buildInputField(
                  'Masukkan Username atau Email',
                  Icons.person_outline,
                  usernameController,
                ),

                const SizedBox(height: 20),
                _buildLabel('Password'),
                _buildInputField(
                  'Masukkan Password',
                  Icons.lock_outline,
                  passwordController,
                  isPasswordField: true,
                  obscureText: _obscurePassword,
                  onToggleVisibility: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),

                const SizedBox(height: 50),
                _isSubmitting
                    ? const CircularProgressIndicator(
                        color: AppColors.primaryGreen,
                      )
                    : CustomButton(text: 'Login', onPressed: _handleLogin),
                const SizedBox(height: 25),

                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text("Belum punya akun? "),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/register'),
                        child: const Text(
                          "Daftar Sekarang",
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
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  Widget _buildInputField(
    String hint,
    IconData icon,
    TextEditingController controller, {
    bool isPasswordField = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) => TextField(
    controller: controller,
    obscureText: isPasswordField ? obscureText : false,
    style: const TextStyle(fontSize: 14),
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.black54),
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
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
