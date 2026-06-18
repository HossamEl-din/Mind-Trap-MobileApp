import 'package:flutter/material.dart';

class LeaderboardItem extends StatelessWidget {
  final int rank;
  final String initials, name, stats, score;
  final Color rankBg, avatarBg;

  const LeaderboardItem({
    super.key, required this.rank, required this.initials, required this.name,
    required this.stats, required this.score, required this.rankBg, required this.avatarBg
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF1A1F2E), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Container(
            width: 35, height: 35,
            decoration: BoxDecoration(color: rankBg, borderRadius: BorderRadius.circular(8)),
            alignment: Alignment.center,
            child: Text("$rank", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: avatarBg, 
            radius: 22, 
            child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                Text(stats, style: const TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ),
          Text(score, style: const TextStyle(color: Colors.blueAccent, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}