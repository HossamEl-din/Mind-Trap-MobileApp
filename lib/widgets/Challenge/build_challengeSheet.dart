import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/Challenge_Cubit/challenge_Cubit.dart';

class CreateBattleSheet extends StatefulWidget {
  const CreateBattleSheet({super.key});

  @override
  State<CreateBattleSheet> createState() => _CreateBattleSheetState();
}

class _CreateBattleSheetState extends State<CreateBattleSheet> {
  String selectedTopic = 'Random';
  String selectedDifficulty = 'Random';
  String selectedTime = '45 minutes';


  final TextEditingController opponentController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // استخدمنا Padding لمعالجة الكيبورد لما يظهر
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20, right: 20, top: 15,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // مؤشر السحب (Handle Bar)
            Center(
              child: Container(
                width: 40, height: 4, 
                decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(2))
              ),
            ),
            const SizedBox(height: 20),
            
            // العنوان
            const Text("⚔️ Create 1v1 Battle", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            // صندوق القواعد (Rules Box)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF2A3150).withOpacity(0.5), 
                borderRadius: BorderRadius.circular(8), 
                border: Border.all(color: const Color(0xFF3A4268))
              ),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5),
                  children: [
                    TextSpan(text: "First Blood Rules: ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8A94C2))),
                    TextSpan(text: "Both players get the same problem. First correct solution wins "),
                    TextSpan(text: "+50 pts", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    TextSpan(text: ". Draw if time expires."),
                  ]
                )
              )
            ),
            const SizedBox(height: 20),
            
            // إدخال اسم الخصم
            _buildLabel("Opponent Username"),
            const SizedBox(height: 8),
            TextField(
              controller: opponentController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "e.g. omar_khaled",
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: const Color(0xFF0F1522),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              ),
            ),
            const SizedBox(height: 16),
            
            // اختيار الـ Topic
            _buildLabel("Topic"),
            const SizedBox(height: 8),
            _buildDropdown(selectedTopic, ['Random', 'Arrays', 'Strings', 'Graphs'], (val) => setState(() => selectedTopic = val!)),
            const SizedBox(height: 16),
            
            // اختيار الـ Difficulty
            _buildLabel("Difficulty"),
            const SizedBox(height: 8),
            _buildDropdown(selectedDifficulty, ['Random', 'Easy', 'Medium', 'Hard'], (val) => setState(() => selectedDifficulty = val!)),
            const SizedBox(height: 16),
            
            // اختيار الـ Time Limit
            _buildLabel("Time Limit"),
            const SizedBox(height: 8),
            _buildDropdown(selectedTime, ['15 minutes', '30 minutes', '45 minutes', '1 hour'], (val) => setState(() => selectedTime = val!)),
            const SizedBox(height: 25),
            
            // زر الإرسال
           SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: isLoading ? null : () async {
      if (opponentController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter opponent username"), backgroundColor: Colors.orange),
        );
        return;
      }

      setState(() => isLoading = true);

      int minutes = int.parse(selectedTime.split(' ')[0]);

      // استدعاء الدالة اللي بترجع String لو في خطأ، أو null لو نجحت
      String? errorMessage = await context.read<ChallengeArenaCubit>().createBattle(
        opponentUsername: opponentController.text.trim(),
        topicTag: selectedTopic,
        difficulty: selectedDifficulty,
        durationMinutes: minutes,
      );

      setState(() => isLoading = false);

      if (errorMessage == null) {
        // لو مفيش خطأ (الرد null)، يبقى نجح
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Battle invite sent successfully!"), backgroundColor: Colors.green),
        );
      } else {
        // لو في خطأ، اعرض الرسالة اللي جاية من السيرفر
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    },
    icon: isLoading 
        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
        : const Text("⚔️", style: TextStyle(fontSize: 18)),
    label: Text(
      isLoading ? "Sending..." : "Send Battle Invite", 
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF6B48FF),
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),
),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  
  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14));
  }

 
  Widget _buildDropdown(String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFF0F1522), borderRadius: BorderRadius.circular(8)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF1A2235),
          style: const TextStyle(color: Colors.white, fontSize: 15),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}