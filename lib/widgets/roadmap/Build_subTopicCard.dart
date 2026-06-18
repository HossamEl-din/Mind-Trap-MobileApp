 import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:grad/cubits/RoadMap_Cubit/roadmap_Cubit.dart";
import "package:grad/widgets/roadmap/problem_contest.dart";
Widget subTopicCard(BuildContext context,int topicId, String title, String subtitle, double progress) {
    return Container(
      margin:  EdgeInsets.only(bottom: 12),
      padding:  EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:  Color(0xFF1A2235),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            children: [
               Icon(Icons.check_circle, color: Colors.cyanAccent, size: 24),
               SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(subtitle, style:  TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              IconButton(
  onPressed: () async { // 👈 خلينا دي async
    // 👈 حطينا await هنا عشان نستنى اليوزر لحد ما يخلص ويقفل شاشة التفاصيل
    await Navigator.push(context, MaterialPageRoute(
      builder: (context) => ConditionsScreen(topicId: topicId, topicName: title)
    ));
    
    // 👈 أول ما اليوزر يرجع لشاشة الرود ماب، الكود ده هيشتغل ويحدث الشاشة والنسبة!
    if (context.mounted) {
      context.read<RoadmapCubit>().loadRoadmap();
    }
  }, 
  icon: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16)
),
            ],
          ),
           SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor:  Color(0xFF0B1221),
            valueColor:  AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
          ),
        ],
      ),
    );
  }