import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:grad/cubits/profile_Cubit/profile_State.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProfileCubit extends Cubit<ProfileState> {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://hossammourad-001-site1.ltempurl.com'));

  ProfileCubit() : super(const ProfileState()) {
    
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    emit(state.copyWith(isLoading: true, error: ''));
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      
      
      final bool isNotifEnabled = prefs.getBool('Challenge Notification') ?? true;
      final currentSettings = Map<String, bool>.from(state.settings);
      currentSettings['Challenge Notification'] = isNotifEnabled;
      
      final List<String> localSolved = prefs.getStringList('local_solved') ?? [];
      final int solvedCount = localSolved.length;

      
      final response = await _dio.get(
        '/api/Users/settings',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final account = data['account'] ?? {};
        final String currentUsername = account['username'] ?? '';
        
        String userRank = '#--'; 

        
        try {
         
          final leaderboardResponse = await _dio.get(
            '/api/Challenges/leaderboard', 
            options: Options(headers: {'Authorization': 'Bearer $token'}),
          );

          if (leaderboardResponse.statusCode == 200) {
            final List leaderboard = leaderboardResponse.data;

         
            int index = leaderboard.indexWhere((user) => user['username'] == currentUsername);

            
            if (index != -1) {
              userRank = '#${index + 1}'; 
            }
          }
        } catch (e) {
          print("Error fetching leaderboard for rank: $e");
       
        }

        
        emit(state.copyWith(
          isLoading: false,
          firstName: account['firstName'] ?? '',
          lastName: account['lastName'] ?? '',
          username: currentUsername,
          email: account['email'] ?? '',
          bio: account['bio'] ?? 'No bio yet.',
          problemsSolved: solvedCount,
          globalRank: userRank, 
          settings: currentSettings,
        ));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to load profile.'));
    }
  }

  Future<bool> updateProfile({String? fullName, String? username, String? email, String? bio}) async {
    
    try {
      String newFirst = state.firstName;
      String newLast = state.lastName;

      if (fullName != null && fullName.isNotEmpty) {
        final parts = fullName.trim().split(' ');
        newFirst = parts.first; 
        newLast = parts.length > 1 ? parts.sublist(1).join(' ') : ''; 
      }

      final payload = {
        "firstName": newFirst,
        "lastName": newLast,
        "username": username ?? state.username,
        "email": email ?? state.email,
        "bio": bio ?? state.bio,
        "location": "string",
        "university": "string"
      };

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await _dio.put(
        '/api/Users/account',
        data: payload,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        emit(state.copyWith(
          firstName: newFirst,
          lastName: newLast,
          username: username ?? state.username,
          email: email ?? state.email,
          bio: bio ?? state.bio,
        ));
        return true; 
      }
      return false;
    } catch (e) {
      print("Update Error: $e");
      return false; 
    }
  }


  void toggleSetting(String key, bool value) async {
    final newSettings = Map<String, bool>.from(state.settings);
    newSettings[key] = value;
    emit(state.copyWith(settings: newSettings));
    
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
}