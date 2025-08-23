// features/topics/data/datasources/topic_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/courses/data/models/create_course_request_model.dart';

class CreateCourseRemoteDataSource {
  final ApiConsumer api;

  CreateCourseRemoteDataSource({required this.api});

  Future<String> createCourse({
  required CreateCourseRequestModel requestModel,
}) async {

 
  final response = await api.post(
    EndPoints.createCourse,
    isFormData: true,
    data: requestModel.toJson(),
    options:Options(extra: {
      'authRequired':true
    })
  );

  return response['message'];
}
  Future<String> deleteCourse(
    {
      required int courseId
    }
) async {

  final response = await api.delete(
    '${EndPoints.deleteCourse}/$courseId',
    options:Options(extra: {
      'authRequired':true
    })
  );

  return response['message'];
}
  Future<String> restoreCourse(
  {
          required int courseId

  }
) async {

  final response = await api.put(
    '${EndPoints.restoreCourse}/$courseId',
    options:Options(extra: {
      'authRequired':true
    })
  );

  return response['message'];
}
  Future<String> deleteDraftCourse(
  {
          required int courseId
  }
) async {

  final response = await api.delete(
    '${EndPoints.deleteDraftCourse}/$courseId',
    options:Options(extra: {
      'authRequired':true
    })
  );

  return response['message'];
}
 Future<String> publishCourse(int courseId,bool isCopy) async {


  final response = await api.post(
   isCopy? '${EndPoints.repostCourse}/$courseId':'${EndPoints.publishCourse}/$courseId',
    options: Options(extra: {
      'authRequired':true
    })
  );

  return response['message'];
}


Future<String> cancelUpdate(int courseId) async {


  final response = await api.delete(
    '${EndPoints.cancelUpdate}/$courseId',
    options: Options(extra: {
      'authRequired':true
    })
  );

  return response['message'];
}
  Future<String> updateDraftCourse({
  required CreateCourseRequestModel requestModel,
  required int courseId
}) async {



  final response = await api.put(
    '${EndPoints.updateDraftCourse}/$courseId',
    isFormData: true,
    data: requestModel.toJson(),
    options: Options(extra: {
      'authRequired':true
    })
  );

  return response['message'];
}
  Future<String> updateCourseCopy({
  required CreateCourseRequestModel requestModel,
  required int courseId
}) async {



  final response = await api.put(
    '${EndPoints.updateCourse}/$courseId/copy',
    isFormData: true,
    data: requestModel.toJson(),
    options: Options(extra: {
      'authRequired':true
    })
  );

  return response['message'];
}
  Future<String> updatedApprovedCourse({
  required double price,
  required int courseId,
}) async {

 

  final response = await api.post(
    '${EndPoints.updateApprovedCourse}/$courseId',
    data: {
      'price' : price
    },
    options: Options(extra: {
      'authRequired':true
    })
  );

  return response['message'];
}
}