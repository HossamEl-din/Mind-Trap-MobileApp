import 'package:flutter/material.dart';
Widget buildDisabledButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(15)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.block, color: Colors.redAccent, size: 16),
          SizedBox(width: 8),
          Text('Currently Full', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }