abstract class ChallengeArenaState {}

class ChallengeArenaInitial extends ChallengeArenaState {}

class ChallengeArenaLoading extends ChallengeArenaState {}

class ChallengeArenaSuccess extends ChallengeArenaState {
  final String activeTab;
  final String leaderboardFilter;
  
  
  final List<dynamic> activeChallenges;
  final List<dynamic> pendingInvites;
  final List<dynamic> completedChallenges;
  final List<dynamic> leaderboard;
  final Map<String, dynamic> stats; 

  ChallengeArenaSuccess({
    required this.activeTab,
    required this.leaderboardFilter,
    required this.activeChallenges,
    required this.pendingInvites,
    required this.completedChallenges,
    required this.leaderboard,
    required this.stats,
  });
}

class ChallengeArenaError extends ChallengeArenaState {
  final String message;
  ChallengeArenaError(this.message);
}