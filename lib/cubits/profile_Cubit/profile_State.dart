class ProfileState {
  final bool isLoading;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String bio;
  final Map<String, bool> settings;
  final String error;
  
  // 👈 الإحصائيات الجديدة
  final int problemsSolved;
  final int contestsParticipated;
  final String globalRank;

  // الاسم بالكامل
  String get fullName => "$firstName $lastName".trim();

  // 👈 دالة ذكية لاستخراج أول حرفين تلقائياً (مثال: Mansour Mohamed -> MM)
  String get initials {
    String f = firstName.trim();
    String l = lastName.trim();
    String firstLetter = f.isNotEmpty ? f[0].toUpperCase() : '';
    String lastLetter = l.isNotEmpty ? l[0].toUpperCase() : '';
    
    if (firstLetter.isEmpty && lastLetter.isEmpty) return 'U'; // لو مفيش اسم
    return '$firstLetter$lastLetter';
  }

  const ProfileState({
    this.isLoading = false,
    this.firstName = 'Loading...',
    this.lastName = '',
    this.username = '...',
    this.email = '...',
    this.bio = '...',
    this.problemsSolved = 0, // القيمة المبدئية
    this.contestsParticipated = 0,
    this.globalRank = '#--', // القيمة المبدئية للرانك
    this.settings = const {
      'Dark Mode': true,
      'Auto-save Code': true,
      'Show Hints': false,
      'Contest Reminder': true,
      'Challenge Notification': true,
      'Streak Reminder': false,
    },
    this.error = '',
  });

  ProfileState copyWith({
    bool? isLoading,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? bio,
    int? problemsSolved,
    int? contestsParticipated,
    String? globalRank,
    Map<String, bool>? settings,
    String? error,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      problemsSolved: problemsSolved ?? this.problemsSolved,
      contestsParticipated: contestsParticipated ?? this.contestsParticipated,
      globalRank: globalRank ?? this.globalRank,
      settings: settings ?? this.settings,
      error: error ?? this.error,
    );
  }
}