import 'package:flutter/material.dart';

class FeatureButton extends StatelessWidget {
  final IconData icon; // أو يمكنك استخدام Image.asset لو عندك صور معينة
  final String title;
  final String description;
  final Color iconColor;
  final VoidCallback onTap;

  const FeatureButton({
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2638), 
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10), 
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 35),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}