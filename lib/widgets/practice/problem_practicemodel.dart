class Problem {
  final int id;
  final String name;
  final List<String> tags;
  final String level;
  final bool isSolved;
  final bool isAttempted;
  final String platform;

  Problem({required this.id, required this.name, required this.tags, required this.level, this.isSolved = false, this.isAttempted = false, required this.platform});
}