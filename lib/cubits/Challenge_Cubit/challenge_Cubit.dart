import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'challenge_State.dart';

class ChallengeArenaCubit extends Cubit<ChallengeArenaState> {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://hossammourad-001-site1.ltempurl.com',
  connectTimeout: const Duration(seconds: 30), 
  receiveTimeout: const Duration(seconds: 30),
  ));

  ChallengeArenaCubit() : super(ChallengeArenaInitial());

  
  void init() async {
    emit(ChallengeArenaLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      // طلب البيانات بالدور (واحد ورا التاني عشان السيرفر ميقفلش الاتصال)
      final activeResponse = await _dio.get('/api/Challenges/active', options: options);
      final pendingResponse = await _dio.get('/api/Challenges/pending', options: options);
      final completedResponse = await _dio.get('/api/Challenges/completed', options: options);
      final leaderboardResponse = await _dio.get('/api/Challenges/leaderboard', options: options);
      final statsResponse = await _dio.get('/api/Challenges/stats', options: options);

      if (!isClosed) {
        emit(ChallengeArenaSuccess(
          activeTab: 'Active Challenge',
          leaderboardFilter: 'This Week',
          activeChallenges: activeResponse.data ?? [],
          pendingInvites: pendingResponse.data ?? [],
          completedChallenges: completedResponse.data ?? [],
          leaderboard: leaderboardResponse.data ?? [],
          stats: statsResponse.data ?? {},
        ));
      }
    } catch (e) {
      print("Challenge Arena Error: $e");
      if (!isClosed) {
        emit(ChallengeArenaError("فشل في تحميل بيانات ساحة التحديات"));
      }
    }
  }
  
  void changeTab(String newTab) {
    if (state is ChallengeArenaSuccess) {
      final s = state as ChallengeArenaSuccess;
      emit(ChallengeArenaSuccess(
        activeTab: newTab,
        leaderboardFilter: s.leaderboardFilter,
        activeChallenges: s.activeChallenges,
        pendingInvites: s.pendingInvites,
        completedChallenges: s.completedChallenges,
        leaderboard: s.leaderboard,
        stats: s.stats,
      ));
    }
  }

 
  void changeLeaderboardFilter(String newFilter) {
    if (state is ChallengeArenaSuccess) {
      final s = state as ChallengeArenaSuccess;
      emit(ChallengeArenaSuccess(
        activeTab: s.activeTab,
        leaderboardFilter: newFilter,
        activeChallenges: s.activeChallenges,
        pendingInvites: s.pendingInvites,
        completedChallenges: s.completedChallenges,
        leaderboard: s.leaderboard,
        stats: s.stats,
      ));
    }
  }

 
  Future<String?> createBattle({
    required String opponentUsername,
    required String topicTag,
    required String difficulty,
    required int durationMinutes,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final response = await _dio.post(
        '/api/Challenges/create',
        data: {
          "title": "1v1 Battle - $topicTag",
          "difficulty": difficulty,
          "topicTag": topicTag,
          "durationMinutes": durationMinutes,
          "opponentUsername": opponentUsername
        },
        options: options,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
       
        refreshPendingInvites();
        return null;
      }
      return "Unexpected error occurred";
    } on DioException catch (e) {
      
      if (e.response != null && e.response?.data != null) {
        if (e.response?.data is Map && e.response?.data['message'] != null) {
          return e.response?.data['message'];
        }
      }
      return "Failed to send invite: ${e.message}";
    } catch (e) {
      return "An error occurred: $e";
    }
  }
 
  // دالة قبول التحدي
  Future<String?> acceptChallenge(int challengeId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final response = await _dio.post('/api/Challenges/$challengeId/accept', options: options);

      // أي كود من 200 لـ 299 بيعتبر نجاح في الـ APIs
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        refreshChallengesLists();
        return null; // معناه إن مفيش مشاكل
      }
      return "Unexpected response from server";
    } on DioException catch (e) {
      print("Accept Challenge Dio Error: ${e.response?.statusCode} - ${e.response?.data}");
      if (e.response?.data != null && e.response?.data is Map) {
         return e.response?.data['message'] ?? "فشل في قبول التحدي";
      }
      return "خطأ في الاتصال بالسيرفر";
    } catch (e) {
      print("Accept Challenge Error: $e");
      return "حدث خطأ غير متوقع";
    }
  }

 
  Future<void> cancelChallenge(int challengeId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final response = await _dio.post('/api/Challenges/$challengeId/cancel', options: options);

      if (response.statusCode == 200 || response.statusCode == 201) {
       refreshChallengesLists();
      }
    } catch (e) {
      print("Cancel Challenge Error: $e");
    }
  }
  // دالة لتحديث قائمة الـ Pending فقط لتخفيف الضغط على السيرفر
  Future<void> refreshPendingInvites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final response = await _dio.get('/api/Challenges/pending', options: options);

      if (state is ChallengeArenaSuccess) {
        final currentState = state as ChallengeArenaSuccess;
        emit(ChallengeArenaSuccess(
          activeTab: currentState.activeTab,
          leaderboardFilter: currentState.leaderboardFilter,
          activeChallenges: currentState.activeChallenges,
          pendingInvites: response.data ?? [], 
          completedChallenges: currentState.completedChallenges,
          leaderboard: currentState.leaderboard,
          stats: currentState.stats,
        ));
      }
    } catch (e) {
      print("Refresh Pending Error: $e");
    }
  }
  // دالة لتحديث قوائم التحديات فقط بدون الليدربورد والإحصائيات
  Future<void> refreshChallengesLists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      // بنجيب الـ 3 قوائم دول بس (عشان خفاف جداً على السيرفر)
      final responses = await Future.wait([
        _dio.get('/api/Challenges/active', options: options),
        _dio.get('/api/Challenges/pending', options: options),
        _dio.get('/api/Challenges/completed', options: options),
      ]);

      if (state is ChallengeArenaSuccess) {
        final currentState = state as ChallengeArenaSuccess;
        emit(ChallengeArenaSuccess(
          activeTab: currentState.activeTab,
          leaderboardFilter: currentState.leaderboardFilter,
          activeChallenges: responses[0].data ?? [],      // 👈 تم التحديث
          pendingInvites: responses[1].data ?? [],        // 👈 تم التحديث
          completedChallenges: responses[2].data ?? [],   // 👈 تم التحديث
          leaderboard: currentState.leaderboard,          // بنسيبه زي ما هو من الميموري
          stats: currentState.stats,                      // بنسيبه زي ما هو من الميموري
        ));
      }
    } catch (e) {
      print("Refresh Challenges Error: $e");
    }
  }
}