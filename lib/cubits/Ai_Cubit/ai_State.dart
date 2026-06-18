abstract class AIState {}

class AIInitial extends AIState {}

class AILoading extends AIState {}

class AISuccess extends AIState {
  final List<Map<String, String>> messages; 
  AISuccess({required this.messages});
}

class AIError extends AIState {
  final String message;
  AIError(this.message);
}