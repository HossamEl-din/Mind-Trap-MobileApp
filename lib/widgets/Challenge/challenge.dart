import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/Challenge_Cubit/challenge_Cubit.dart';
import 'package:grad/cubits/Challenge_Cubit/challenge_State.dart';
import 'package:grad/widgets/Challenge/buildLeaderBoardItem.dart';
import 'package:grad/widgets/Challenge/build_CustomToggleButton.dart';
import 'package:grad/widgets/Challenge/build_DynamicChallengeList.dart';
import 'package:grad/widgets/Challenge/build_challengeSheet.dart';
import 'package:grad/widgets/dashboard/build_Stat_Card.dart';

class ChallengeArena_Screen extends StatelessWidget {
  const ChallengeArena_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1522),
      body: BlocBuilder<ChallengeArenaCubit, ChallengeArenaState>(
        builder: (context, state) {
          if (state is ChallengeArenaLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
          }
    
          if (state is ChallengeArenaError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off_rounded, color: Colors.redAccent, size: 50),
                const SizedBox(height: 16),
                Text(state.message, style: const TextStyle(color: Colors.redAccent, fontSize: 16)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<ChallengeArenaCubit>().init();
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text("Try Again", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B48FF),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                )
              ],
            ),
          );
          }
    
          if (state is ChallengeArenaSuccess) {
            // معالجة وحساب الإحصائيات هنا
            final stats = state.stats;
            final int totalBattles = (stats['totalBattles'] ?? 0) is int 
                ? (stats['totalBattles'] ?? 0) as int 
                : int.tryParse(stats['totalBattles'].toString()) ?? 0;
            
            final int totalWins = (stats['totalWins'] ?? 0) is int 
                ? (stats['totalWins'] ?? 0) as int 
                : int.tryParse(stats['totalWins'].toString()) ?? 0;
            
            final int winStreak = (stats['winStreak'] ?? 0) is int 
                ? (stats['winStreak'] ?? 0) as int 
                : int.tryParse(stats['winStreak'].toString()) ?? 0;

            int winRate = 0;
            if (totalBattles > 0) {
              winRate = ((totalWins / totalBattles) * 100).round();
            }

            return RefreshIndicator(
              color: Colors.cyanAccent,
              backgroundColor: const Color(0xFF1A2235),
              onRefresh: () async {
                context.read<ChallengeArenaCubit>().init();
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Battle Arena ⚔️", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        ElevatedButton.icon(
                          onPressed: () {
                            final challengeCubit = context.read<ChallengeArenaCubit>();
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: const Color(0xFF1A2235),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              builder: (context) => BlocProvider.value(
                                value: challengeCubit,
                                child: const CreateBattleSheet(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add, color: Colors.white, size: 18),
                          label: const Text("Create", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6B48FF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text("Challenge friends and compete in coding battles", style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                    const SizedBox(height: 20),
          
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.3,
                      children: [
                        buildStatCard(totalWins.toString(), "Total Wins", Icons.emoji_events_rounded, Colors.orange, ""),
                        buildStatCard(totalBattles.toString(), "Total Battles", Icons.pending_sharp, Colors.blue, ""),
                        buildStatCard(winStreak.toString(), "Win Streak", Icons.local_fire_department_rounded, Colors.red, ""),
                        buildStatCard("$winRate%", "Win Rate", Icons.bar_chart, Colors.green, ""),
                      ],
                    ),
          
                    const SizedBox(height: 25),
          
                    CustomToggleButton(
                      options: const ["Active Challenge", "Pending Invites", "Completed"],
                      currentSelection: state.activeTab,
                      onSelectionChanged: (val) => context.read<ChallengeArenaCubit>().changeTab(val),
                    ),
          
                    const SizedBox(height: 20),
          
                    buildDynamicChallengeList(state),
          
                    const SizedBox(height: 30),
          
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Leaderboard", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 200,
                          child: CustomToggleButton(
                            options: const ["This Week", "All Time"],
                            currentSelection: state.leaderboardFilter,
                            onSelectionChanged: (val) => context.read<ChallengeArenaCubit>().changeLeaderboardFilter(val),
                          ),
                        ),
                      ],
                    ),
          
                    const SizedBox(height: 15),
          
                    if (state.leaderboard.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text("No ranking data yet", style: TextStyle(color: Colors.grey)),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.leaderboard.length,
                        itemBuilder: (context, index) {
                          final user = state.leaderboard[index];
                          
                          String userName = user['username'] ?? "Unknown";
                          String initials = userName.length >= 2 ? userName.substring(0, 2).toUpperCase() : "U";
                          
                          String wins = "${user['totalWins'] ?? 0} Wins";
                          String score = "${user['points'] ?? 0}";
                          
                          Color rankColor;
                          if (index == 0) rankColor = Colors.amber;
                          else if (index == 1) rankColor = Colors.grey;
                          else if (index == 2) rankColor = Colors.brown;
                          else rankColor = const Color(0xFF2A3150);
                
                          return LeaderboardItem(
                            rank: index + 1,
                            initials: initials,
                            name: userName,
                            stats: wins, 
                            score: score,
                            rankBg: rankColor,
                            avatarBg: Colors.blueGrey,
                          );
                        },
                      ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}