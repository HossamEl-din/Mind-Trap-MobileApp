import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:grad/widgets/roadmap/roadmap_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
abstract class TopicDetailsState {}
class TopicDetailsInitial extends TopicDetailsState {}
class TopicDetailsLoading extends TopicDetailsState {}
class TopicDetailsSuccess extends TopicDetailsState {
  final TopicDetails details;
  TopicDetailsSuccess(this.details);
}
class TopicDetailsError extends TopicDetailsState {
  final String message;
  TopicDetailsError(this.message);
}


class TopicDetailsCubit extends Cubit<TopicDetailsState> {
  TopicDetailsCubit() : super(TopicDetailsInitial());

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://hossammourad-001-site1.ltempurl.com',
  ));

  Future<void> loadTopicDetails(int id) async {
    emit(TopicDetailsLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      
      final response = await _dio.get(
        '/api/LearningPath/topic/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final details = TopicDetails.fromJson(response.data);
      emit(TopicDetailsSuccess(details));
    } catch (e) {
      emit(TopicDetailsError("Failed to load topic details."));
    }
  }
}