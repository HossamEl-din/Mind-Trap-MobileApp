import 'package:grad/widgets/practice/problem_practicemodel.dart';
abstract class PracticeState {}

class PracticeInitial extends PracticeState {}

class PracticeLoading extends PracticeState {}

class PracticeSuccess extends PracticeState {
  final List<Problem> filteredProblems;
  final String selectedStatus;
  final String selectedLevel;
  final String selectedPlatform;
  final String searchQuery;

  PracticeSuccess({
    required this.filteredProblems,
    required this.selectedStatus,
    required this.selectedLevel,
    required this.selectedPlatform,
    this.searchQuery = "",
  });
}
class PracticeError extends PracticeState {
  final String message;
  PracticeError(this.message);
}