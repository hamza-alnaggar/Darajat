// ignore_for_file: public_member_api_docs, sort_constructors_first
// features/episodes/data/models/episode_response_model.dart

import 'package:learning_management_system/features/student/quiz/data/models/quiz_model.dart';

class   EpisodeResponseModel {
  final List<EpisodeModel> data;
  final dynamic progressPercentage ;

  EpisodeResponseModel({
    required this.data,
    required this.progressPercentage
  });

   factory EpisodeResponseModel.fromJson(dynamic json, bool isStudent) {
    List<dynamic> episodeList;
    dynamic progress;
    
    if (isStudent) {
      // Student structure: json is a Map with 'episodes' key
      episodeList = json['episodes'] as List<dynamic>;
      progress = json['progress_percentage'];
    } else {
      // Teacher structure: json is directly the list of episodes
      episodeList = json as List<dynamic>;
      progress = null; // Progress might not be available for teacher
    }

    return EpisodeResponseModel(
      data: episodeList
          .map<EpisodeModel>((episode) => EpisodeModel.fromJson(episode))
          .toList(),
      progressPercentage: progress,
    );
  }
}



class EpisodeModel {
 final int id;
  final String title;
  final int episodeNumber;
  final String duration;
  final bool ?isLiked;
  final int likes;
  bool ?hasFile;
  final bool ?isWatched;
  final int views;
  final bool ?isQuizCompleted;
  final QuizModel ?quiz;

  EpisodeModel({
    required this.id,
    required this.title,
    required this.episodeNumber,
    required this.duration,
    required this.isLiked,
    required this.likes,
    required this.isWatched,
    required this.views,
    required this.isQuizCompleted,
    this.hasFile,
    required this.quiz,
  });


  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'],
      title: json['title'],
      duration: json['duration'],
      views: json['views'],
      likes: json['likes'],
      isWatched: json['is_watched'],
      hasFile: json['has_file'],
      isLiked: json['is_liked'],
      isQuizCompleted: json['is_quiz_completed'],
      quiz:json['quiz']!= null? QuizModel.fromJson(json['quiz']) :null,
      episodeNumber: json['episode_number'],
    );
  }

  EpisodeModel copyWith({
    int? id,
    String? title,
    int? episodeNumber,
    String? duration,
    bool ?isLiked,
    int? likes,
    bool ?hasFile,
    bool ?isWatched,
    int? views,
    bool ?isQuizCompleted,
    QuizModel ?quiz,
  }) {
    return EpisodeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      duration: duration ?? this.duration,
      isLiked: isLiked ?? this.isLiked,
      likes: likes ?? this.likes,
      hasFile: hasFile ?? this.hasFile,
      isWatched: isWatched ?? this.isWatched,
      views: views ?? this.views,
      isQuizCompleted: isQuizCompleted ?? this.isQuizCompleted,
      quiz: quiz ?? this.quiz,
    );
  }
}
class EpisodeResponse {
 final  EpisodeModel episodeModel ;
 final  String message;

  EpisodeResponse({required this.episodeModel, required this.message});

  factory EpisodeResponse.fromJson(Map<String, dynamic> json) {
    return EpisodeResponse(
      episodeModel:EpisodeModel.fromJson(json['data']) ,
      message: json['message']
    );
  }
}