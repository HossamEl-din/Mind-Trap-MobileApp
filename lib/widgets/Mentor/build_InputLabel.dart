import 'package:flutter/material.dart';
Widget buildInputLabel(String label) => Padding(
  padding: const EdgeInsets.only(bottom: 8, top: 15),
  child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
);