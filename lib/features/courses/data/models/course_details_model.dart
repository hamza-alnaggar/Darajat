// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:learning_management_system/features/courses/data/models/first_episode_mode.dart';

import '../../../../core/databases/api/end_points.dart';

class CourseDetailsModel {
  final int id;
  final String title;
  final String description;
  final String topic;
  final String ?category;
  final String language;
  final List<dynamic> whatWillYouLearn;
  final String imageUrl;
  final TeacherModel teacher;
  final String difficultyLevel;
  final int numOfHours;
  final dynamic price;
  final RateModel rate;
  final int numOfEpisodes;
  final String? publishingDate;
  final bool hasCertificate;
  final int totalQuizes;
  final int numOfStudentsEnrolled;
  final FirstEpisodeMode ?firstEpisodeMode;

  CourseDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.teacher,
    required this.difficultyLevel,
    required this.numOfHours,
    required this.language,
    required this.numOfStudentsEnrolled,
    required this.whatWillYouLearn,
    required this.topic,
    required this.price,
    required this.rate,
    this.category,
    required this.numOfEpisodes,
    required this.publishingDate,
    required this.hasCertificate,
    required this.totalQuizes,
    required this.firstEpisodeMode
  });

  factory CourseDetailsModel.fromJson(Map<String, dynamic> json) {
    return CourseDetailsModel(
      id: json[ApiKey.id],
      title: json[ApiKey.title],
      description: json[ApiKey.description],
      imageUrl: json[ApiKey.imageUrl],
      teacher: TeacherModel.fromJson(json['teacher']),
      difficultyLevel: json[ApiKey.difficultyLevel],
      numOfHours: json[ApiKey.numOfHours],
      price: json[ApiKey.price],
      rate:RateModel.fromJson(json[ApiKey.rate]) ,
      language: json['language'],
      numOfEpisodes: json[ApiKey.numOfEpisodes],
      numOfStudentsEnrolled: json['num_of_students_enrolled'],
      whatWillYouLearn: json['what_will_you_learn'],
      topic: json['topic'],
      category: json['category'],
      publishingDate: json[ApiKey.publishingDate],
      hasCertificate: json[ApiKey.hasCertificate] == 'true',
      totalQuizes: json[ApiKey.totalQuizes],
      firstEpisodeMode:json['first_episode'] != null ?FirstEpisodeMode.fromJson(json['first_episode']) :null
    );
  }
}
class TeacherModel {
  final int id;
  final String fullName;
  final String ?imageUrl;
  TeacherModel({
    required this.id,
    required this.fullName,
    required this.imageUrl,
  });

  factory TeacherModel.fromJson(Map<String,dynamic>json){
    return TeacherModel(id: json[ApiKey.id], fullName: json[ApiKey.fullName], imageUrl: json[ApiKey.imageUrl]);
  }
}

class RateModel {
  final int courseRating;
  final String fiveStar;
  final String fourStar;
  final String threeStar;
  final String twoStar;
  final String oneStar;

  RateModel({
    required this.courseRating,
    required this.fiveStar,
    required this.fourStar,
    required this.threeStar,
    required this.twoStar,
    required this.oneStar,
  });
  factory RateModel.fromJson(Map<String,dynamic>json){
    return RateModel(courseRating: json['course_rating'], fiveStar: json['5'], fourStar: json['4'], threeStar: json['3'], twoStar: json['2'], oneStar: json['1']);
  }
  
}
