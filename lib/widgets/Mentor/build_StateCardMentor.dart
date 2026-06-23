import 'package:flutter/material.dart';

Widget build_StatCardMentor(IconData icon, String value, String label, {bool isFree = false, bool isFull = false, Color? valueColor}) {
  
  Color activeColor = isFull ? Colors.redAccent : (isFree ? Colors.greenAccent : const Color(0xFF818CF8));

  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(15),
      border: Border(
        top: BorderSide(color: activeColor, width: 2) 
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon, 
          size: 28, 
          color: activeColor 
        ),
        const SizedBox(height: 8),
        Text(
          value, 
          style: TextStyle(
            fontSize: 22, 
            fontWeight: FontWeight.bold, 
            color: valueColor ?? Colors.white
          )
        ),
        const SizedBox(height: 4),
        Text(
          label, 
          style: const TextStyle(color: Colors.grey, fontSize: 12)
        ),
      ],
    ),
  );
}