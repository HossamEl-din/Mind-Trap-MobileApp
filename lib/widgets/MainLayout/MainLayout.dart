import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/Notification_Cubit/notification_Cubit.dart';
import 'package:grad/cubits/Notification_Cubit/notification_State.dart';
import 'package:grad/cubits/profile_Cubit/profile_Cubit.dart';
import 'package:grad/cubits/profile_Cubit/profile_State.dart';
import 'package:grad/widgets/Challenge/challenge.dart';
import 'package:grad/widgets/Contest/contest_calendar_screen.dart';
import 'package:grad/widgets/Mentor/mintor_screen.dart';
import 'package:grad/widgets/Notifications/notifications_screen.dart';
import 'package:grad/widgets/Profile/profile_screen.dart';
import 'package:grad/widgets/dashboard/dashboard.dart';
import 'package:grad/widgets/login/login.dart';
import 'package:grad/widgets/practice/practice_problem.dart';
import 'package:grad/widgets/roadmap/Roadmap_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomeScreen(),
    RoadmapScreen(),
    PracticeScreen(),
    ChallengeArena_Screen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1221),
      
      appBar: _buildGlobalAppBar(context),
      
      // 👈 ضفنا القائمة الجانبية هنا (تفتح من اليمين)
      endDrawer: _buildEndDrawer(context),
      
      body: _pages[_currentIndex < 4 ? _currentIndex : 0], 

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(), 
        notchMargin: 8.0,
        color: const Color(0xFF1A2235),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.dashboard, color: _currentIndex == 0 ? Colors.cyanAccent : Colors.grey),
              onPressed: () => setState(() => _currentIndex = 0),
            ),
            IconButton(
              icon: Icon(Icons.map, color: _currentIndex == 1 ? Colors.cyanAccent : Colors.grey),
              onPressed: () => setState(() => _currentIndex = 1),
            ),
            const SizedBox(width: 40), 
            IconButton(
              icon: Icon(Icons.code, color: _currentIndex == 2 ? Colors.cyanAccent : Colors.grey),
              onPressed: () => setState(() => _currentIndex = 2),
            ),
            IconButton(
              icon: Icon(Icons.emoji_events, color: _currentIndex == 3 ? Colors.cyanAccent : Colors.grey),
              onPressed: () => setState(() => _currentIndex = 3),
            ),
          ],
        ),
      ),
    );
  }

  // --- دالة بناء الـ AppBar ---
  PreferredSizeWidget _buildGlobalAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          Image.asset('assets/images/logo.png', height: 30),
          const SizedBox(width: 8),
          const Text("MindTrap",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        ],
      ),
      actions: [
       BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, notifState) {
            final bool isEnabled = context.select((ProfileCubit cubit) => 
                cubit.state.settings['Challenge Notification'] ?? true);

            return Badge(
              // الـ Badge هيظهر بس لو الإشعارات متفعلة (isEnabled) وكمان في رسايل جديدة
              isLabelVisible: isEnabled && notifState.unreadCount > 0,
              label: Text('${notifState.unreadCount}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              backgroundColor: Colors.redAccent,
              offset: const Offset(-5, 5),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                  );
                },
                icon: const Icon(Icons.notifications_none, color: Colors.yellow, size: 28),
              ),
            );
          },
        ),
        Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 28),
              onPressed: () {
                // فتح القائمة الجانبية
                Scaffold.of(context).openEndDrawer();
              },
            );
          }
        ),
        const SizedBox(width: 8), // مسافة صغيرة من الحافة
      ],
    );
  }

  // --- دالة بناء القائمة الجانبية (Drawer) ---
  Widget _buildEndDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0F172A), // لون متناسق مع التطبيق
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // رأس القائمة (ممكن تحط فيها صورة اليوزر واسمه مستقبلاً)
         // رأس القائمة (مربوط بالـ Cubit عشان يكون ديناميك)
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6B48FF), Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            // 👈 غلفنا المحتوى بـ BlocBuilder عشان يقرأ من الـ State
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white24,
                      radius: 35,
                      child: Text(
                        state.initials, // 👈 الحروف بقت ديناميك هنا
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      state.fullName, // 👈 الاسم بالكامل بقى ديناميك هنا
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.event, color: Colors.cyanAccent),
            title: const Text('Contests', style: TextStyle(color: Colors.white)),
            onTap: () {
                Navigator.pop(context); 
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  ContestCalendarScreen(),
                  ),
                );
              },
          ),
          ListTile(
              leading: const Icon(Icons.people_alt, color: Color(0xFF818CF8)), // أيقونة المنتور
              title: const Text(
                'Mentorship', 
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
              ),
              onTap: () {
                Navigator.pop(context); 
                
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  MentorshipScreen(),
                  ),
                );
              },
            ),
            const Divider(color: Colors.white12),
          
          ListTile(
            leading: const Icon(Icons.person, color: Colors.cyanAccent),
            title: const Text('Profile & Settings', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context); 
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  ProfileScreen()), 
              );
            },
          ),
          
          // عنصر إضافي كمثال
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.grey),
            title: const Text('Help & Support', style: TextStyle(color: Colors.grey)),
            onTap: () {
              // TODO: مسار الدعم الفني
            },
          ),
          
          const Divider(color: Colors.white24, thickness: 1, endIndent: 20, indent: 20),
          
          
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()), 
                  (route) => false
                );
              }
            },
          ),
        ],
      ),
    );
  }
}