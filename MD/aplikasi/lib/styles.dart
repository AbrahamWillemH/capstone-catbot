import 'package:flutter/material.dart';

class AppStyles {
  static const Color backgroundColor = Color(0xFF128C7E); // Hijau seperti WhatsApp
  static const Color primaryColor = Color.fromARGB(255, 0, 0, 0);
  static const TextStyle titleStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: primaryColor,
  );
  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 0, 0, 0),
  );
  static const InputDecoration textFieldDecoration = InputDecoration(
    filled: true,
    fillColor: Color.fromARGB(255, 255, 255, 255),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide.none,
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    hintStyle: TextStyle(color: Color.fromARGB(255, 162, 162, 162)),
  );
}
