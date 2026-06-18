 import 'package:flutter/material.dart';
 Widget buildSmallBadge(String text) {
    Color bgColor = text == 'Verified' ? Colors.green.withOpacity(0.2) : const Color(0xFF818CF8).withOpacity(0.2);
    Color txtColor = text == 'Verified' ? Colors.greenAccent : const Color(0xFF818CF8);
    IconData? icon = text == 'Verified' ? Icons.check : (text == 'Senior' ? Icons.workspace_premium : Icons.menu_book);

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(icon, size: 12, color: txtColor),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: txtColor, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }