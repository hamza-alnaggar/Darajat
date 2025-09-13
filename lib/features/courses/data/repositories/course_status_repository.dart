import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/courses/data/datasources/create_course_remote_data_source.dart';
import 'package:learning_management_system/features/courses/data/models/course_details_model.dart';
import 'package:learning_management_system/features/courses/data/models/course_response_model.dart';
import 'package:learning_management_system/features/courses/data/models/create_course_request_model.dart';

class CourseStatusRepository {
  final CreateCourseRemoteDataSource remoteDataSource;

  CourseStatusRepository({required this.remoteDataSource});

Future<Either<Failure, CourseDetailsResponse>> createCourse({
  required CreateCourseRequestModel requestModel,
}) async {
  try {
    final response = await remoteDataSource.createCourse(
      requestModel: requestModel,
    );
    return Right(response);
  } on ServerException catch (e) {
    return Left(Failure(errMessage: e.errorModel.errMessage));
  }
}
Future<Either<Failure, String>> deleteCourse(
  {
    required int courseId
  }
) async {
  try {
    final response = await remoteDataSource.deleteCourse(
      courseId: courseId
    );
    return Right(response);
  } on ServerException catch (e) {
    return Left(Failure(errMessage: e.errorModel.errMessage));
  }
}
Future<Either<Failure, String>> restoreCourse(
  {
    required int courseId
  }
) async {
  try {
    final response = await remoteDataSource.restoreCourse(
      courseId: courseId
    );
    return Right(response);
  } on ServerException catch (e) {
    return Left(Failure(errMessage: e.errorModel.errMessage));
  }
}
Future<Either<Failure, String>> deleteDraftCourse(
  {
    required int courseId
  }
) async {
  try {
    final response = await remoteDataSource.deleteDraftCourse(
      courseId: courseId
    );
    return Right(response);
  } on ServerException catch (e) {
    return Left(Failure(errMessage: e.errorModel.errMessage));
  }
}
Future<Either<Failure, String>> updateDraftCourse({
  required CreateCourseRequestModel requestModel,
  required int courseId
}) async {
  try {
    final response = await remoteDataSource.updateDraftCourse(
      courseId: courseId,
      requestModel: requestModel,
    );
    return Right(response);
  } on ServerException catch (e) {
    return Left(Failure(errMessage: e.errorModel.errMessage));
  }
}
Future<Either<Failure, String>> updateApprovedCourse(
  {
  required double price,
  required int courseId,
}
) async {
  try {
    final response = await remoteDataSource.updatedApprovedCourse(
      courseId: courseId,
      price:price ,
    );
    return Right(response);
  } on ServerException catch (e) {
    return Left(Failure(errMessage: e.errorModel.errMessage));
  }
}
Future<Either<Failure, String>> publishCourse(
    int courseId,
    bool isCopy
      ) async {
    try {
      final response = await remoteDataSource.publishCourse(courseId,isCopy);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }

Future<Either<Failure, String>> updateCourseCopy(
    {
  required CreateCourseRequestModel requestModel,
  required int courseId,
}
      ) async {
    try {
      final response = await remoteDataSource.updateCourseCopy(courseId: courseId,requestModel:requestModel );
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
Future<Either<Failure, String>> cancelUpdate(
    int courseId
      ) async {
    try {
      final response = await remoteDataSource.cancelUpdate(courseId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}