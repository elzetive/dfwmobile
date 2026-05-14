import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Image.asset(
                'assets/images/logo.jpg',
                height: 150,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.videogame_asset,
                  size: 100,
                  color: AppColors.primaryGreen,
                ),
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

              _buildLabel('Username'),
              _buildInputField(
                'Masukkan Username',
                Icons.person_outline,
                controller: _usernameController,
              ),

              const SizedBox(height: 20),
              _buildLabel('Password'),
              _buildInputField(
                'Masukkan Password',
                Icons.lock_outline,
                isPass: true,
                controller: _passwordController,
              ),

              const SizedBox(height: 50),

              CustomButton(
                text: 'Login',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                },
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
              const SizedBox(height: 30),
            ],
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
    IconData icon, {
    bool isPass = false,
    TextEditingController? controller,
  }) => TextField(
    controller: controller,
    obscureText: isPass,
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.black54),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
      ),
    ),
  );
}
