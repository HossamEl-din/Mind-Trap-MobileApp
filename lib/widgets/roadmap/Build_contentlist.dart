import 'package:flutter/material.dart';
import 'package:grad/widgets/roadmap/Build_subTopicCard.dart';
import 'package:grad/widgets/roadmap/Build_topicHeader.dart';
import 'package:grad/widgets/roadmap/roadmap_models.dart';
class ContentList extends StatelessWidget {
  final String selectedFilter;
  final List<LearningLevel> levels;

  const ContentList({super.key, required this.selectedFilter, required this.levels});

  @override
  Widget build(BuildContext context) {
    // 1️⃣ هندور على المستوى اللي اليوزر اختاره
    final selectedLevel = levels.firstWhere(
      (level) => level.levelName == selectedFilter,
      orElse: () => LearningLevel(levelName: 'Unknown', topics: []),
    );

    if (selectedLevel.topics.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("No topics available yet.", style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    // 2️⃣ حساب نسبة إنجاز المستوى بالكامل (اختياري عشان الهيدر)
    int totalProbs = 0;
    int solvedProbs = 0;
    for (var t in selectedLevel.topics) {
      totalProbs += t.totalProblems;
      solvedProbs += t.solvedProblems;
    }
    String levelPercent = totalProbs == 0 ? "0%" : "${((solvedProbs / totalProbs) * 100).toInt()}%";

    // 3️⃣ رسم التوبيكس
    return Column(
      children: [
        // الهيدر الرئيسي واخد اسم المستوى
        topicHeader(selectedLevel.levelName, levelPercent, "Master fundamental concepts and problem-solving"),
        const SizedBox(height: 16),
        
        // رسم الكروت بتاعة التوبيكس (زي Data Types & Conditions)
        ...selectedLevel.topics.map((topic) {
         return subTopicCard(
              context, 
              topic.id,   
              topic.name, 
              "${topic.solvedProblems}/${topic.totalProblems} problems", 
              topic.progressPercentage / 100, 
            );
        }),
      ],
    );
  }
}