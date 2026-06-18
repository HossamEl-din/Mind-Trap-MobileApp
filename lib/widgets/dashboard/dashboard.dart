import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/Dashboard_Cubit/dashboard_Cubit.dart';
import 'package:grad/cubits/Dashboard_Cubit/dashboard_State.dart';
import 'package:grad/widgets/dashboard/build_Contest_Card.dart';
import 'package:grad/widgets/dashboard/build_Streak_Card.dart';
import 'package:grad/widgets/dashboard/build_Stat_Card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1221),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          
          // 1️⃣ لو بيحمل، نعرض اللودينج
          if (state.isLoading && state.firstName == '...') {
            return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
          }

          // 2️⃣ تظبيط رسالة الترحيب
          String displayTitle = state.firstName.isNotEmpty && state.firstName != '...'
              ? "Welcome back, ${state.firstName}!"
              : "Welcome back!";

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(displayTitle, 
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text("Ready to solve some problems today?",
                    style: TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 24),
                
                // 3️⃣ ربط كروت الإحصائيات بالداتا الحقيقية
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: [
                    buildStatCard(state.problemsSolved.toString(), "Problems Solved", Icons.check_box, Colors.green, ""),
                    buildStatCard(state.contestsParticipated.toString(), "Contests Participated", Icons.emoji_events, Colors.orange, ""),
                    buildStatCard("#${state.globalRanking}", "Global Ranking", Icons.bar_chart, Colors.blue, ""),
                    buildStatCard(state.dayStreak.toString(), "Day Streak", Icons.local_fire_department, Colors.orangeAccent, "Active"),
                  ],
                ),
                
                const SizedBox(height: 24),
                const Text("Daily Streak",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                
                // ⚠️ ملحوظة: لو دالة buildStreakCard بتقبل تمرير الرقم، باصيه ليها كده:
                // buildStreakCard(streakDays: state.dayStreak),
                buildStreakCard(streakDays: state.dayStreak), // حالياً سايبها زي ما هي لحد ما تظبطها تستقبل الرقم
                
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Upcoming Contests",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                        onPressed: () {},
                        child: const Text("View Calendar →", style: TextStyle(color: Colors.cyanAccent))),
                  ],
                ),
                
                // 4️⃣ رسم المسابقات الجاية بشكل ديناميك
                if (state.upcomingContests.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text("No upcoming contests right now.", style: TextStyle(color: Colors.grey)),
                  ),
                  
                ...state.upcomingContests.map((contest) {
                  // استخراج المنصة عشان نجيب أول حرفين منها للوجو (مثال: Codeforces -> CF)
                  String platform = contest['platform'] ?? 'UN';
                  String initials = platform.length >= 2 
                      ? platform.substring(0, 2).toUpperCase() 
                      : platform.toUpperCase();

                  return buildContestCard(
                    contest['title'] ?? 'Unknown Contest',
                    contest['startTime'] ?? 'TBA',
                    contest['duration'] ?? '--',
                    initials,
                    url: contest['url'],
                  );
                }).toList(), // حولنا الـ map لـ List عشان الـ Spread Operator (...) يشتغل
              ],
            ),
          );
        },
      ),
    );
  }
}