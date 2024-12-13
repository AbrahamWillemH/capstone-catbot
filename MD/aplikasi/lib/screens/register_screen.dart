import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../styles.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _navigateWithSplash(String routeName) async {
    // Tampilkan splash screen sementara
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 56, 142, 60),
        ),
      ),
    );

    // Beri jeda sebelum navigasi
    await Future.delayed(const Duration(seconds: 2));

    // Tutup splash screen dan navigasi
    if (mounted) {
      Navigator.pop(context); // Menutup dialog (splash screen)
      Navigator.pushReplacementNamed(context, routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 208, 240, 192),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Judul Sistem
            const Text(
              'Cat Disease Detection',
              textAlign: TextAlign.center,
              style: AppStyles.titleStyle,
            ),
            const SizedBox(height: 10),
            const Text(
              'Register to Get Started',
              textAlign: TextAlign.center,
              style: AppStyles.subtitleStyle,
            ),
            const SizedBox(height: 30),
            // Form Register
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: AppStyles.textFieldDecoration.copyWith(
                      hintText: 'Email',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: AppStyles.textFieldDecoration.copyWith(
                      hintText: 'Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password tidak boleh kosong';
                      }
                      if (value.length < 6) {
                        return 'Password harus lebih dari 6 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Tombol Register
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registrasi berhasil')),
                        );

                        // Pindah ke halaman login dengan splash screen
                        _navigateWithSplash('/login');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 56, 142, 60),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Register',
                        style: AppStyles.buttonTextStyle),
                  ),
                  const SizedBox(height: 40),
                  // Pindah ke Login
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Sudah punya akun? Login ',
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'di sini',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 33, 112, 203),
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _navigateWithSplash('/login');
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
