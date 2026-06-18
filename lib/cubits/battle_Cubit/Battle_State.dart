abstract class BattleState {}

class BattleInitial extends BattleState {}

class BattleLoading extends BattleState {}

class BattleLoaded extends BattleState {
  final String title;
  final String statement;
  final String difficulty;
  final String source;
  final List<String> tags;
  final String inputFormat;
  final String outputFormat;

  BattleLoaded({
    required this.title,
    required this.statement,
    required this.difficulty,
    required this.source,
    required this.tags,
    required this.inputFormat,
    required this.outputFormat,
    
  });
}

class BattleError extends BattleState {
  final String message;
  BattleError(this.message);
}


// حالة التحميل (لو مش موجودة ضيفها)
class CodeRunning extends BattleState {}

// حالة النجاح وبنشيل جواها النتيجة اللي راجعة
class RunCodeSuccess extends BattleState {
  final bool passed;
  final String input;
  final String expectedOutput;
  final String actualOutput;

  RunCodeSuccess({
    required this.passed,
    required this.input,
    required this.expectedOutput,
    required this.actualOutput,
  });
}
// حالة الخطأ
class RunCodeError extends BattleState {
  final String message;
  RunCodeError(this.message);
}
class SubmitLoading extends BattleState {}

class SubmitSuccess extends BattleState {
  final String message;
  SubmitSuccess(this.message);
}

class SubmitError extends BattleState {
  final String errorMessage;
  SubmitError(this.errorMessage);
}

class HintLoading extends BattleState {}

class HintLoaded extends BattleState {
  final String hint;
  final int level;
  HintLoaded(this.hint, this.level);
}

class HintError extends BattleState {
  final String message;
  HintError(this.message);
}

class AiHelpLoading extends BattleState {}

class AiHelpLoaded extends BattleState {
  final String llmCode;
  final String explanation;
  AiHelpLoaded(this.llmCode, this.explanation);
}

class AiHelpError extends BattleState {
  final String message;
  AiHelpError(this.message);
}

class ProblemExplainLoading extends BattleState {}

class ProblemExplainLoaded extends BattleState {
  final String explanation;
  final String algorithm;
  final String timeComplexity;
  final String spaceComplexity;

  ProblemExplainLoaded({
    required this.explanation,
    required this.algorithm,
    required this.timeComplexity,
    required this.spaceComplexity,
  });
}

class ProblemExplainError extends BattleState {
  final String message;
  ProblemExplainError(this.message);
}

class SubmitAnalysisLoaded extends BattleState {
  final bool isPassed; 
  final String originalMessage; 
  final int score;
  final String brief;
  final Map<String, dynamic> rubric;
  final String correctnessReason;
  final List<dynamic> strengths; 
  final List<dynamic> weaknesses; 
  final String errorReason;

  SubmitAnalysisLoaded({
    required this.isPassed,
    required this.originalMessage,
    required this.score,
    required this.brief,
    required this.rubric,
    required this.correctnessReason,
    required this.strengths,
    required this.weaknesses,
    required this.errorReason,
  });
}