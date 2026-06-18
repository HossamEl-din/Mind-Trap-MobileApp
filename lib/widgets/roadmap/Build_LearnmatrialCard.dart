import 'package:flutter/material.dart';
class LearnMaterialCard extends StatelessWidget {
  final String title;
  final String type;
  final String duration;
  final Color iconBgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const LearnMaterialCard({
    super.key,
    required this.title,
    required this.type,
    required this.duration,
    required this.iconBgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: EdgeInsets.only(right:12),
        padding:  EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF161B26),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.code, color: iconColor, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 13, height: 1.2, fontWeight: FontWeight.w500, color: Colors.white),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(type, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                      Text('• $duration', style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}