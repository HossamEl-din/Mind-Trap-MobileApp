import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'ai_State.dart';

class AICubit extends Cubit<AIState> {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://hossammourad-001-site1.ltempurl.com'));
  List<Map<String, String>> chatHistory = [];

  AICubit() : super(AIInitial());

  void askAI({required String message, String actionType = "General"}) async {
    if (message.trim().isEmpty) return;

    
    chatHistory.add({"role": "user", "content": message});
    emit(AISuccess(messages: List.from(chatHistory)));

    emit(AILoading());

    try {
      
      final response = await _dio.post(
        '/api/AiChat/ask',
        data: {
          "actionType": actionType,
          "message": message,
        },
      );

      if (response.statusCode == 200) {
        
        String aiResponse = response.data['reply'] ?? "No response";
        
        chatHistory.add({"role": "assistant", "content": aiResponse});
        emit(AISuccess(messages: List.from(chatHistory)));
      }
    } on DioException catch (e) {
      print("AI Error: ${e.message}");
      emit(AIError("حدث خطأ في التواصل مع مساعد الذكاء الاصطناعي"));
    }
  }
}