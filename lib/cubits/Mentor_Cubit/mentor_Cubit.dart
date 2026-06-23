import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:grad/cubits/Mentor_Cubit/mentor_State.dart';
import 'package:grad/widgets/Mentor/mintor_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MentorshipCubit extends Cubit<MentorshipState> {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://hossammourad-001-site1.ltempurl.com'));

  MentorshipCubit() : super(MentorshipState());


  Future<void> fetchInitialData() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      
      final options = Options(headers: {'Authorization': 'Bearer $token'});

     
      final statsResponse = await _dio.get('/api/Mentorship/stats', options: options);
     
      final mentorsResponse = await _dio.get('/api/Mentorship/mentors', options: options);
      
      
      final myMentorsRes = await _dio.get('/api/Mentorship/my-mentors', options: options);

      List<Mentor> loadedMentors = [];
      if (mentorsResponse.data != null && mentorsResponse.data is List) {
        loadedMentors = (mentorsResponse.data as List).map((e) => Mentor.fromJson(e)).toList();
      }

      emit(state.copyWith(
        isLoading: false,
        stats: statsResponse.data,
        mentors: loadedMentors,
        myConnectedMentors: myMentorsRes.data is List ? myMentorsRes.data : [],
      ));

    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Failed to load mentorship data.'));
    }
  }

  
 void changeLevelFilter(String level) {
    emit(state.copyWith(selectedLevel: level));
  }

  
  void changeAvailabilityFilter(String availability) {
    emit(state.copyWith(selectedAvailability: availability));
  }


Future<bool> submitMentorApplication({
    required String fullName, 
    required String email,    
    required String jobTitle, 
    required String phone, 
    required String whatsapp, 
    required String linkedin,
    required String level, 
    required int maxStudents, 
    required String topics,
    required int experienceYears,
    required String bio,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

     
      final payload = {
        "fullName": fullName,
        "jobTitle": jobTitle,
        "phoneNumber": phone,
        "email": email,
        "whatsappLink": whatsapp,
        "linkedinProfile": linkedin,
        "level": level,
        "maxStudents": maxStudents,
        "experienceYears": experienceYears, 
        "expertise": topics,  
        "bio": bio
      };

      final response = await _dio.post(
        '/api/Mentorship/apply', 
        data: payload,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      print(" السيرفر رفض الطلب (السبب): ${e.response?.data}");
      return false;
    } catch (e) {
      print(" خطأ عام: $e");
      return false;
    }
  }

 Future<String> requestMentor(int mentorId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await _dio.post(
        '/api/Mentorship/request/$mentorId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return "success";
      }
      return "failed";
    } on DioException catch (e) {
     
      if (e.response?.statusCode == 400) {
        if (e.response?.data != null && e.response?.data is Map) {
      
          return e.response?.data['message'] ?? "Invalid request.";
        }
        return "Bad Request";
      }
      return "Failed to send request. Check your connection.";
    } catch (e) {
      return "An unexpected error occurred.";
    }
  }
  void changeTab(int index) {
     emit(state.copyWith(activeTab: index));
    if (index == 1 && state.myStudents.isEmpty && state.pendingRequests.isEmpty) {
      fetchMentorDashboardData();
    }
  }
  Future<void> fetchMentorDashboardData() async {
    emit(state.copyWith(isLoading: true)); 
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final options = Options(headers: {'Authorization': 'Bearer $token'});

    
      final pendingRes = await _dio.get('/api/Mentorship/requests/pending', options: options);
      
      final studentsRes = await _dio.get('/api/Mentorship/my-students', options: options);

      emit(state.copyWith(
        isLoading: false,
        pendingRequests: pendingRes.data is List ? pendingRes.data : [],
        myStudents: studentsRes.data is List ? studentsRes.data : [],
      ));
    } catch (e) {
      print(" Error fetching dashboard data: $e");
      emit(state.copyWith(isLoading: false, errorMessage: "Failed to load dashboard"));
    }
  }
  Future<bool> endMentorshipConnection(int connectionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      
      final response = await _dio.put(
        '/api/Mentorship/requests/$connectionId/end',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        
        final updatedStudents = List<dynamic>.from(state.myStudents)
          ..removeWhere((student) => student['connectionId'] == connectionId || student['id'] == connectionId);
    
        emit(state.copyWith(myStudents: updatedStudents));

    
        fetchMentorDashboardData(); 
        return true;
      }
      return false;
    } catch (e) {
      print("🚨 Error ending connection: $e");
      return false;
    }
  }

  
 Future<bool> acceptRequest(int connectionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await _dio.put(
        '/api/Mentorship/requests/$connectionId/accept',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final updatedPending = List<dynamic>.from(state.pendingRequests)
          ..removeWhere((req) => req['connectionId'] == connectionId);
        
        emit(state.copyWith(pendingRequests: updatedPending));

      
        fetchInitialData(); 
        return true;
      }
      return false;
    } catch (e) {
      print(" Error accepting request: $e");
      return false;
    }
  }


 Future<bool> rejectRequest(int connectionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await _dio.put(
        '/api/Mentorship/requests/$connectionId/reject',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
      
        final updatedPending = List<dynamic>.from(state.pendingRequests)
          ..removeWhere((req) => req['connectionId'] == connectionId);
        
     
        emit(state.copyWith(pendingRequests: updatedPending));

        fetchInitialData(); 
        return true;
      }
      return false;
    } catch (e) {
      print(" Error rejecting request: $e");
      return false;
    }
  }

 
  Future<String> rateMentor(int mentorId, int score) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      
      final response = await _dio.post(
        '/api/Mentorship/mentors/$mentorId/rate',
        data: {"score": score},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return "success";
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return e.response?.data['message'] ?? "Invalid rating request.";
      }
      return "failed";
    } catch (e) {
      return "failed";
    }
  }
  void searchMentors(String query) {
    emit(state.copyWith(searchQuery: query));
  }
  
  void toggleSearch() {
    bool newSearchState = !state.isSearching;
    emit(state.copyWith(
      isSearching: newSearchState,
      searchQuery: newSearchState ? state.searchQuery : '', 
    ));
  }
}