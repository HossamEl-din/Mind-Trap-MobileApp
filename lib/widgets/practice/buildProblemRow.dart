import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/Practice_Cubit/practice_Cubit.dart';
import 'package:grad/widgets/battle/Battle_Screen.dart';
Widget buildProblemRow(
  BuildContext context,
  int id,
  String name, 
  List<String> tags, 
  String level, 
  Color levelColor, 
  bool isSolved, {
  bool isAttempted = false,
  VoidCallback? onSolvePressed,
}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Icon(
              isSolved ? Icons.check_circle : (isAttempted ? Icons.hourglass_bottom : Icons.radio_button_unchecked),
              color: isSolved ? Colors.green : (isAttempted ? Colors.orange : Colors.grey),
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  children: [
                    ...tags.map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(4)),
                      child: Text(tag, style: const TextStyle(color: Colors.grey, fontSize: 9)),
                    )),
                    Text(level, style: TextStyle(color: levelColor, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
         Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BattleScreen(challengeId: id, problemId: id, isPractice: true),
    ),
  ).then((_) {
    // السطر ده عشان يعمل Refresh لما ترجع (تأكد إن اسم الدالة عندك init أو حسب ما مسميها)
    context.read<PracticeCubit>().init(); 
  });
},
            style: ElevatedButton.styleFrom(
              backgroundColor: isSolved ? Colors.blue.withOpacity(0.1) : Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              padding: EdgeInsets.zero,
            ),
            child: Text(
              isSolved ? "View" : "Solve",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          )
        ],
      ),
    );
  }
