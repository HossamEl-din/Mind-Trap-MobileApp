import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/RoadMap_Cubit/roadmap_Cubit.dart';
import 'package:grad/cubits/RoadMap_Cubit/roadmap_State.dart';
import 'package:grad/widgets/roadmap/Build_contentlist.dart';
import 'package:grad/widgets/roadmap/Build_filterrow.dart';
import 'package:grad/widgets/roadmap/Build_statecard.dart';
class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoadmapCubit()..loadRoadmap(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1221),
        body: BlocBuilder<RoadmapCubit, RoadmapState>(
          builder: (context, state) {
            if (state is RoadmapLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
            } 
            
          if (state is RoadmapSuccess) {
            // 1. تعريف المتغيرات اللي هنجمع فيها الإحصائيات
            int totalSolved = 0;
            int totalProblems = 0;
            int completedTopics = 0;
            int totalTopicsCount = 0;
           

            // 2. عملية الجمع من كل المستويات والتوبيكس
            for (var level in state.levels) {
              for (var topic in level.topics) {
                totalTopicsCount++;
                totalSolved += topic.solvedProblems;
                totalProblems += topic.totalProblems;
                
                // لو عدد المسائل المحلولة بيساوي العدد الكلي للتوبيك، يبقى التوبيك ده خلص
                if (topic.solvedProblems == topic.totalProblems && topic.totalProblems > 0) {
                  completedTopics++;
                }
              }
            }

            // 3. حساب النسبة المئوية الكلية للمسار (من 0 لـ 1)
            double overallProgress = totalProblems > 0 ? (totalSolved / totalProblems) : 0.0;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Learning Roadmap", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text("Master competitive programming with our path", style: TextStyle(color: Colors.grey, fontSize: 14)),
                  
                  const SizedBox(height: 24),
                  
                  // 👈 هنا استدعينا الكارت وباصيناله الأرقام الحقيقية اللي حسبناها
                  StatsCard(
                    problemsSolved: state.totalProblemsSolved,
                    topicsCompleted: completedTopics,
                    totalTopics: totalTopicsCount,
                    dayStreak: state.dayStreak, // رقم ثابت مؤقتاً لحد ما الـ API يدعمه
                    progressPercentage: overallProgress,

                  ),
                  
                  const SizedBox(height: 24),
                  FilterRow(selectedFilter: state.selectedFilter, levels: state.levels), 
                  const SizedBox(height: 24),
                  ContentList(selectedFilter: state.selectedFilter, levels: state.levels), 
                ],
              ),
            );
          }
            return Center(child: Text("Error Loading Roadmap", style: TextStyle(color: Colors.white)));
          },
        ),
      ),
    );
  }
}