import 'package:flutter/gestures.dart'; 
import 'package:flutter/material.dart';
import '../styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Hanya satu deklarasi untuk fungsi _navigateTo
  void _navigateTo(String routeName) async {
    final email = _emailController.text; // Ambil email dari input

    // Menampilkan loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 56, 142, 60),
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pop(context); // Tutup dialog (splash screen)
      Navigator.pushReplacementNamed(
        context,
        routeName,
        arguments: {'email': email}, // Kirim email ke halaman berikutnya
      );
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
            const Text(
              'Cat Disease Detection',
              textAlign: TextAlign.center,
              style: AppStyles.titleStyle,
            ),
            const SizedBox(height: 10),
            const Text(
              'Login to Continue',
              textAlign: TextAlign.center,
              style: AppStyles.subtitleStyle,
            ),
            const SizedBox(height: 30),
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
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _navigateTo('/home'); // Navigasi ke halaman home dengan splash
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 56, 142, 60),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Login', style: AppStyles.buttonTextStyle),
                  ),
                  const SizedBox(height: 40),
                  // Pindah ke Register
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Belum punya akun? Daftar ',
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
                              _navigateTo('/register');
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
