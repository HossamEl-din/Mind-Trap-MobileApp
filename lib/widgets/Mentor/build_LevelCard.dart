import 'package:flutter/material.dart';
Widget buildLevelCard(String icon, String label, bool isSelected, VoidCallback onTap) => GestureDetector(
  onTap: onTap, // تفعيل الضغط
  child: AnimatedContainer( // AnimatedContainer عشان اللون يتغير بنعومة
    duration: const Duration(milliseconds: 200),
    decoration: BoxDecoration(
      color: const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(10),
      border: isSelected ? Border.all(color: const Color(0xFF818CF8), width: 1.5) : Border.all(color: Colors.transparent, width: 1.5),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(
          color: isSelected ? const Color(0xFF818CF8) : Colors.white, 
          fontWeight: FontWeight.bold, 
          fontSize: 13
        )),
      ],
    ),
  ),
);