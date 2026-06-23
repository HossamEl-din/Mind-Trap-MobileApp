import 'package:flutter/material.dart';
Widget buildStudentCard(String name, String email) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(15), border: Border(left: BorderSide(color: const Color(0xFF818CF8), width: 4))),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(backgroundColor: const Color(0xFF818CF8), child: Text(name[0], style: const TextStyle(color: Colors.white))),
        title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(email, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ),
    );
  }