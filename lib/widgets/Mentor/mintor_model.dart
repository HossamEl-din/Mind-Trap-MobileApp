import 'package:flutter/material.dart';

class Mentor {
  final int id;
  final int userId;
  final String name, title, initials, description;
  final double rating;
  final int reviews, students, experience, currentCapacity, maxCapacity;
  final Color avatarColor;
  final List<String> badges, topics;
  final String phone, email, whatsapp, linkedin, availability;

  Mentor({
    required this.id, required this.userId, required this.name, required this.title, 
    required this.initials, required this.description, required this.rating, 
    required this.reviews, required this.students, required this.experience, 
    required this.currentCapacity, required this.maxCapacity, required this.avatarColor, 
    required this.badges, required this.topics, required this.phone, 
    required this.email, required this.whatsapp, required this.linkedin, required this.availability
  });

  factory Mentor.fromJson(Map<String, dynamic> json) {
 
    final List<Color> colors = [
      const Color(0xFF818CF8), const Color(0xFFF59E0B), const Color(0xFF10B981), 
      const Color(0xFFEC4899), const Color(0xFF6366F1), const Color(0xFF14B8A6)
    ];
    int id = json['id'] ?? 0;
    Color bg = colors[id % colors.length];

    
    List<String> mentorBadges = [];
    if (json['mentoringLevel'] != null) mentorBadges.add(json['mentoringLevel']);

    
    int current = json['currentStudents'] ?? json['capacityCurrent'] ?? 0;
    int max = json['maxStudents'] ?? json['capacityMax'] ?? 5; 
    bool isReallyFull = current >= max;

   
    String backendStatus = json['status'] ?? json['availabilityStatus'] ?? 'Available';
    String finalStatus = backendStatus;
    
   
    if (backendStatus.toLowerCase() != 'requested' && backendStatus.toLowerCase() != 'active') {
      finalStatus = isReallyFull ? 'Full' : 'Available';
    }

    String mentorName = json['name'] ?? json['mentorName'] ?? json['fullName'] ?? 'Unknown';
    String computedInitials = json['initials'] ?? 
        (mentorName.length >= 2 ? mentorName.substring(0, 2).toUpperCase() : 'M');

    return Mentor(
      id: id,
      userId: json['userId'] ?? 0,
      name: mentorName,
      title: json['jobTitle'] ?? 'Mentor',
      initials: computedInitials,
      description: json['bio'] ?? 'No description available.',
      rating: (json['rating'] ?? 0).toDouble(),
      reviews: json['reviewCount'] ?? 0,
      students: json['studentsHelped'] ?? current, 
      experience: json['experienceYears'] ?? 0,
      maxCapacity: max,
      currentCapacity: current,
      avatarColor: bg,
      badges: mentorBadges,
      topics: List<String>.from(json['expertiseTags'] ?? []),
      phone: json['phoneNumber'] ?? json['phone'] ?? '',
      email: json['email'] ?? '',
      whatsapp: json['whatsAppLink'] ?? '',
      linkedin: json['linkedInProfile'] ?? '',
      availability: finalStatus, 
    );
  }
}