import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/Mentor_Cubit/mentor_Cubit.dart';
import 'package:grad/cubits/Mentor_Cubit/mentor_State.dart';
import 'package:grad/widgets/Mentor/build_GradientButton.dart';
import 'package:grad/widgets/Mentor/build_StateCardMentor.dart';
import 'package:grad/widgets/Mentor/build_showBecomeMentorSheet.dart';
import 'package:grad/widgets/Mentor/mintor_model.dart';
import 'package:grad/widgets/Mentor/build_MentorCard.dart';
import 'package:url_launcher/url_launcher.dart'; 

Widget buildFindMentorTab(BuildContext context, MentorshipState state) {
  String activeMentors = state.stats?['activeMentors']?.toString() ?? '0';
  String studentsHelped = state.stats?['studentsHelped']?.toString() ?? '0';
  String averageRating = state.stats?['averageRating']?.toString() ?? '0.0';
  String isFree = state.stats?['isFree']?.toString() ?? 'Free';

 
 List<Mentor> filteredMentors = state.mentors.where((m) {
    
    bool matchLevel = state.selectedLevel == 'All Levels' || m.badges.contains(state.selectedLevel);

   
    bool isFull = m.currentCapacity >= m.maxCapacity || m.maxCapacity == 0;
    bool matchAvailability = state.selectedAvailability == 'All' ||
        (state.selectedAvailability == 'Available' && !isFull) ||
        (state.selectedAvailability == 'Full' && isFull);

    
    bool matchSearch = state.searchQuery.isEmpty || 
        m.name.toLowerCase().contains(state.searchQuery.toLowerCase());

    return matchLevel && matchAvailability && matchSearch; 
  }).toList();

  return RefreshIndicator(
    onRefresh: () async {
      await context.read<MentorshipCubit>().fetchInitialData();
    },
    child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        buildGradientButton(text: ' Become a Mentor', onTap: () => showBecomeMentorSheet(context)),
        const SizedBox(height: 25),
        
       
        GridView.count(
          crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, shrinkWrap: true,
          childAspectRatio: 1.3, 
          physics: const NeverScrollableScrollPhysics(),
          children: [
            build_StatCardMentor(Icons.people_alt_rounded, activeMentors, 'Active Mentors'),
            build_StatCardMentor(Icons.money_off_rounded, isFree, 'All Mentors', isFree: true),
            build_StatCardMentor(Icons.star_rounded, averageRating, 'Avg Rating', valueColor: Colors.amber),
            build_StatCardMentor(Icons.school_rounded, "$studentsHelped+", 'Helped', valueColor: const Color(0xFF818CF8)),
            
          ],
        ),
        const SizedBox(height: 25),
    
        const Text('📌 My Mentors', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 15),
        SizedBox(
          height: 100, 
          width: 500,
          child: state.myConnectedMentors.isEmpty
              ? const Center(child: Text("You don't have any mentors yet.", style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.myConnectedMentors.length,
                  itemBuilder: (context, index) {
                  
                    final myMentorData = state.myConnectedMentors[index];
                    final mentorId = myMentorData['mentorId']; 
    
                   
                    Mentor? fullMentorDetails;
                    try {
                      
                      fullMentorDetails = state.mentors.firstWhere(
                        (m) => m.id == mentorId || m.userId == mentorId
                      );
                    } catch (e) {
                     
                      fullMentorDetails = null; 
                    }
    
                    
                    return buildMyMentorCard(context, myMentorData, fullMentorDetails);
                  },
                ),
        ),
        const SizedBox(height: 25),
    
       SizedBox(
          height: 40,
          child: Builder( 
            builder: (context) {
              
              List<String> dynamicLevels = ['All Levels']; 
              for (var mentor in state.mentors) {
                for (var badge in mentor.badges) {
                  if (!dynamicLevels.contains(badge)) dynamicLevels.add(badge);
                }
              }
    
              return Row(
                children: [
                
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF151E2E), 
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: const Color(0xFF1E293B),
                        
                        value: dynamicLevels.contains(state.selectedLevel) ? state.selectedLevel : 'All Levels',
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 18),
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        items: dynamicLevels.map((String level) {
                          return DropdownMenuItem<String>(
                            value: level,
                            child: Text(level),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            context.read<MentorshipCubit>().changeLevelFilter(newValue);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
    
                
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: ['All', 'Available', 'Full'].map((status) {
                        final isSelected = state.selectedAvailability == status;
                        
                        return GestureDetector(
                          onTap: () => context.read<MentorshipCubit>().changeAvailabilityFilter(status),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                            
                              gradient: isSelected 
                                  ? const LinearGradient(colors: [Color(0xFF06B6D4), Color(0xFF8B5CF6)]) 
                                  : null,
                              color: isSelected ? null : const Color(0xFF151E2E),
                              borderRadius: BorderRadius.circular(20),
                              border: isSelected ? null : Border.all(color: Colors.white.withOpacity(0.1)),
                            ),
                            child: Center(
                              child: Text(
                                status, 
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey, 
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }
          ),
        ),
        const SizedBox(height: 20),
    
       
        filteredMentors.isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.person_off_outlined, size: 50, color: Colors.grey),
                      SizedBox(height: 10),
                      Text('No mentors available.', style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredMentors.length,
                itemBuilder: (context, index) {
                  return buildMentorCard(context, filteredMentors[index]); 
                },
              ),
      ],
    ),
  );
}

Widget buildMyMentorCard(
  BuildContext context, 
  Map<String, dynamic> myMentorData, 
  Mentor? fullMentorDetails,
) {
  String name = myMentorData['name'] ?? 'Unknown';
  String initials = name.trim().isNotEmpty ? name.trim().substring(0, 2).toUpperCase() : 'M';
  String level = myMentorData['level'] ?? 'Mentor';
  if (level.isEmpty && fullMentorDetails != null && fullMentorDetails.badges.isNotEmpty) {
    level = fullMentorDetails.badges.last;
  }

  return Container(
    width: 310, 
    margin: const EdgeInsets.only(right: 15),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
       
        CircleAvatar(
          radius: 25,
          backgroundColor: const Color(0xFFA855F7), 
          child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        const SizedBox(width: 12),
        
       
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.school, color: Colors.grey, size: 14),
                  const SizedBox(width: 4),
                  Text('$level • ', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const Text('Active', style: TextStyle(color: Colors.greenAccent, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
        
      
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           
            InkWell(
              onTap: () => showMyMentorContactDialog(context, myMentorData, fullMentorDetails),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(colors: [Color(0xFF06B6D4), Color(0xFF8B5CF6)]), // تدرج أزرق لموف
                ),
                child: const Row(
                  children: [
                    Icon(Icons.phone, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text('Contact', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // زرار End
            InkWell(
              onTap: () {
                int mId = myMentorData['mentorId'] ?? myMentorData['mentor']?['id'] ?? myMentorData['id'] ?? 0;
                int cId = myMentorData['connectionId'] ?? myMentorData['id'] ?? 0;
               showRateAndEndDialog(context, mId, cId);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                ),
                child: const Text('End', style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        )
      ],
    ),
  );
}


void showMyMentorContactDialog(BuildContext context, Map<String, dynamic> myMentorData, Mentor? fullMentorDetails) {
  
  String phone = fullMentorDetails?.phone ?? myMentorData['phone'] ?? 'N/A';
  String email = fullMentorDetails?.email ?? 'N/A';
  String whatsapp = fullMentorDetails?.whatsapp ?? '';
  String linkedin = fullMentorDetails?.linkedin ?? '';

  String name = myMentorData['name'] ?? 'Unknown';
  String initials = name.trim().isNotEmpty ? name.trim().substring(0, 2).toUpperCase() : 'M';

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return Dialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Contact Mentor', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: () => Navigator.pop(dialogContext)),
                ],
              ),
              const SizedBox(height: 15),
              
            
              Row(
                children: [
                  Container(
                    width: 50, height: 50,
                    decoration: BoxDecoration(color: const Color(0xFFA855F7), borderRadius: BorderRadius.circular(12)),
                    child: Center(child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const Text('Mentor', style: TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 25),

              _buildDialogContactRow(dialogContext, 'PHONE NUMBER', phone, 'Copy', isCopy: true),
              const SizedBox(height: 15),
              _buildDialogContactRow(dialogContext, 'EMAIL ADDRESS', email, 'Copy', isCopy: true),
              const SizedBox(height: 15),
              _buildDialogContactRow(dialogContext, 'WHATSAPP', 'Open WhatsApp Chat', 'Open', isCopy: false, link: whatsapp),
              const SizedBox(height: 15),
              _buildDialogContactRow(dialogContext, 'LINKEDIN', 'View Profile', 'Open', isCopy: false, link: linkedin),
            ],
          ),
        ),
      );
    }
  );
}

Widget _buildDialogContactRow(BuildContext context, String title, String value, String btnText, {required bool isCopy, String? link}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        InkWell(
          onTap: () async {
            if (isCopy) {
             
              await Clipboard.setData(ClipboardData(text: value));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$title Copied! ✅'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  )
                );
              }
            } else if (link != null && link.isNotEmpty) {
            
              String finalUrl = link;
              if (!finalUrl.startsWith('http')) {
                finalUrl = 'https://$finalUrl';
              }

              final Uri url = Uri.parse(finalUrl);
              
              try {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Could not open the link ❌'),
                      backgroundColor: Colors.redAccent,
                    )
                  );
                }
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: const Color(0xFF06B6D4).withOpacity(0.5)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(btnText, style: const TextStyle(color: Color(0xFF06B6D4), fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        )
      ],
    ),
  );
}
void showRateAndEndDialog(BuildContext context, int mentorId, int connectionId) {
 
  final cubit = context.read<MentorshipCubit>();
  
  int selectedRating = 0;
  bool isSubmitting = false;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return StatefulBuilder(
      
        builder: (statefulContext, setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Text('Rate your Mentor ⭐', style: TextStyle(color: Colors.white)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Before ending this connection, please rate your experience.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          index < selectedRating ? Icons.star_rounded : Icons.star_border_rounded,
                          color: Colors.amber,
                          size: 35,
                        ),
                        onPressed: () {
                          setState(() => selectedRating = index + 1);
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isSubmitting ? null : () => Navigator.pop(dialogContext),
                child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: (selectedRating == 0 || isSubmitting) ? null : () async {
                  setState(() => isSubmitting = true);
                  
                 
                  await cubit.rateMentor(mentorId, selectedRating);
                  bool success = await cubit.endMentorshipConnection(connectionId);
                  
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success ? 'Mentorship ended successfully.' : 'Error ending mentorship.'),
                        backgroundColor: success ? Colors.green : Colors.redAccent,
                      ),
                    );
                  }
                },
                child: isSubmitting 
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Submit & End', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        }
      );
    }
  );
}