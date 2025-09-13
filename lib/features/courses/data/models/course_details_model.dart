// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:learning_management_system/features/courses/data/models/category_response_model.dart';
import 'package:learning_management_system/features/courses/data/models/episode_response_model.dart';
import 'package:learning_management_system/features/courses/data/models/topic_response_model.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/country_sub_model.dart';

import '../../../../core/databases/api/end_points.dart';

class CourseDetailsModel {
  final int id;
  final String title;
  final String description;
  final TopicModel topic;
  final CategoryModel?category;
  final CountryOrLanguageSubModel language;
  final List<dynamic> whatWillYouLearn;
  final String imageUrl;
  final TeacherModel teacher;
  final String difficultyLevel;
  final int numOfHours;
  final dynamic price;
  final RateModel rate;
  final bool ?isMycourse;
  final bool ?isSubscribed;
  final int numOfEpisodes;
  final String? createAt;
  final String? responseDate;
  final String? publishingDate;
  final String? status;
  final String? publishing_request_date;
  final bool hasCertificate;
  final int totalQuizes;
  final int numOfStudentsEnrolled;
  final EpisodeModel ?firstEpisodeMode;

  CourseDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.teacher,
     this.status,
     this.isMycourse,
     this.isSubscribed,
    required this.difficultyLevel,
    required this.numOfHours,
    required this.language,
    required this.numOfStudentsEnrolled,
    required this.whatWillYouLearn,
    required this.topic,
    required this.price,
    required this.rate,
    this.category,
    this.publishingDate,
    this.createAt,
    this.responseDate,
    required this.numOfEpisodes,
    required this.publishing_request_date,
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
      status: json['status'],
      isMycourse: json['is_my_course'],
      isSubscribed: json['is_subscribed'],
      rate:RateModel.fromJson(json[ApiKey.rate]) ,
      language:CountryOrLanguageSubModel.fromJson(json['language'], false) ,
      numOfEpisodes: json[ApiKey.numOfEpisodes],
      responseDate: json['response_date'],
      createAt: json['created_at'],
      numOfStudentsEnrolled: json['num_of_students_enrolled'],
      whatWillYouLearn: json['what_will_you_learn'],
      topic:TopicModel.fromJson(json['topic']) ,
      publishingDate: json['publishing_date'],
      category:CategoryModel.fromJson(json['category']) ,
      publishing_request_date: json['publishing_request_date'],
      hasCertificate: json[ApiKey.hasCertificate] ,
      totalQuizes: json[ApiKey.totalQuizes],
      firstEpisodeMode:json['first_episode'] != null ?EpisodeModel.fromJson(json['first_episode']) :null
    );
  }
}
class CourseDetailsResponse{
  final CourseDetailsModel course;
  final String message ;

  CourseDetailsResponse({required this.course, required this.message});
   factory CourseDetailsResponse.fromJson(Map<String,dynamic>json){
    return CourseDetailsResponse(course:CourseDetailsModel.fromJson( json['data']) ,message: json['message']);
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
