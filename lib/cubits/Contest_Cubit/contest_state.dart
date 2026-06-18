import 'package:grad/widgets/Contest/contest_model.dart';


abstract class ContestState {}

class ContestInitial extends ContestState {}

class ContestLoading extends ContestState {}

class ContestLoaded extends ContestState {
  final List<Contest> allContests;
  final List<Contest> filteredContests;
  final ContestPlatform? selectedPlatform;
  final Set<String> registeredIds;
  final Set<String> remindedIds;
  final DateTime now;

  ContestLoaded({
    required this.allContests,
    required this.filteredContests,
    required this.now,
    this.selectedPlatform,
    this.registeredIds = const {},
    this.remindedIds = const {},
  });

  ContestLoaded copyWith({
    List<Contest>? allContests,
    List<Contest>? filteredContests,
    ContestPlatform? selectedPlatform,
    bool clearPlatform = false,
    Set<String>? registeredIds,
    Set<String>? remindedIds,
    DateTime? now,
  }) {
    return ContestLoaded(
      allContests: allContests ?? this.allContests,
      filteredContests: filteredContests ?? this.filteredContests,
      selectedPlatform:
          clearPlatform ? null : (selectedPlatform ?? this.selectedPlatform),
      registeredIds: registeredIds ?? this.registeredIds,
      remindedIds: remindedIds ?? this.remindedIds,
      now: now ?? this.now,
    );
  }
}

class ContestError extends ContestState {
  final String message;
  ContestError(this.message);
}
