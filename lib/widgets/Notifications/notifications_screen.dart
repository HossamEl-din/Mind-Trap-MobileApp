import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/Notification_Cubit/notification_Cubit.dart';
import 'package:grad/cubits/Notification_Cubit/notification_State.dart';
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Text("Notifications", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state.isLoading && state.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF38BDF8)));
          }
    
          if (state.error.isNotEmpty) {
            return Center(child: Text(state.error, style: const TextStyle(color: Colors.redAccent)));
          }
    
          if (state.notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, color: Colors.grey, size: 80),
                  SizedBox(height: 16),
                  Text("No notifications yet", style: TextStyle(color: Colors.grey, fontSize: 18)),
                ],
              ),
            );
          }
    
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.notifications.length,
            itemBuilder: (context, index) {
              final notif = state.notifications[index];
              final bool isRead = notif['isRead'] ?? true;
              final String type = notif['type'] ?? '';
              
            
              IconData iconData = Icons.notifications;
              Color iconColor = Colors.grey;
              if (type == 'BattleInvite') {
                iconData = Icons.sports_kabaddi;
                iconColor = Colors.orangeAccent;
              }
    
           
              String timeAgo = _formatDate(notif['createdAt'] ?? '');
    
              return GestureDetector(
                onTap: () {
                  
                  if (!isRead) {
                    context.read<NotificationCubit>().markAsRead(notif['id']);
                  }
                 
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                
                    color: isRead ? const Color(0xFF1E293B) : const Color(0xFF2B3A55),
                    borderRadius: BorderRadius.circular(15),
                    border: isRead ? null : Border.all(color: const Color(0xFF38BDF8).withOpacity(0.5), width: 1),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: iconColor.withOpacity(0.2),
                        child: Icon(iconData, color: iconColor),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notif['message'] ?? 'Notification',
                              style: TextStyle(
                                color: Colors.white, 
                                fontSize: 15, 
                                fontWeight: isRead ? FontWeight.normal : FontWeight.bold, 
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(timeAgo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(color: Color(0xFF38BDF8), shape: BoxShape.circle),
                        )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

 
  String _formatDate(String isoDate) {
    if (isoDate.isEmpty) return '';
    try {
      DateTime date = DateTime.parse(isoDate);
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return isoDate.split('T').first; 
    }
  }
}