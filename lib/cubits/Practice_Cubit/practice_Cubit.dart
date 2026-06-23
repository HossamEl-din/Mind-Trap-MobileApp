import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grad/widgets/practice/problem_practicemodel.dart';
import 'practice_State.dart';

class PracticeCubit extends Cubit<PracticeState> {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://hossammourad-001-site1.ltempurl.com',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  PracticeCubit() : super(PracticeInitial());

  List<Problem> _allProblems = [];

 
  Future<void> init() async {
    emit(PracticeLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final List<String> localAttempted = prefs.getStringList('local_attempted') ?? [];
      final List<String> localSolved = prefs.getStringList('local_solved') ?? [];
      final problemsFuture = _dio.get(
        '/api/Problems',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final completedFuture = _dio.get(
        '/api/Challenges/completed',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final responses = await Future.wait([problemsFuture, completedFuture]);
      final problemsResponse = responses[0];
      final completedResponse = responses[1];

      if (problemsResponse.statusCode == 200 && completedResponse.statusCode == 200) {
        final List<dynamic> problemsData = problemsResponse.data ?? [];
        final List<dynamic> completedData = completedResponse.data ?? [];

        Set<int> attemptedIds = {};
        Set<int> solvedIds = {};

        for (var challenge in completedData) {
          print("🏆 التحدي المكتمل: $challenge");

          int? pId = challenge['problemId'] ?? challenge['problem']?['id'];
          
          if (pId != null) {
            attemptedIds.add(pId); 
            
            bool isWon = challenge['isWinner'] == true || 
                         challenge['status'] == 'Won' || 
                         challenge['status'] == 'Solved';
            
            if (isWon) {
              solvedIds.add(pId);
            }
          }
        }

        _allProblems = problemsData.map((json) {
          final int problemId = json['id'] ?? 0;
          
          bool isSolvedBefore = solvedIds.contains(problemId) || localSolved.contains(problemId.toString());
          bool isAttemptedBefore = attemptedIds.contains(problemId) || localAttempted.contains(problemId.toString());

          return Problem(
            id: problemId,
            name: json['title'] ?? "Unknown",
            tags: List<String>.from(json['tags'] ?? []),
            level: json['difficulty'] ?? "Easy",
            platform: json['source'] ?? "Unknown",
            isSolved: isSolvedBefore, 
            isAttempted: isAttemptedBefore && !isSolvedBefore, 
          );
        }).toList();

        _applyFilters("All", "All Levels", "All Platforms", "");
      }
    } catch (e) {
      print("Fetch & Merge Error: $e");
      if (!isClosed) emit(PracticeError("فشل في تحميل وتحديث قائمة المسائل"));
    }
  }


  void updateFilters({String? status, String? level, String? platform, String? query}) {
    if (state is PracticeSuccess) {
      final s = state as PracticeSuccess;
      _applyFilters(
        status ?? s.selectedStatus,
        level ?? s.selectedLevel,
        platform ?? s.selectedPlatform,
        query ?? s.searchQuery,
      );
    }
  }

  void _applyFilters(String status, String level, String platform, String query) {
    final filtered = _allProblems.where((p) {
      final bool statusMatch = status == "All" ||
          (status == "Solved" && p.isSolved) ||
          (status == "Attempted" && p.isAttempted) ||
          (status == "Unsolved" && !p.isSolved && !p.isAttempted);

      final bool levelMatch = level == "All Levels" || p.level == level;
      final bool platformMatch = platform == "All Platforms" || p.platform == platform;
      final bool searchMatch = p.name.toLowerCase().contains(query.toLowerCase());

      return statusMatch && levelMatch && platformMatch && searchMatch;
    }).toList();

    emit(PracticeSuccess(
      filteredProblems: filtered,
      selectedStatus: status,
      selectedLevel: level,
      selectedPlatform: platform,
      searchQuery: query,
    ));
  }
}