import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:grad/widgets/roadmap/roadmap_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'roadmap_State.dart';
// 👇 اتأكد إن مسار الموديلز ده صح عندك


class RoadmapCubit extends Cubit<RoadmapState> {
  RoadmapCubit() : super(RoadmapInitial());

  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://hossammourad-001-site1.ltempurl.com'));
  List<LearningLevel> _allLevels = []; 
  int _liveStreak = 0; // هنحتفظ بالرقم هنا عشان لما نغير الفلتر

  Future<void> loadRoadmap() async {
    emit(RoadmapLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final options = Options(headers: {'Authorization': 'Bearer $token'});
      
      // 👈 السحر هنا: بنطلب الرود ماب والإحصائيات في نفس اللحظة (زي الداش بورد)
      final responses = await Future.wait([
        _dio.get('/api/LearningPath', options: options),
        _dio.get('/api/Dashboard/stats', options: options),
      ]);

      // الداتا اللي راجعة من أول ريكويست (الرود ماب)
      final List dynamicList = responses[0].data ?? [];
      
      // الداتا اللي راجعة من تاني ريكويست (الإحصائيات)
      final statsData = responses[1].data ?? {};
      
      // 👈 سحبنا الـ Streak الحقيقي من السيرفر مباشرة!
      _liveStreak = statsData['dayStreak'] ?? 0; 
        int globalSolved = statsData['problemsSolved'] ?? 0;

      _allLevels = dynamicList.map((level) => LearningLevel.fromJson(level)).toList();
      String defaultFilter = _allLevels.isNotEmpty ? _allLevels.first.levelName : "Newcomers";

      emit(RoadmapSuccess(
        selectedFilter: defaultFilter,
        levels: _allLevels, 
        dayStreak: _liveStreak, // 👈 باصيناه للـ UI
        totalProblemsSolved: globalSolved, // 👈 باصيناه للـ UI
      ));

    } catch (e) {
      print("Roadmap Error: $e");
      emit(RoadmapError("Failed to load roadmap data."));
    }
  }

  void changeFilter(String newFilter) {
    if (state is RoadmapSuccess) {
      emit(RoadmapSuccess(
        selectedFilter: newFilter,
        levels: _allLevels, 
        dayStreak: _liveStreak, // 👈 عشان يفضل موجود لو اليوزر غير الفلتر
        totalProblemsSolved: (state as RoadmapSuccess).totalProblemsSolved, // 👈 عشان يفضل موجود لو اليوزر غير الفلتر
      ));
    }
  }
}