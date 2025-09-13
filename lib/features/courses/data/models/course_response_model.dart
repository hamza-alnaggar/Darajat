// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/comment/data/models/meta_model.dart';

class CourseResponseModel {
  final List<CourseModel> data;
  final MetaModel ?meta;

  CourseResponseModel({
    required this.data,
    required this.meta,
  });

  factory CourseResponseModel.fromJson(Map<String, dynamic> json) {
    return CourseResponseModel(
      data: (json[ApiKey.data] as List)
          .map((course) => CourseModel.fromJson(course))
          .toList(),
      meta:json[ApiKey.meta] !=null ? MetaModel.fromJson(json[ApiKey.meta]): null
    );
  }
}

class CourseModel {
    final int id;
    final String imageUrl;
    final String title;
    final String teacher;
    final int ?teacherId;
    final String price;
    final int rate;
    final String language;
    final int numOfStudentsEnrolled;
    final String ?percentageProgress;
    final dynamic isOwner;
    final String ?deletedAt;
    final String ?createdAt;
    final String ?responseDate;
    final String ?publishingRequestDate;


  CourseModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.teacher,
    required this.price,
    required this.rate,
    required this.language,
    required this.teacherId,
    this.percentageProgress,
    this.deletedAt,
    required this.numOfStudentsEnrolled,
    this.isOwner,
    this.createdAt,
    this.publishingRequestDate,
    this.responseDate,
  });

  factory CourseModel.fromJson(Map<String,dynamic>json){
    return CourseModel(createdAt: json['created_at'],publishingRequestDate: json['publishing_request_date'],responseDate: json['response_date'],percentageProgress: json['percentage_progress'],teacherId: json['teacher_id'],deletedAt: json['deleted_at'],id: json[ApiKey.id], imageUrl: json[ApiKey.imageUrl], title: json[ApiKey.title], teacher: json['teacher'], price: json[ApiKey.price], rate: json[ApiKey.rate], language: json['language'], numOfStudentsEnrolled: json['num_of_students_enrolled'],isOwner: json['is_owner']);
  }
  }


