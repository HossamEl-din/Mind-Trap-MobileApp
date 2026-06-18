import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:grad/cubits/profile_Cubit/profile_State.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProfileCubit extends Cubit<ProfileState> {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://hossammourad-001-site1.ltempurl.com'));

  ProfileCubit() : super(const ProfileState()) {
    // أول ما الكيوبت يشتغل، هيسحب الداتا من السيرفر فوراً
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    emit(state.copyWith(isLoading: true, error: ''));
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      
      // 👈 قراءة حالة زرار الإشعارات المحفوظة (الافتراضي true)
      final bool isNotifEnabled = prefs.getBool('Challenge Notification') ?? true;
      final currentSettings = Map<String, bool>.from(state.settings);
      currentSettings['Challenge Notification'] = isNotifEnabled;
      // جلب عدد المسائل اللي اتحلت محلياً
      final List<String> localSolved = prefs.getStringList('local_solved') ?? [];
      final int solvedCount = localSolved.length;

      // 1️⃣ جلب بيانات الحساب الأساسية
      final response = await _dio.get(
        '/api/Users/settings',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final account = data['account'] ?? {};
        final String currentUsername = account['username'] ?? '';
        
        String userRank = '#--'; // القيمة الافتراضية لو ملقاش الاسم

        // 2️⃣ جلب الليدربورد عشان نطلع منه الرانك
        try {
          // ⚠️ ملحوظة: غير الـ '/api/Leaderboard' بالمسار الفعلي لليدربورد بتاعك لو مختلف
          final leaderboardResponse = await _dio.get(
            '/api/Challenges/leaderboard', 
            options: Options(headers: {'Authorization': 'Bearer $token'}),
          );

          if (leaderboardResponse.statusCode == 200) {
            final List leaderboard = leaderboardResponse.data;

            // تدوير في اللستة عشان نلاقي الـ Index بتاع اليوزر الحالي
            int index = leaderboard.indexWhere((user) => user['username'] == currentUsername);

            // لو لقاه (يعني الـ Index مش -1)، يبقى الرانك بتاعه هو Index + 1
            if (index != -1) {
              userRank = '#${index + 1}'; 
            }
          }
        } catch (e) {
          print("Error fetching leaderboard for rank: $e");
          // لو حصل مشكلة في الليدربورد، هيكمل عادي ويسيب الرانك #--
        }

        // 3️⃣ تحديث الشاشة بكل الداتا المجمعة
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

  // 2. تحديث الحساب (PUT /api/Users/account)
  // 2. تحديث الحساب (PUT /api/Users/account)
  Future<bool> updateProfile({String? fullName, String? username, String? email, String? bio}) async {
    // مش هنخلي الشاشة كلها تـ Load عشان متعملش فلاش مزعج، هنعتمد على زرار الـ Save
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
        "location": "string", // قيم مطلوبة في الـ Swagger
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
        return true; // 👈 التحديث تم بنجاح
      }
      return false;
    } catch (e) {
      print("Update Error: $e");
      return false; // 👈 التحديث فشل
    }
  }

  // 3. تحديث الإعدادات (Switches)
  // 3. تحديث الإعدادات (Switches) وحفظها محلياً
  void toggleSetting(String key, bool value) async {
    final newSettings = Map<String, bool>.from(state.settings);
    newSettings[key] = value;
    emit(state.copyWith(settings: newSettings));
    
    // حفظ الاختيار في الـ SharedPreferences عشان يفضل ثابت
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
}