import 'package:flutter/material.dart';

Widget buildStreakCard({required int streakDays}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFF1A2235),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: [
        const Icon(Icons.local_fire_department, color: Colors.orange, size: 50),
        Text(
          streakDays.toString(), 
          style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)
        ),
        const Text("Days in a row!", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
        
        // 👈 الشرط ده عشان لو الستريك بصفر، ميعملش مساحة فاضية على الفاضي
        if (streakDays > 0)
          Container(
            padding: const EdgeInsets.all(8),
            child: Wrap(
              spacing: 7, 
              runSpacing: 5,
              alignment: WrapAlignment.center,
              // 👈 خلينا العدد هنا هو نفس رقم الستريك
              children: List.generate(streakDays, (index) {
                return Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    // المربعات كلها هتنور لأننا مش بنرسم غير الـ Active بس
                    gradient: const LinearGradient(colors: [Color(0xFFFF8C00), Color(0xFFFF0080)]),
                    border: Border.all(color: Colors.white10),
                  ),
                );
              }),
            ),
          ),
      ],
    ),
  );
}