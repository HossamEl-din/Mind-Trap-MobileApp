import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/Mentor_Cubit/mentor_Cubit.dart';
import 'package:grad/cubits/Mentor_Cubit/mentor_State.dart';
import 'package:grad/widgets/Mentor/build_FindMentorTab.dart';
import 'package:grad/widgets/Mentor/build_PendingRequestCard.dart';
class MentorshipScreen extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();
   MentorshipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MentorshipCubit()..fetchInitialData(),
      child: BlocBuilder<MentorshipCubit, MentorshipState>(
        builder: (context, state) {
         
        return Scaffold(
          backgroundColor: const Color(0xFF0F172A),
             appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.grey),
          backgroundColor: const Color(0xFF0F172A),
          elevation: 0,
         
          title: state.isSearching 
            ? TextField(
                controller: searchController,
                autofocus: true, 
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search mentors...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  context.read<MentorshipCubit>().searchMentors(value);
                },
              )
            : const Row(
                children: [
                  Icon(Icons.people_alt_rounded, color: Color(0xFF818CF8)),
                  SizedBox(width: 10),
                 Text('Mentorship', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), // 👈 اللون دخل جوه الأقواس بتاعت الستايل
                ],
              ),
          actions: [
            IconButton(
              
              icon: Icon(state.isSearching ? Icons.close : Icons.search, color: Colors.grey),
              onPressed: () {
                if (state.isSearching) {
                  searchController.clear(); 
                }
               
                context.read<MentorshipCubit>().toggleSearch();
              },
            )
          ],
        ),
          body: BlocBuilder<MentorshipCubit, MentorshipState>(
            builder: (context, state) {
              
              
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF818CF8)));
              }
        
              return Column(
                children: [
        
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.read<MentorshipCubit>().changeTab(0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: state.activeTab == 0 ? const Color(0xFF818CF8) : Colors.transparent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Center(
                                child: Text("Find a Mentor", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.read<MentorshipCubit>().changeTab(1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: state.activeTab == 1 ? const Color(0xFF818CF8) : Colors.transparent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Center(
                                child: Text("Mentor Dashboard", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
        
                 
                  Expanded(
                    child: state.activeTab == 0
                        ? buildFindMentorTab(context, state) 
                        : _buildMentorDashboardTab(context, state), 
                  ),
                ],
              );
            },
          ),
        );
      },
      ),
    );
  }
  

 Widget _buildMentorDashboardTab(BuildContext context, MentorshipState state) {
   
    return RefreshIndicator(
      color: const Color(0xFF818CF8),
      backgroundColor: const Color(0xFF1E293B),
      onRefresh: () async {
   
        await context.read<MentorshipCubit>().fetchMentorDashboardData();
      },
      child: ListView(
      
        physics: const AlwaysScrollableScrollPhysics(), 
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
       
          const Text('🔔 Pending Requests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 15),
          
          state.pendingRequests.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text("No pending requests right now.", style: TextStyle(color: Colors.grey)),
                )
              : Column(
                  children: state.pendingRequests.map((request) {
                    String name = request['studentName'] ?? 'Unknown';
                    String date = request['requestedAt']?.toString().substring(0, 10) ?? '';
                    int connectionId = request['connectionId'] ?? 0;

                   return buildPendingRequestCard(context, name, "Level", date, connectionId);
                  }).toList(),
                ),

          const SizedBox(height: 30),

      
          const Text('👥 My Students', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 15),
          
          state.myStudents.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text("You don't have any students yet.", style: TextStyle(color: Colors.grey)),
                )
              : Column(
                  children: state.myStudents.map((student) {
                    String name = student['name'] ?? 'Unknown';
                    String email = student['email'] ?? 'No Email';
                    
                    return _buildStudentCard(name, email);
                  }).toList(),
                ),
        ],
      ),
    );
  }

  
  

  Widget _buildStudentCard(String name, String email) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(15), border: const Border(left: BorderSide(color: Color(0xFF818CF8), width: 4))),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(backgroundColor: const Color(0xFF818CF8), child: Text(name[0], style: const TextStyle(color: Colors.white))),
        title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(email, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        trailing: const Icon(Icons.chat_bubble_outline, color: Colors.cyanAccent),
      ),
    );
  }
}