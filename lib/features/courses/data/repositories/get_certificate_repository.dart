// features/categories/data/repositories/category_repository.dart
import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/courses/data/datasources/category_remote_data_source.dart';
import 'package:learning_management_system/features/courses/data/datasources/get_certificate_remote_data_source.dart';
import 'package:learning_management_system/features/courses/data/models/category_response_model.dart';

class GetCertificateRepository {
  final GetCertificateRemoteDataSource remoteDataSource;

  GetCertificateRepository({required this.remoteDataSource});

  Future<Either<Failure, String>> getCertificate(int courseId) async {
    try {
    final response = await remoteDataSource.getCertificate(courseId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}