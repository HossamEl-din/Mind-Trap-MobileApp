import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:grad/cubits/Dashboard_Cubit/dashboard_State.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DashboardCubit extends Cubit<DashboardState> {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://hossammourad-001-site1.ltempurl.com'));

  DashboardCubit() : super(const DashboardState()) {
    fetchDashboardData();
  }

  // دالة مساعدة لتحويل نص التاريخ اللي جاي من الـ API إلى DateTime لسهولة المقارنة
  DateTime? _parseDateTime(String startTimeStr) {
    try {
      final parts = startTimeStr.split(' ');
      if (parts.length < 3) return null;
      
      final dateParts = parts[0].split('-');
      final timeParts = parts[1].split(':');
      final amPm = parts[2].toUpperCase();

      int year = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int day = int.parse(dateParts[2]);
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      if (amPm == 'PM' && hour != 12) hour += 12;
      if (amPm == 'AM' && hour == 12) hour = 0;

      return DateTime(year, month, day, hour, minute);
    } catch (_) {
      return null;
    }
  }

  Future<void> fetchDashboardData() async {
    emit(state.copyWith(isLoading: true, error: ''));
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final List<String> localSolved = prefs.getStringList('local_solved') ?? [];
      final int localSolvedCount = localSolved.length;

      // 👈 ضربنا الـ 3 ريكويستات، ولاحظ الريكويست التالت اتغير للمسار الجديد
      final responses = await Future.wait([
        _dio.get('/api/Dashboard/stats', options: options),
        _dio.get('/api/Dashboard/learning-path', options: options),
        _dio.get('/api/Contests', options: options), // مسار المسابقات اللي فيه الـ URL
      ]);

      final statsData = responses[0].data;
      final pathData = responses[1].data;
      final List dynamicContests = responses[2].data ?? [];

      final now = DateTime.now();

      // 1. الفلترة: نحتفظ باللي لسه ميعاده مجاش
      final List upcomingContests = dynamicContests.where((contest) {
        final targetDate = _parseDateTime(contest['startTime'] ?? '');
        return targetDate != null && targetDate.isAfter(now);
      }).toList();

      // 2. الترتيب: من الأقرب للأبعد زمنياً
      upcomingContests.sort((a, b) {
        final dateA = _parseDateTime(a['startTime'] ?? '');
        final dateB = _parseDateTime(b['startTime'] ?? '');
        if (dateA == null || dateB == null) return 0;
        return dateA.compareTo(dateB);
      });

      int solvedToDisplay = statsData['problemsSolved'] == 0 
          ? localSolvedCount 
          : statsData['problemsSolved'];

      emit(state.copyWith(
        isLoading: false,
        firstName: statsData['firstName'] ?? '',
        skillLevel: statsData['skillLevel'] ?? '',
        problemsSolved: solvedToDisplay,
        contestsParticipated: statsData['contestsParticipated'] ?? 0,
        globalRanking: statsData['globalRanking'] ?? 0,
        dayStreak: statsData['dayStreak'] ?? 0,
        learningPaths: pathData ?? [],
        upcomingContests: upcomingContests,
      ));

    } catch (e) {
      print("Dashboard Error: $e");
      emit(state.copyWith(isLoading: false, error: 'Failed to load dashboard data.'));
    }
  }
}