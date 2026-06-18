import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
Widget buildContactRow(BuildContext context, IconData icon, String label, String value) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      children: [
     
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.cyanAccent, size: 22),
        ),
        const SizedBox(width: 15),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        
        TextButton(
          onPressed: () {
            // كود نسخ النص
            Clipboard.setData(ClipboardData(text: value));
            // رسالة تأكيد للنسخ
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('$label Copied!'),
              backgroundColor: const Color(0xFF818CF8),
              duration: const Duration(seconds: 2),
            ));
          },
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFF312E81).withOpacity(0.4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            minimumSize: Size.zero,
          ),
          child: const Text('Copy', style: TextStyle(color: Color(0xFF818CF8), fontWeight: FontWeight.bold, fontSize: 13)),
        )
      ],
    ),
  );
}