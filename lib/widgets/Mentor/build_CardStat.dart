 import 'package:flutter/material.dart';
 Widget buildCardStat(String value, String label, Color valColor) => Column(
    children: [
      Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: valColor)),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    ],
  );