import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Auth_State.dart';
import 'package:dio/dio.dart';
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://hossammourad-001-site1.ltempurl.com',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  void login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(AuthFailure("Please fill in all fields"));
      return;
    }

    emit(AuthLoading());

    try {
      final response = await _dio.post(
        '/api/Auth/login',
        data: {
          "email": email,
          "password": password,
        },
      );

     
      if (response.statusCode == 200) {
        print("Login Success: ${response.data}");
        String token = response.data['token']; 
     
Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
final prefs = await SharedPreferences.getInstance();
String? savedName = prefs.getString('name');


if (savedName == null || savedName.isEmpty) {
  String userNameFromToken = decodedToken['unique_name'] ?? "User";
  await prefs.setString('name', userNameFromToken);
}


await prefs.setString('token', token);


emit(AuthSuccess());
      } else {
        emit(AuthFailure("Login failed: ${response.data['message'] ?? 'Unknown error'}"));
      }
    } on DioException catch (e) {
       print("Dio Error Type: ${e.type}");
       print("Dio Error Message: ${e.message}");
      String errorMessage = "Connection error";
      if (e.response?.statusCode == 500) {
    
    errorMessage = "Server error: please try again later";
     } else if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? "Invalid email or password";
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Server is taking too long to respond";
      }
      
      emit(AuthFailure(errorMessage));
    } catch (e) {
      emit(AuthFailure("An unexpected error occurred"));
    }
  }
void register({
  required String fullName,
  required String email,
  required String password,
  required String confirmPassword,
  required String skillLevel, 
}) async {
  if (password != confirmPassword) {
    emit(AuthFailure("Passwords do not match!"));
    return;
  }

  if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
    emit(AuthFailure("Please fill in all fields"));
    return;
  }

  emit(AuthLoading());

  try {
    final response = await _dio.post(
      '/api/Auth/register',
      data: {
        "fullName": fullName,
        "email": email,
        "password": password,
        "skillLevel": skillLevel, 
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Register Success: ${response.data}");
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', fullName);
      emit(AuthSuccess());
    }
  } on DioException catch (e) {
    print("Dio Error Type: ${e.type}");
    print("Dio Error Message: ${e.message}");
    String errorMessage = "Registration failed";
    if (e.response != null) {
      errorMessage = e.response?.data['message'] ?? "Check your data and try again";
    }
    emit(AuthFailure(errorMessage));
  } catch (e) {
    emit(AuthFailure("An unexpected error occurred"));
  }
}
}