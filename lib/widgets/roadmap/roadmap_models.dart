class LearningLevel {
  final String levelName;
  final List<TopicSummary> topics;

  LearningLevel({required this.levelName, required this.topics});

  factory LearningLevel.fromJson(Map<String, dynamic> json) {
    return LearningLevel(
      levelName: json['levelName'] ?? 'Unknown Level',
      topics: (json['topics'] as List?)
              ?.map((topic) => TopicSummary.fromJson(topic))
              .toList() ?? [],
    );
  }
}

class TopicSummary {
  final int id;
  final String name;
  final int totalProblems;
  final int solvedProblems;
  final double progressPercentage;

  TopicSummary({
    required this.id,
    required this.name,
    required this.totalProblems,
    required this.solvedProblems,
    required this.progressPercentage,
  });

  factory TopicSummary.fromJson(Map<String, dynamic> json) {
    return TopicSummary(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Topic',
      totalProblems: json['totalProblems'] ?? 0,
      solvedProblems: json['solvedProblems'] ?? 0,
      progressPercentage: (json['progressPercentage'] ?? 0).toDouble(),
    );
  }
}


class TopicDetails {
  final int id;
  final String name;
  final String level;
  final List<ResourceModel> resources;
  final List<ProblemModel> problems;

  TopicDetails({
    required this.id,
    required this.name,
    required this.level,
    required this.resources,
    required this.problems,
  });

  factory TopicDetails.fromJson(Map<String, dynamic> json) {
    return TopicDetails(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      level: json['level'] ?? '',
      resources: (json['resources'] as List?)
              ?.map((r) => ResourceModel.fromJson(r))
              .toList() ?? [],
      problems: (json['problems'] as List?)
              ?.map((p) => ProblemModel.fromJson(p))
              .toList() ?? [],
    );
  }
}

class ResourceModel {
  final int id;
  final String title;
  final String type; 
  final String language;
  final String url;

  ResourceModel({
    required this.id,
    required this.title,
    required this.type,
    required this.language,
    required this.url,
  });

  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled Resource',
      type: json['type'] ?? 'Unknown',
      language: json['language'] ?? 'EN',
      url: json['url'] ?? '',
    );
  }
}

class ProblemModel {
  final int id;
  final String title;
  final String difficulty;
  final String source;
  final String? originalUrl; 
  final String status; 
  final String successRate;

  ProblemModel({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.source,
    this.originalUrl,
    required this.status,
    required this.successRate,
  });

  factory ProblemModel.fromJson(Map<String, dynamic> json) {
    return ProblemModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown Problem',
      difficulty: json['difficulty'] ?? 'Easy',
      source: json['source'] ?? 'Codeforces',
      originalUrl: json['originalUrl'],
      status: json['status'] ?? 'Unsolved',
      successRate: json['successRate'] ?? '0%',
    );
  }
}