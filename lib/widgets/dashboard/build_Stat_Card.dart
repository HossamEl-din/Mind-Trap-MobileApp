import 'package:flutter/material.dart';

Widget buildStatCard(String value, String label, IconData icon, Color color, String badge) {
  return Container(
    padding: const EdgeInsets.all(10),
   
    height: 450, 
    decoration: BoxDecoration(
      color: const Color(0xFF1A2235),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 30),
            
         
            if (badge.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(badge, style: TextStyle(color: color, fontSize: 10)),
              )
          ],
        ),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    ),
  );
}