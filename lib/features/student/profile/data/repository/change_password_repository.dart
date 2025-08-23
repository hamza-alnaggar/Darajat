// features/profile/data/repositories/profile_repository.dart
import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/student/profile/data/datasource/change_password_profile_remote_data_source.dart';
import 'package:learning_management_system/features/student/profile/data/models/change_password_profile_body.dart';
import 'package:learning_management_system/features/sign_up/data/models/auth_response_model.dart';

class ChangePasswordRepository {
  final ChangePasswordProfileRemoteDataSource remoteDataSource;

  ChangePasswordRepository({required this.remoteDataSource});

  Future<Either<Failure, AuthResponseModel>> changePasswordInProfile(ChangePasswordProfileBody body) async {
    try {
      final response = await remoteDataSource.changePasswordInProfile(body);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}