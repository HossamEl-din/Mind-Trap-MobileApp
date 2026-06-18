import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/Mentor_Cubit/mentor_Cubit.dart';
import 'package:grad/widgets/Mentor/mintor_model.dart';

Widget buildMentorCard(BuildContext context, Mentor mentor) {
  // 👈 1. قرينا الحالة مباشرة من الموديل الذكي بتاعنا
  bool isFull = mentor.availability.toLowerCase() == 'full';
  
  // حساب الـ Capacity للـ Progress Bar
  double progress = mentor.maxCapacity > 0 ? (mentor.currentCapacity / mentor.maxCapacity) : 0.0;
  if (progress > 1.0) progress = 1.0; 

  return Container(
    margin: const EdgeInsets.only(bottom: 20),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFF151E2E), 
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withOpacity(0.05)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ==========================================
        // 1. الـ Header (الصورة والاسم والتقييم)
        // ==========================================
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 55, height: 55,
              decoration: BoxDecoration(
                color: mentor.avatarColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  mentor.initials,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mentor.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  // النجوم والتقييم
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < mentor.rating.floor() ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                      const SizedBox(width: 5),
                       Text(
                        '${mentor.rating.toStringAsFixed(1)} (${mentor.reviews} reviews)', // 👈 ضفنا toStringAsFixed(1)
                          style: const TextStyle(color: Colors.grey, fontSize: 12)
                          ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // بادج التوثيق والمستوى
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.greenAccent),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.greenAccent, size: 12),
                            SizedBox(width: 4),
                            Text('Verified', style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.menu_book, color: Colors.grey, size: 16),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),

        // ==========================================
        // 2. الـ Bio والمسمى الوظيفي
        // ==========================================
        if (mentor.title.isNotEmpty)
          Text(mentor.title, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
        if (mentor.title.isNotEmpty && mentor.description.isNotEmpty)
          const SizedBox(height: 4),
        if (mentor.description.isNotEmpty)
          Text(
            mentor.description,
            style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
            maxLines: 3, overflow: TextOverflow.ellipsis,
          ),
        const SizedBox(height: 15),

 
            Wrap(
              spacing: 15, // المسافة الأفقية
              runSpacing: 10, // المسافة الرأسية لو نزل سطر جديد
              children: [
                _buildStatItem('${mentor.students} Students'),
                _buildStatItem('${mentor.experience} yrs Experience'),
                _buildStatItem('${mentor.rating.toStringAsFixed(1)} ⭐ Rating'), // 👈 قربنا الرقم هنا كمان
              ],
            ),
        const SizedBox(height: 15),

        // ==========================================
        // 4. التخصصات (Tags)
        // ==========================================
        if (mentor.topics.isNotEmpty)
          Wrap(
            spacing: 8, runSpacing: 8,
            children: mentor.topics.map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(20)
              ),
              child: Text(t, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            )).toList(),
          ),
        if (mentor.topics.isNotEmpty) const SizedBox(height: 20),

      
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.people_alt_outlined, color: Colors.grey, size: 16),
                SizedBox(width: 6),
                Text('Capacity', style: TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
            Text(
              '${mentor.currentCapacity} / ${mentor.maxCapacity} slots',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: isFull 
                        ? [Colors.redAccent, Colors.red] 
                        : [const Color(0xFF06B6D4), const Color(0xFF8B5CF6)], 
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        isFull 
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
            ),
            child: const Center(
              child: Text(
                'Currently Full', 
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 14)
              ),
            ),
          )
        : StatefulBuilder(
            builder: (context, setState) {
              bool isSubmitting = false;

              return InkWell(
                onTap: isSubmitting ? null : () async {
                  setState(() => isSubmitting = true);
                  
                  String result = await context.read<MentorshipCubit>().requestMentor(mentor.id);
                  
                  setState(() => isSubmitting = false);
                  
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result == "success" ? "Request sent successfully! 🎉" : result),
                        backgroundColor: result == "success" ? Colors.green : Colors.redAccent,
                      )
                    );
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(colors: [Color(0xFF06B6D4), Color(0xFF8B5CF6)]),
                  ),
                  child: Center(
                    child: isSubmitting 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send, color: Colors.white, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Request Mentor',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)
                            ),
                          ],
                        ),
                  ),
                ),
              );
            }
          )
      ],
    ),
  );
}

Widget _buildStatItem(String text) {
  return Row(
    children: [
      Container(
        width: 6, height: 6, 
        decoration: const BoxDecoration(color: Color(0xFF06B6D4), shape: BoxShape.circle)
      ),
      const SizedBox(width: 6),
      Text(text, style: const TextStyle(color: Colors.white70, fontSize: 11)),
    ],
  );
}