import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? selectedRole;
  late TextEditingController usernameController;
  late TextEditingController passwordController;

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

  void _handleLogin() {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi username dan password')),
      );
      return;
    }

    if (username == 'admin' && password == '123') {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username atau password salah')),
      );
    }
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
              const SizedBox(height: 50),
              // Panggil Logo JPG yang sudah didaftarkan di assets
              Image.asset(
                'assets/images/logo.jpg',
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

              _buildLabel('Masuk Sebagai'),
              _buildDropdown(),

              const SizedBox(height: 20),
              _buildLabel('Username'),
              _buildInputField('Masukkan Username', Icons.person, usernameController),

              const SizedBox(height: 20),
              _buildLabel('Password'),
              _buildInputField('Masukkan Password', Icons.lock, passwordController, isPass: true),

              const SizedBox(height: 50),
              CustomButton(
                text: 'Login',
                onPressed: _handleLogin,
              ),
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

  Widget _buildDropdown() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(10),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        value: selectedRole,
        hint: const Text('Pilih'),
        items: [
          'Admin',
          'Kasir',
        ].map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
        onChanged: (val) => setState(() => selectedRole = val),
      ),
    ),
  );

  Widget _buildInputField(String hint, IconData icon, TextEditingController controller, {bool isPass = false}) =>
      TextField(
        controller: controller,
        obscureText: isPass,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.black54),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
}
