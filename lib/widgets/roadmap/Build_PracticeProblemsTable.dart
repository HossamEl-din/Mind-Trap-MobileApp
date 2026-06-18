import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/Practice_Cubit/practice_Cubit.dart';
import 'package:grad/cubits/RoadMap_Cubit/topic_details_cubit.dart';
import 'package:grad/widgets/battle/Battle_Screen.dart';
import 'package:grad/widgets/roadmap/Build_problemrow.dart';
import 'package:grad/widgets/roadmap/roadmap_models.dart';
class PracticeProblemsTable extends StatelessWidget {
  final List<ProblemModel> problems; 
  final int topicId;
  const PracticeProblemsTable({super.key, required this.problems, required this.topicId});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121724),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('STATUS', style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 5,
                  child: Text('PROBLEM NAME', style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 3,
                  child: Text('SUCCESS RATE', style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text('ACTION', style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white10),

          // 2. لو التوبيك مفيهوش مسائل راجعة من السيرفر
          if (problems.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("No problems available yet.", style: TextStyle(color: Colors.grey)),
            ),

          // 3. هنا السحر: بنلف على المسائل الحقيقية ونرسم سطر لكل مسألة 
          ...List.generate(problems.length, (index) {
            final problem = problems[index];
            
            // عشان نعمل ترقيم الحروف (A., B., C.) ديناميك زي ما كنت عاملها
            String letter = '${String.fromCharCode(65 + index)}.'; 

            return Column(
              children: [
                ProblemRow(
                  letter: letter,
                  name: problem.title,             
                  difficulty: problem.difficulty,  
                  successRate: problem.successRate,
                  isSolved: problem.status == 'Solved',
              onSolveTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BattleScreen(
                        problemId: problem.id, 
                        challengeId: problem.id, 
                        isPractice: true,      
                      ),
                    ),
                  );
                  
                  // 👈 ده هيحدث المسائل اللي في الشاشة الحالية عشان زرار Solved ينور
                  if (context.mounted) {
                    context.read<TopicDetailsCubit>().loadTopicDetails(topicId);
                    context.read<PracticeCubit>().init();
                  }
                },
                ),
                
                // بنرسم خط فاصل تحت كل مسألة ما عدا المسألة الأخيرة
                if (index != problems.length - 1)
                  const Divider(height: 1, color: Colors.white10),
              ],
            );
          }),
        ],
      ),
    );
  }
}