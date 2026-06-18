import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/Practice_Cubit/practice_Cubit.dart';
import 'package:grad/cubits/Practice_Cubit/practice_State.dart';
import 'package:grad/widgets/battle/Battle_Screen.dart';
import 'package:grad/widgets/practice/buildFilterRow.dart';
import 'package:grad/widgets/practice/buildProblemRow.dart';
import 'package:grad/widgets/practice/buildSimpleStatCard.dart';
class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PracticeCubit()..init(),
      child: Scaffold(
        backgroundColor:  Color(0xFF0B1221),
        body: BlocBuilder<PracticeCubit, PracticeState>(
          builder: (context, state) {
            if (state is PracticeLoading) {
              return  Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
            }
            if (state is PracticeSuccess) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:  EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text("Practice Problems", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                           SizedBox(height: 20),
                          
                          
                          SearchBar(
                            hintText: "Search problems...",
                            textStyle: WidgetStateProperty.all(TextStyle(color: Colors.white)),
                            onChanged: (v) => context.read<PracticeCubit>().updateFilters(query: v),
                            backgroundColor: WidgetStateProperty.all( Color(0xFF1A2235)),
                            elevation: WidgetStateProperty.all(0),
                            leading:  Icon(Icons.search, color: Colors.white),
                            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          ),

                           SizedBox(height: 20),

                          
                          buildFilterRow(["All", "Solved", "Unsolved", "Attempted"], state.selectedStatus, 
                              (v) => context.read<PracticeCubit>().updateFilters(status: v)),
                           SizedBox(height: 10),
                          buildFilterRow(["All Levels", "Easy", "Medium", "Hard"], state.selectedLevel, 
                              (v) => context.read<PracticeCubit>().updateFilters(level: v)),
                           SizedBox(height: 10),
                          buildFilterRow(["All Platforms", "Codeforces", "LeetCode", "AtCoder"], state.selectedPlatform, 
                              (v) => context.read<PracticeCubit>().updateFilters(platform: v)),
                          
                           SizedBox(height: 24),

                          
                          GridView.count(
                            shrinkWrap: true,
                            physics:  NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 2.2,
                            children: [
                              buildSimpleStatCard("187", "Easy Solved", Icons.check_box, Colors.green),
                              buildSimpleStatCard("124", "Medium Solved", Icons.bolt, Colors.orange),
                              buildSimpleStatCard("56", "Hard Solved", Icons.whatshot, Colors.redAccent),
                              buildSimpleStatCard("68", "Success Rate", Icons.check, Colors.blue),
                            ],
                          ),

                           SizedBox(height: 32),
                           Text("All Problems", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                           SizedBox(height: 16),
                          
                           Row(
                            children: [
                              Expanded(flex: 2, child: Text("STATUS", style: TextStyle(color: Colors.grey, fontSize: 12))),
                              Expanded(flex: 5, child: Text("PROBLEM", style: TextStyle(color: Colors.grey, fontSize: 12))),
                              Expanded(flex: 2, child: Text("ACTION", style: TextStyle(color: Colors.grey, fontSize: 12))),
                            ],
                          ),
                           Divider(color: Colors.white10),
                        ],
                      ),
                    ),
                  ),

                
                  SliverPadding(
                    padding:  EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final p = state.filteredProblems[index];
                         return buildProblemRow(
                            context,
                            p.id,
                            p.name,
                            p.tags,
                            p.level,
                            p.level == "Easy" ? Colors.green : (p.level == "Medium" ? Colors.orange : Colors.redAccent), // الفاصلة هنا أهي
                            p.isSolved,
                            isAttempted: p.isAttempted,
                            onSolvePressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BattleScreen(
                                    challengeId: p.id,
                                    problemId: p.id, 
                                    isPractice: true,
                                  ),
                                ),
                              );
                               if (context.mounted) {
                                  context.read<PracticeCubit>().init();
                               }
                            },
                          );
                        },
                        childCount: state.filteredProblems.length,
                      ),
                    ),
                  ),
                   SliverToBoxAdapter(child: SizedBox(height: 50)),
                ],
              );
            }
            if (state is PracticeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, color: Colors.redAccent, size: 50),
                    const SizedBox(height: 16),
                    Text(state.message, style: const TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => context.read<PracticeCubit>().init(),
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text("Try Again"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                    )
                  ],
                ),
              );
            }
            return  SizedBox();
          },
        ),
      ),
    );
  }
}