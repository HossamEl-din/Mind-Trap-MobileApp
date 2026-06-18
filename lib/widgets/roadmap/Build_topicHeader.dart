  import "package:flutter/material.dart";
  Widget topicHeader(String title, String percent, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.cyanAccent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.cyanAccent),
          ),
          child: const Icon(Icons.check_circle, color: Colors.greenAccent, size: 35),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(description, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
        ),
        Text(percent, style: const TextStyle(color: Colors.purpleAccent, fontSize: 32, fontWeight: FontWeight.bold)),
      ],
    );
  }