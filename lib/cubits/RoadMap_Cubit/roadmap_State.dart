import 'package:grad/widgets/roadmap/roadmap_models.dart';

abstract class RoadmapState {}

class RoadmapInitial extends RoadmapState {}

class RoadmapLoading extends RoadmapState {}

class RoadmapSuccess extends RoadmapState {
  final String selectedFilter;
  final List<LearningLevel> levels; 
  final int dayStreak;
  final int totalProblemsSolved;
  RoadmapSuccess({
    required this.selectedFilter, 
    required this.levels,
    required this.dayStreak,
    required this.totalProblemsSolved,
  });
}

class RoadmapError extends RoadmapState {
  final String message;
  RoadmapError(this.message);
}