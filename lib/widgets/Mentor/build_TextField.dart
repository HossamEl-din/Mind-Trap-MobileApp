import 'package:flutter/material.dart';
Widget buildTextField(String hint) => TextField(
  style: const TextStyle(color: Colors.white),
  decoration: InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.grey),
    filled: true,
    fillColor: const Color(0xFF1E293B),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
  ),
);