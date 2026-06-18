import 'package:flutter/material.dart';

class ActiveChallengeCard extends StatelessWidget {
  const ActiveChallengeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1A1F2E), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _challengeAvatar("MA", "You", "3/5 solved", Colors.pink),
              const Text("VS", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              _challengeAvatar("AK", "Amr Khaled", "4/5 solved", Colors.cyan),
            ],
          ),
          const SizedBox(height: 15),
          const LinearProgressIndicator(value: 0.6, backgroundColor: Color(0xFF0F1522), color: Colors.purpleAccent),
          const SizedBox(height: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent, 
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
            ),
            onPressed: () {}, 
            child: const Text("Continue Battle", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _challengeAvatar(String init, String name, String sub, Color color) {
    return Column(children: [
      CircleAvatar(radius: 20, backgroundColor: color, child: Text(init, style: const TextStyle(color: Colors.white))),
      const SizedBox(height: 5),
      Text(name, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 9)),
    ]);
  }
}