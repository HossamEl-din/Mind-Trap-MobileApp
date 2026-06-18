import 'package:flutter/material.dart';
class ProblemRow extends StatelessWidget {
  final String letter;
  final String name;
  final String difficulty;
  final String successRate;
  final bool isSolved;
  final VoidCallback onSolveTap;
  const ProblemRow({
    super.key,
    required this.letter,
    required this.name,
    required this.difficulty,
    required this.successRate,
    required this.isSolved,
    required this.onSolveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                isSolved ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSolved ? const Color(0xFF2E7D32) : Colors.grey[600],
                size: 22,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$letter\n$name',
                  style: TextStyle(fontSize: 14, height: 1.2, fontWeight: FontWeight.w500, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: difficulty == 'Easy' 
                        ? const Color(0xFF1B3624) 
                        : const Color(0xFF422F15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    difficulty,
                    style: TextStyle(
                      fontSize: 10, 
                      color: difficulty == 'Easy' ? const Color(0xFF66BB6A) : const Color(0xFFFFA726),
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
          ),
          // نسبة النجاح
          Expanded(
            flex: 3,
            child: Text(
              successRate,
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ),
          // زر الأكشن
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: isSolved ? null : onSolveTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSolved ?   Color.fromARGB(0, 70, 70, 70) :  Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding:  EdgeInsets.symmetric(horizontal: 5),
                    elevation: 0,
                  ),
                  child: Text(
                    isSolved ? 'Solved' : 'Solve',
                    style: TextStyle(
                      fontSize: 12, 
                      color: isSolved ? Colors.white60 :  Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}