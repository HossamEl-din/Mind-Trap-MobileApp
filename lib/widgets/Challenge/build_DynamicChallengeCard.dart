import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/Challenge_Cubit/challenge_Cubit.dart';
import 'package:grad/widgets/battle/Battle_Screen.dart';
 Widget buildDynamicChallengeCard(BuildContext context, dynamic challenge, String currentTab) {
    final int challengeId = challenge['id'] ?? 0;
    final String role = challenge['role'] ?? ''; 
    final String opponentName = challenge['opponentName'] ?? 'Unknown';

    return Card(
      color: const Color(0xFF1A2235),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    challenge['title'] ?? 'Challenge Battle', 
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
                  )
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.cyan.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                  child: Text(challenge['difficulty'] ?? 'Medium', style: const TextStyle(color: Colors.cyanAccent, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 8),
           
            if (currentTab == 'Pending Invites')
              Text("Opponent: $opponentName", style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
            
            Text("Topic: ${challenge['topicTag'] ?? 'General'}", style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 12),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.timer, color: Colors.grey, size: 16),
                    const SizedBox(width: 4),
                    Text("${challenge['durationMinutes'] ?? 0} Mins", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                
              
                if (currentTab == 'Pending Invites') ...[
                  if (role == 'Received') ...[
                    
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => context.read<ChallengeArenaCubit>().cancelChallenge(challengeId),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A2B35), 
                            foregroundColor: Colors.redAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          child: const Text("Decline"),
                        ),
                        const SizedBox(width: 8),
                       ElevatedButton(
                        onPressed: () async {
                         
                          final error = await context.read<ChallengeArenaCubit>().acceptChallenge(challengeId);
                        
                          if (error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error), backgroundColor: Colors.redAccent),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: const Text("Accept"),
                      ),
                      ],
                    )
                  ] else ...[
                 
                    Row(
                      children: [
                        const Text("Waiting...", style: TextStyle(color: Colors.orangeAccent, fontSize: 12, fontStyle: FontStyle.italic)),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => context.read<ChallengeArenaCubit>().cancelChallenge(challengeId),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2A3150), 
                            foregroundColor: Colors.white70,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ],
                    )
                  ]
                ] else if (currentTab == 'Active Challenge') ...[
                  ElevatedButton(
                    onPressed: () {
                              Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BattleScreen(
                            challengeId: challenge['id'], 
                           problemId: challenge['problemId'] ?? challenge['id'] ?? challengeId,
                            isPractice: false, 
                          ),
                          ),
                        ).then((_) {
                          
                                            Future.delayed(const Duration(milliseconds: 500), () {
                          if (context.mounted) {
                            
                            context.read<ChallengeArenaCubit>().init(); 
                          }
                        });
                        });
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Enter", style: TextStyle(fontWeight: FontWeight.bold)),
                  )
                ] else ...[
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A3150),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Results"),
                  )
                ]
              ],
            )
          ],
        ),
      ),
    );
  }