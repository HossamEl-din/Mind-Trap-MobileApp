import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/Mentor_Cubit/mentor_Cubit.dart';
import 'package:grad/widgets/Mentor/mintor_model.dart';

void showContactSheet(BuildContext context, Mentor mentor) {
  final mentorCubit = context.read<MentorshipCubit>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, 
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return SingleChildScrollView( 
        child: Container(
          padding: EdgeInsets.only(
            top: 25,
            left: 25,
            right: 25,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 25, 
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF0F172A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[700], borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 25),

              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(colors: [mentor.avatarColor, mentor.avatarColor.withOpacity(0.6)]),
                ),
                child: Center(child: Text(mentor.initials, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white))),
              ),
              const SizedBox(height: 15),

              Text(mentor.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🎓', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 5),
                  Text('${mentor.badges.isNotEmpty ? mentor.badges.last : "Expert"} Mentor', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
              const SizedBox(height: 30),

              _buildContactRow(sheetContext, Icons.phone_android, 'Phone', mentor.phone),
              const SizedBox(height: 15),
              _buildContactRow(sheetContext, Icons.email_outlined, 'Email', mentor.email),
              const SizedBox(height: 15),
            
              _buildContactRow(sheetContext, Icons.link, 'LinkedIn', mentor.linkedin),
              const SizedBox(height: 25),

              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orangeAccent.withOpacity(0.3)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('💡 ', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Text(
                        'Introduce yourself and mention your current level and what you need help with.',
                        style: TextStyle(color: Colors.orangeAccent, fontSize: 13, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ==========================================
              // 👈 الزرار الجديد (Send Request) مربوط بالـ API
              // ==========================================
              StatefulBuilder( // استخدمنا StatefulBuilder عشان نتحكم في حالة التحميل جوه الشيت بس
                builder: (BuildContext context, StateSetter setSheetState) {
                  bool isSubmitting = false;

                  return InkWell(
                    onTap: isSubmitting ? null : () async {
                      setSheetState(() => isSubmitting = true);
                      
                      // نكلم السيرفر عن طريق الكيوبت
                      String result = await mentorCubit.requestMentor(mentor.id);
                      
                      setSheetState(() => isSubmitting = false);

                      if (sheetContext.mounted) {
                        Navigator.pop(sheetContext); // نقفل الشيت بعد ما يخلص
                        
                        // نطلع رسالة النتيجة لليوزر (سواء نجاح أو إيرور من الباك إند)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result == "success" ? "Request sent successfully! 🎉" : result),
                            backgroundColor: result == "success" ? Colors.green : Colors.redAccent,
                            duration: const Duration(seconds: 3),
                          )
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFFA855F7)]),
                      ),
                      child: Center(
                        child: isSubmitting 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('🚀 Send Request', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  );
                }
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}

// دالة مساعدة لرسم صفوف التواصل (زي ما هي عندك)
Widget _buildContactRow(BuildContext context, IconData icon, String label, String value) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.cyanAccent, size: 22),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('$label Copied!'),
              backgroundColor: const Color(0xFF818CF8),
              duration: const Duration(seconds: 2),
            ));
          },
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFF312E81).withOpacity(0.4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            minimumSize: Size.zero,
          ),
          child: const Text('Copy', style: TextStyle(color: Color(0xFF818CF8), fontWeight: FontWeight.bold, fontSize: 13)),
        )
      ],
    ),
  );
}