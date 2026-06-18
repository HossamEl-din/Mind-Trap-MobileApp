import 'package:flutter/material.dart';
  Widget buildResultRow(String title, String value, {bool isError = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0F18),
            borderRadius: BorderRadius.circular(8),
            border: isError ? Border.all(color: Colors.redAccent.withOpacity(0.5)) : null,
          ),
          child: Text(
            value,
            style: TextStyle(
              color: isError ? Colors.redAccent : Colors.white,
              fontFamily: 'monospace',
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }