import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final int problemsSolved;
  final int topicsCompleted;
  final int totalTopics;
  final int dayStreak;
  final double progressPercentage;


  const StatsCard({
    super.key,
    required this.problemsSolved,
    required this.topicsCompleted,
    required this.totalTopics,
    required this.dayStreak,
    required this.progressPercentage,
  });

  @override
  Widget build(BuildContext context) {
    // بنحول النسبة المئوية لرقم صحيح عشان نعرضها في النص تحت (مثال: 50%)
    int percentInt = (progressPercentage * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2235), 
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem(problemsSolved.toString(), "Problems Solved", const Color(0xFF4285F4)),
              _statItem("$topicsCompleted/$totalTopics", "Topics Completed", Colors.purpleAccent),
              _statItem(dayStreak.toString(), "Day Streak", const Color(0xFF4285F4)),
            ],
          ),
          const SizedBox(height: 24),
          LinearProgressIndicator(
            value: progressPercentage,
            backgroundColor: const Color(0xFF0B1221),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4), // عشان الحواف تبقى مدورة زي الصورة
          ),
          const SizedBox(height: 12),
          Text(
            "$percentInt% Complete - Keep going!",
            style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // دالة صغيرة بترسم الأرقام والكلمات اللي تحتها
  Widget _statItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }
}