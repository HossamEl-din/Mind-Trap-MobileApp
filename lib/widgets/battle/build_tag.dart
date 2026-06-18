import 'package:flutter/material.dart';
Widget buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2235),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2A3150)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
    );
  }