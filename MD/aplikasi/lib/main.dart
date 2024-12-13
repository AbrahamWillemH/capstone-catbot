import 'package:aplikasi/screens/chatbot_screen.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat Disease Detection',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            final args = settings.arguments as Map<String, dynamic>?; // Ambil argumen
            final email = args?['email'] ?? 'default@example.com'; // Default jika email tidak ada
            return MaterialPageRoute(
              builder: (context) => HomeScreen(email: email, password: AutofillHints.password,), // Kirim data ke HomeScreen
            );
          case '/register':
            return MaterialPageRoute(
              builder: (context) => const RegisterScreen(),
            );
            case '/chatbot':
      return MaterialPageRoute(
        builder: (context) => const ChatBotScreen(), // ini adalah halaman chatbot
      );
          default:
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(), // Default ke LoginScreen
            );
        }
      },
    );
  }
}
