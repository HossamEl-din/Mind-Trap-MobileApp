class DashboardState {
  final bool isLoading;
  final String firstName;
  final String skillLevel;
  final int problemsSolved;
  final int contestsParticipated;
  final int globalRanking;
  final int dayStreak;
  final List<dynamic> learningPaths;
  final List<dynamic> upcomingContests;
  final String error;

  const DashboardState({
    this.isLoading = false,
    this.firstName = '...',
    this.skillLevel = '...',
    this.problemsSolved = 0,
    this.contestsParticipated = 0,
    this.globalRanking = 0,
    this.dayStreak = 0,
    this.learningPaths = const [],
    this.upcomingContests = const [],
    this.error = '',
  });

  DashboardState copyWith({
    bool? isLoading,
    String? firstName,
    String? skillLevel,
    int? problemsSolved,
    int? contestsParticipated,
    int? globalRanking,
    int? dayStreak,
    List<dynamic>? learningPaths,
    List<dynamic>? upcomingContests,
    String? error,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      firstName: firstName ?? this.firstName,
      skillLevel: skillLevel ?? this.skillLevel,
      problemsSolved: problemsSolved ?? this.problemsSolved,
      contestsParticipated: contestsParticipated ?? this.contestsParticipated,
      globalRanking: globalRanking ?? this.globalRanking,
      dayStreak: dayStreak ?? this.dayStreak,
      learningPaths: learningPaths ?? this.learningPaths,
      upcomingContests: upcomingContests ?? this.upcomingContests,
      error: error ?? this.error,
    );
  }
}