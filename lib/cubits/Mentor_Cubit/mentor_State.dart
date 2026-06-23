import 'package:grad/widgets/Mentor/mintor_model.dart';

class MentorshipState {
  final bool isLoading;
  final String? errorMessage;
  final List<Mentor> mentors;
  final Map<String, dynamic>? stats;
  final int activeTab;
  final List<dynamic> pendingRequests; 
  final List<dynamic> myStudents;
  final List<dynamic> myConnectedMentors;
  final String selectedLevel;
  final String selectedAvailability;
  final String searchQuery;
  final bool isSearching;
  MentorshipState({
    this.isLoading = false,
    this.errorMessage,
    this.mentors = const [],
    this.stats,
    this.activeTab = 0,
    this.pendingRequests = const [], 
    this.myStudents = const [],      
    this.myConnectedMentors = const [],
    this.selectedLevel = 'All Levels', 
    this.selectedAvailability = 'All', 
    this.searchQuery = '', 
    this.isSearching = false, 
  });

  MentorshipState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Mentor>? mentors,
    Map<String, dynamic>? stats,
    int? activeTab,
    List<dynamic>? pendingRequests, 
    List<dynamic>? myStudents,      
    List<dynamic>? myConnectedMentors,
    String? selectedLevel,
    String? selectedAvailability,
    String? searchQuery,
    bool? isSearching,
  }) {
    return MentorshipState(
      isLoading: isLoading ?? this.isLoading,
 
      errorMessage: errorMessage, 
      mentors: mentors ?? this.mentors,
      stats: stats ?? this.stats,
      activeTab: activeTab ?? this.activeTab,
      pendingRequests: pendingRequests ?? this.pendingRequests, 
      myStudents: myStudents ?? this.myStudents,                
      myConnectedMentors: myConnectedMentors ?? this.myConnectedMentors,
      isSearching: isSearching ?? this.isSearching,
      
     
      selectedLevel: selectedLevel ?? this.selectedLevel,
      selectedAvailability: selectedAvailability ?? this.selectedAvailability,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}