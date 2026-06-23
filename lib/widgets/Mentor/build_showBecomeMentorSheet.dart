import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/Mentor_Cubit/mentor_Cubit.dart';

void showBecomeMentorSheet(BuildContext context) {
  final fullNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final whatsappCtrl = TextEditingController();
  final linkedinCtrl = TextEditingController();
  final jobTitleCtrl = TextEditingController(); 
  final topicsCtrl = TextEditingController();
  final bioCtrl = TextEditingController(); 
  final experienceCtrl = TextEditingController(); 
  final mentorCubit = context.read<MentorshipCubit>();

  String selectedLevel = 'Newcomers';
  int maxStudents = 5;
  bool isSubmitting = false;

  final levels = ['Newcomers', 'Level 1', 'Level 2', 'Senior'];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setSheetState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9, 
            padding: EdgeInsets.only(
              top: 25, left: 20, right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20, 
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF0F172A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[700], borderRadius: BorderRadius.circular(10)))),
                  const SizedBox(height: 20),

                  const Text('Become a Mentor', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 25),

                  _buildInputField('Full Name *', 'Your full name', fullNameCtrl),
                  _buildInputField('Phone Number *', '+20 1XX XXX XXXX', phoneCtrl, isPhone: true),
                  _buildInputField('Email *', 'your@email.com', emailCtrl),
                  _buildInputField('WhatsApp Link', 'wa.me/201XXXXXXXXX', whatsappCtrl),
                  _buildInputField('LinkedIn Profile', 'linkedin.com/in/username', linkedinCtrl),
                  _buildInputField('Job Title *', 'e.g. Software Engineer', jobTitleCtrl),
                  _buildInputField('Bio *', 'Tell students about yourself...', bioCtrl, maxLines: 3),

                  const Text('Mentoring Level *', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 2.5, crossAxisSpacing: 10, mainAxisSpacing: 10,
                    ),
                    itemCount: levels.length,
                    itemBuilder: (context, index) {
                      bool isSelected = selectedLevel == levels[index];
                      return GestureDetector(
                        onTap: () => setSheetState(() => selectedLevel = levels[index]),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF151E2E),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSelected ? const Color(0xFF8B5CF6) : Colors.transparent, width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              levels[index],
                              style: TextStyle(color: isSelected ? const Color(0xFF8B5CF6) : Colors.grey, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

           
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Max Students *', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 10),
                            Container(
                              height: 50, 
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(color: const Color(0xFF151E2E), borderRadius: BorderRadius.circular(12)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: maxStudents,
                                  isExpanded: true,
                                  dropdownColor: const Color(0xFF1E293B),
                                  style: const TextStyle(color: Colors.white),
                                  items: [1, 2, 3, 4, 5].map((int value) {
                                    return DropdownMenuItem<int>(value: value, child: Text(value.toString()));
                                  }).toList(),
                                  onChanged: (newValue) {
                                    if (newValue != null) setSheetState(() => maxStudents = newValue);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildInputField('Experience (years)', 'e.g. 3', experienceCtrl, isNumber: true, isPaddingBottomZero: true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildInputField('Expertise Topics', 'e.g. Graph Theory, DP, Sorting', topicsCtrl),
                  const SizedBox(height: 20),

                  InkWell(
                    onTap: isSubmitting ? null : () async {
                      if (fullNameCtrl.text.isEmpty || 
                          phoneCtrl.text.isEmpty || 
                          emailCtrl.text.isEmpty || 
                          jobTitleCtrl.text.isEmpty || 
                          bioCtrl.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill all required fields (*)'), backgroundColor: Colors.redAccent)
                        );
                        return;
                      }

                      setSheetState(() => isSubmitting = true);
                      
                     
                      
                      int exp = int.tryParse(experienceCtrl.text) ?? 0;

                      bool success = await mentorCubit.submitMentorApplication(
                        fullName: fullNameCtrl.text,
                        email: emailCtrl.text,
                        jobTitle: jobTitleCtrl.text,
                        phone: phoneCtrl.text,
                        whatsapp: whatsappCtrl.text,
                        linkedin: linkedinCtrl.text,
                        level: selectedLevel,
                        maxStudents: maxStudents,
                        experienceYears: exp, 
                        topics: topicsCtrl.text,
                        bio: bioCtrl.text,
                      );

                      setSheetState(() => isSubmitting = false);

                      if (sheetContext.mounted) {
                        if (success) {
                          Navigator.pop(sheetContext); 
                          context.read<MentorshipCubit>().fetchMentorDashboardData();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Application Submitted Successfully! 🎉'), backgroundColor: Colors.green));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to submit application. Try again.'), backgroundColor: Colors.redAccent));
                        }
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(colors: [Color(0xFF06B6D4), Color(0xFF8B5CF6)]),
                      ),
                      child: Center(
                        child: isSubmitting 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Submit Application', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        }
      );
    },
  );
}


Widget _buildInputField(String label, String hint, TextEditingController controller, {bool isPhone = false, bool isNumber = false, int maxLines = 1, bool isPaddingBottomZero = false}) {
  return Padding(
    padding: EdgeInsets.only(bottom: isPaddingBottomZero ? 0 : 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 10),
        Container(
          height: maxLines == 1 ? 50 : null, 
          decoration: BoxDecoration(
            color: const Color(0xFF151E2E), 
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : (isPhone ? TextInputType.phone : TextInputType.text),
            maxLines: maxLines,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[600]),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: maxLines == 1 ? 13 : 15),
            ),
          ),
        ),
      ],
    ),
  );
}