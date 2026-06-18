import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:grad/cubits/battle_Cubit/Battle_State.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BattleCubit extends Cubit<BattleState> {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://hossammourad-001-site1.ltempurl.com'));
  final int challengeId;
  final int problemId;
  final bool isPractice;
  int currentHintLevel = 1;
  BattleCubit({required this.challengeId, required this.problemId, required this.isPractice}) : super(BattleInitial());

  // 1. جلب تفاصيل المسألة أول ما الشاشة تفتح
  Future<void> fetchProblemDetails() async {
    emit(BattleLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final String fetchUrl = '/api/Problems/$problemId';

      print("🌐 جاري طلب الداتا من الرابط: $fetchUrl");

      final response = await _dio.get(
        fetchUrl,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print("✅ الداتا اللي رجعت: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;
        final problemData = isPractice ? data : (data['problem'] ?? data);

        emit(BattleLoaded(
          title: problemData['title']?.toString() ?? 'Unknown Title',
          statement: problemData['statement']?.toString() ?? 'No description available.',
          difficulty: problemData['difficulty']?.toString() ?? 'Easy',
          source: problemData['source']?.toString() ?? 'Unknown',
          tags: problemData['tags'] != null ? List<String>.from(problemData['tags']) : [],
          inputFormat: problemData['inputFormat']?.toString() ?? '',
          outputFormat: problemData['outputFormat']?.toString() ?? '',
        ));
      }
    } catch (e) {
      print("🚨 حدث خطأ: $e");
      String errorMsg = "فشل في التحميل.";
      
      if (e is DioException) {
        print("🚨 تفاصيل خطأ السيرفر: Status ${e.response?.statusCode} - Data: ${e.response?.data}");
        errorMsg = "خطأ من السيرفر: ${e.response?.statusCode}";
      }
      
      if (!isClosed) emit(BattleError(errorMsg)); 
    }
  }

  // 2. دالة تشغيل الكود (Run Code)
  Future<void> runCode(String code, int langId) async {
    emit(CodeRunning());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final Map<String, dynamic> payload = {
        "problemId": challengeId, 
        "sourceCode": code,
        "languageId": langId 
      };

      print("🚀 جاري تجربة الكود...");

      final response = await _dio.post(
        '/api/Submissions/run',
        data: payload,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ نتيجة الـ Run: ${response.data}");
        
        final resultsList = response.data['results'] as List?;
        final resultData = (resultsList != null && resultsList.isNotEmpty) ? resultsList[0] : {};

        final bool passed = resultData['passed'] ?? false;
        final String input = resultData['input']?.toString() ?? "No Input";
        final String expected = resultData['expectedOutput']?.toString() ?? "";
        final String actual = resultData['actualOutput']?.toString() ?? "Error";

        if (!isClosed) {
          emit(RunCodeSuccess(
            passed: passed,
            input: input,
            expectedOutput: expected,
            actualOutput: actual,
          ));
        }
      }
    } catch (e) {
      print("🚨 خطأ في الـ Run: $e");
      if (!isClosed) emit(RunCodeError("فشل في تشغيل الكود. تأكد من السيرفر."));
    }
  }

 Future<void> submitSolution(String code, int langId, {String? problemStatement}) async {
    emit(SubmitLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      String submitUrl = isPractice ? '/api/Submissions/submit' : '/api/Challenges/$challengeId/submit';
      Map<String, dynamic> payload = isPractice 
          ? {"problemId": problemId, "sourceCode": code, "languageId": langId}
          : {"sourceCode": code, "languageId": langId};

      print("🚀 جاري إرسال الحل للسيرفر...");
      final response = await _dio.post(
        submitUrl,
        data: payload,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

     if (response.statusCode == 200 || response.statusCode == 201) {
        bool isPassed = false;
        final responseData = response.data;
        String serverVerdict = 'Wrong Answer'; // عشان نمسك رد السيرفر الحقيقي زي الويب

        // منطق التأكد من النجاح (زي الويب بالمللي)
        if (responseData == true || responseData.toString().toLowerCase() == 'true') {
          isPassed = true;
          serverVerdict = 'Accepted';
        } else if (responseData is Map) {
          final status = responseData['status']?.toString() ?? '';
          final verdict = responseData['verdict']?.toString() ?? '';
          
          serverVerdict = verdict.isNotEmpty ? verdict : (status.isNotEmpty ? status : 'Wrong Answer');

          // 👇 هنا رجعنا الـ verdict.toLowerCase() == 'accepted' اللي كانت ناقصة!
          if (status.toLowerCase() == 'accepted' || 
              verdict.toLowerCase() == 'accepted' || 
              status.toLowerCase() == 'success' || 
              responseData['passed'] == true) {
            isPassed = true;
          } else if (responseData['results'] != null && responseData['results'] is List && responseData['results'].isNotEmpty) {
            isPassed = responseData['results'][0]['passed'] ?? false;
          }
        }

        // تجهيز رسالة النتيجة الأساسية
        String originalMessage = isPassed 
            ? (isPractice ? "Solution Accepted! 🎉" : "Challenge Completed! 🏆")
            : "Verdict: $serverVerdict";

        if (isPassed) {
          await prefs.setString('saved_code_$problemId', code);
          List<String> localSolved = prefs.getStringList('local_solved') ?? [];
          if (!localSolved.contains(problemId.toString())) {
            localSolved.add(problemId.toString());
            await prefs.setStringList('local_solved', localSolved);
          }
        }

        // ==========================================
        // 👈👈 استدعاء الـ AI Analyzer في كل الحالات (نجاح أو فشل)
        // ==========================================
        if (problemStatement != null && problemStatement.isNotEmpty) {
          try {
            print("🔍 جاري تحليل الكود بواسطة الذكاء الاصطناعي...");
            final analysisResponse = await _dio.post(
              'https://pulp-licking-visor.ngrok-free.dev/api/v1/analyze',
              data: {
                "problem_description": problemStatement,
                "user_code": code.trim().isEmpty ? " " : code
              }
            );

            if (analysisResponse.statusCode == 200) {
              final aiData = analysisResponse.data;
              if (!isClosed) {
               emit(SubmitAnalysisLoaded(
                  isPassed: isPassed,
                  originalMessage: originalMessage,
                  score: (aiData['rubric_percentage'] as num?)?.toInt() ?? 0, 
                  brief: aiData['brief'] ?? "Analysis complete.",
                  rubric: aiData['rubric'] ?? {},
                  correctnessReason: aiData['correctness_reason'] ?? "",
                  strengths: aiData['strengths'] ?? [],
                  weaknesses: aiData['weaknesses'] ?? [],
                  errorReason: aiData['error_reason'] ?? "",
                ));
                return; 
              }
            }
          } catch (aiError) {
            print("🚨 فشل تحليل الذكاء الاصطناعي (سنعرض النتيجة العادية): $aiError");
          }
        }

        // لو الـ AI وقع، هنعرض النتيجة القديمة بتاعتنا
        if (!isClosed) {
          if (isPassed) emit(SubmitSuccess(originalMessage));
          else emit(SubmitError(originalMessage));
        }
      }
    } on DioException catch (e) {
      if (!isClosed) emit(SubmitError(e.response?.data?['message'] ?? "فشل في إرسال الحل"));
    } catch (e) {
      if (!isClosed) emit(SubmitError("حدث خطأ غير متوقع: $e"));
    }
  }
  Future<void> getHint(String problemDescription, String userCode) async {
    if (currentHintLevel > 3) {
      emit(HintError("You have unlocked all 3 hints for this problem!"));
      return;
    }

    emit(HintLoading());
    try {
      final response = await _dio.post(
        'https://pulp-licking-visor.ngrok-free.dev/api/v1/hint', 
        data: {
          "problem_description": problemDescription,
          "user_code": userCode.trim().isEmpty ? " " : userCode, 
          "hint_level": currentHintLevel
        },
      );

      if (response.statusCode == 200) {
        final hintText = response.data['hint'];
        emit(HintLoaded(hintText, currentHintLevel));
        
       
        currentHintLevel++; 
      } else {
        emit(HintError("Failed to get hint. Try again."));
      }
    } catch (e) {
      emit(HintError("Error fetching hint. Check your connection."));
    }
  }
  
  Future<void> getAiHelp(String problemDescription, String userCode) async {
    emit(AiHelpLoading());
    try {
      final response = await _dio.post(
        'https://pulp-licking-visor.ngrok-free.dev/api/v1/solution', 
        data: {
          "problem_description": problemDescription,
          "user_code": userCode.trim().isEmpty ? " " : userCode,
        },
      );

      if (response.statusCode == 200) {
        final llmCode = response.data['llm_code'] ?? "";
        final explanation = response.data['explanation'] ?? "";
        emit(AiHelpLoaded(llmCode, explanation));
      } else {
        emit(AiHelpError("Failed to get AI solution. Try again."));
      }
    } catch (e) {
      emit(AiHelpError("Error connecting to AI. Check your connection."));
    }
  }
  // 👈 دالة شرح المسألة وتفنيطها
  Future<void> explainProblem(String problemDescription) async {
    emit(ProblemExplainLoading());
    try {
      final response = await _dio.post(
        'https://pulp-licking-visor.ngrok-free.dev/api/v1/explain', 
        data: {
          "problem_description": problemDescription,
          // لاحظ هنا مفيش user_code زي ما الـ Swagger طالب
        },
      );

      if (response.statusCode == 200) {
        emit(ProblemExplainLoaded(
          explanation: response.data['explanation'] ?? "No explanation provided.",
          algorithm: response.data['algorithm'] ?? "No algorithm provided.",
          timeComplexity: response.data['time_complexity'] ?? "N/A",
          spaceComplexity: response.data['space_complexity'] ?? "N/A",
        ));
      } else {
        emit(ProblemExplainError("Failed to get explanation. Try again."));
      }
    } catch (e) {
      emit(ProblemExplainError("Error connecting to AI for explanation."));
    }
  }
}