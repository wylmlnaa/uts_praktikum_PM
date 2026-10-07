import 'package:flutter/material.dart';
import 'main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idStafController = TextEditingController();
  final TextEditingController _kataSandiController = TextEditingController();
  bool _isObscure = true;

  @override
  void dispose() {
    _idStafController.dispose();
    _kataSandiController.dispose();
    super.dispose();
  }

  void _processLogin() {
    final String idStaf = _idStafController.text.trim();
    final String kataSandi = _kataSandiController.text.trim();

    if (idStaf == 'petugas' && kataSandi == '1234') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Berhasil! Selamat datang.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainNavigationScreen(
            stafName: 'Petugas Lapangan',
            stafId: 'STAF-8892',
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Gagal'),
            content: const Text(
              'ID Staf atau Kata Sandi salah!\n\n'
              'Gunakan data dummy:\n'
              'ID Staf: petugas\n'
              'Kata Sandi: 1234',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Login Staf Lapangan'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.local_shipping,
                    size: 60,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "CargoFlow Logistics",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const Text(
                    "Aplikasi Logistik Kargo",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Input ID Staf
                  TextField(
                    controller: _idStafController,
                    decoration: const InputDecoration(
                      labelText: "ID Staf",
                      hintText: "Masukkan ID Staf (contoh: petugas)",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Input Kata Sandi
                  TextField(
                    controller: _kataSandiController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: "Kata Sandi",
                      hintText: "Masukkan Kata Sandi (contoh: 1234)",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tombol Login
                  ElevatedButton(
                    onPressed: _processLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "MASUK",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
