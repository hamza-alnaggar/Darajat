import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/student/profile/data/datasource/update_profile_remote_data_source.dart';
import 'package:learning_management_system/features/student/profile/data/models/sub_models/update_profile_body_sub_model.dart';
import 'package:learning_management_system/features/sign_up/data/models/auth_response_model.dart';

class UpdateProfileRepository {
  final UpdateProfileRemoteDataSource remoteDataSource;

  UpdateProfileRepository({required this.remoteDataSource});

  Future<Either<Failure, AuthResponseModel>> updateProfile(UpdateProfileBodySubModel body) async {
    try {
      final response = await remoteDataSource.updateProfile(body);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}