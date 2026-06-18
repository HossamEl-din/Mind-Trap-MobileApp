import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/profile_Cubit/profile_Cubit.dart';
import 'package:grad/cubits/profile_Cubit/profile_State.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.isLoading && state.firstName == 'Loading...') {
            return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            children: [
              _buildProfileCard(state), 
              
              _title('Account Settings'),
              _infoTile(context, 'Full Name', state.fullName, (val) => context.read<ProfileCubit>().updateProfile(fullName: val)),
              _infoTile(context, 'Username', state.username, (val) => context.read<ProfileCubit>().updateProfile(username: val)),
              _infoTile(context, 'Email', state.email, (val) => context.read<ProfileCubit>().updateProfile(email: val)),
              _infoTile(context, 'Bio', state.bio, (val) => context.read<ProfileCubit>().updateProfile(bio: val)),
              
              _title('Preferences'),
              _switchTile(context, 'Dark Mode', 'Enable dark theme', state.settings),
              _switchTile(context, 'Auto-save Code', 'Automatically save your code', state.settings),
              _switchTile(context, 'Show Hints', 'Display problem hints during contest', state.settings),
              
              _title('Notifications'),
              _switchTile(context, 'Contest Reminder', 'Get notified before contests start', state.settings),
              _switchTile(context, 'Challenge Notification', 'Receive alerts when challenged', state.settings),
              _switchTile(context, 'Streak Reminder', 'Daily reminders to maintain streak', state.settings),
            ],
          );
        },
      ),
    );
  }


  Widget _buildProfileCard(ProfileState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(colors: [Colors.purpleAccent, Colors.deepPurple]),
            ),
         
            child: Center(
              child: Text(
                state.initials, 
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(state.fullName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          Text('@${state.username}', style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _badge('Pro Member', Colors.orangeAccent),
              _badge('Verified', Colors.cyan),
            ],
          ),
          const SizedBox(height: 10),
          _badge('45 Day Streak', Colors.blueAccent),
          const Divider(height: 30, color: Colors.white24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
           
              _stat(state.problemsSolved.toString(), 'Problems', Colors.lightBlueAccent),
              _stat('0', 'Contests', Colors.grey), 
              _stat(state.globalRank, 'Global Rank', Colors.purpleAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
        child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
      );

  Widget _stat(String val, String lbl, Color clr) => Column(
        children: [
          Text(val, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: clr)),
          Text(lbl, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      );

  Widget _title(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      );

  
  Widget _infoTile(BuildContext context, String title, String value, Future<bool> Function(String) onSave) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          tileColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          subtitle: Text(value, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          trailing: IconButton(
            icon: const Icon(Icons.edit, color: Colors.grey, size: 20),
            onPressed: () => _showEditDialog(context, title, value, onSave),
          ),
        ),
      );

  Widget _switchTile(BuildContext context, String title, String sub, Map<String, bool> settings) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          tileColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          subtitle: Text(sub, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          trailing: CupertinoSwitch(
            value: settings[title] ?? false,
            activeColor: const Color(0xFF38BDF8),
            onChanged: (val) => context.read<ProfileCubit>().toggleSetting(title, val),
          ),
        ),
      );

  void _showEditDialog(BuildContext context, String title, String currentValue, Future<bool> Function(String) onSave) {
    TextEditingController controller = TextEditingController(text: currentValue);
    
    bool isSaving = false; 

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: Text('Edit $title', style: const TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter new $title',
              hintStyle: const TextStyle(color: Colors.grey),
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF38BDF8))),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            StatefulBuilder(
              builder: (context, setState) {
                return TextButton(
                  onPressed: isSaving ? null : () async {
                    setState(() => isSaving = true); 
                    
                    bool success = await onSave(controller.text); 
                    
                    if (context.mounted) {
                      Navigator.pop(context); 
                      
                     
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success ? '$title updated successfully! ' : 'Failed to update $title. Try again.',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: success ? Colors.green : Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    }
                  },
                  child: isSaving 
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF38BDF8)))
                      : const Text('Save', style: TextStyle(color: Color(0xFF38BDF8))),
                );
              }
            ),
          ],
        );
      },
    );
  }
}