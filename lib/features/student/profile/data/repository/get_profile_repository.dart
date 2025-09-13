// features/profile/data/repositories/profile_repository.dart
import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/student/profile/data/datasource/get_profile_remote_data_source.dart';
import 'package:learning_management_system/features/sign_up/data/models/auth_response_model.dart';

class GetProfileRepository {
  final GetProfileRemoteDataSource remoteDataSource;

  GetProfileRepository({required this.remoteDataSource});

  Future<Either<Failure, AuthResponseModel>> getProfile(int userId) async {
    try {
      final response = await remoteDataSource.getProfile(userId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }

  Future<Either<Failure, AuthResponseModel>> getMyProfile() async {
    try {
      final response = await remoteDataSource.getUserProfile();
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}