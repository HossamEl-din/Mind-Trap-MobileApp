import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:grad/widgets/Contest/contest_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'contest_event.dart';
import 'contest_state.dart';

class ContestBloc extends Bloc<ContestEvent, ContestState> {
  Timer? _timer;
  
  
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://hossammourad-001-site1.ltempurl.com'));

  ContestBloc() : super(ContestInitial()) {
    on<LoadContests>(_onLoadContests);
    on<FilterByPlatform>(_onFilterByPlatform);
    on<TickTimer>(_onTickTimer);
    on<RegisterForContest>(_onRegister);
    on<RemindForContest>(_onRemind);
  }


  Future<void> _onLoadContests(LoadContests event, Emitter<ContestState> emit) async {
    emit(ContestLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await _dio.get(
        '/api/Contests',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      List<Contest> loadedContests = [];
      if (response.data != null && response.data is List) {
        loadedContests = (response.data as List).map((e) => Contest.fromJson(e)).toList();
      }

      _startTimer();
      emit(ContestLoaded(
        allContests: loadedContests,
        filteredContests: loadedContests,
        now: DateTime.now(),
      ));
    } catch (e) {
      print(" Error fetching contests: $e");
      emit(ContestError("Failed to load contests. Please try again."));
    }
  }

  void _onFilterByPlatform(FilterByPlatform event, Emitter<ContestState> emit) {
    if (state is ContestLoaded) {
      final s = state as ContestLoaded;
      final filtered = event.platform == null
          ? s.allContests
          : s.allContests.where((c) => c.platform == event.platform).toList();
          
      emit(s.copyWith(
        filteredContests: filtered,
        selectedPlatform: event.platform,
        clearPlatform: event.platform == null,
      ));
    }
  }

  void _onTickTimer(TickTimer event, Emitter<ContestState> emit) {
    if (state is ContestLoaded) {
      emit((state as ContestLoaded).copyWith(now: DateTime.now()));
    }
  }

  void _onRegister(RegisterForContest event, Emitter<ContestState> emit) {
    if (state is ContestLoaded) {
      final s = state as ContestLoaded;
      final newSet = Set<String>.from(s.registeredIds);
      if (newSet.contains(event.contestId)) {
        newSet.remove(event.contestId);
      } else {
        newSet.add(event.contestId);
      }
      emit(s.copyWith(registeredIds: newSet));
    }
  }

 Future<void> _onRemind(RemindForContest event, Emitter<ContestState> emit) async {
    if (state is ContestLoaded) {
      final s = state as ContestLoaded;
      
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token') ?? '';

       
        final response = await _dio.post(
          '/api/Contests/${event.contestId}/remind',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

   
        if (response.statusCode == 200) {
          final newSet = Set<String>.from(s.remindedIds);
          
        
          if (newSet.contains(event.contestId)) {
            newSet.remove(event.contestId);
          } else {
            newSet.add(event.contestId);
          }
          
         
          emit(s.copyWith(remindedIds: newSet));
        }
      } catch (e) {
        print(" Error setting reminder: $e");
        
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(TickTimer());
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}