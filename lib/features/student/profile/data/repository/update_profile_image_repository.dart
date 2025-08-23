// features/profile/data/repositories/profile_repository.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/student/profile/data/datasource/update_profile_image_remote_data_source.dart';
import 'package:learning_management_system/features/sign_up/data/models/auth_response_model.dart';

class UpdateProfileImageRepository {
  final UpdateProfileImageRemoteDataSource remoteDataSource;

  UpdateProfileImageRepository({required this.remoteDataSource});

Future<Either<Failure, AuthResponseModel>> updateProfileImage(File image) async {
  try {
    final response = await remoteDataSource.updateProfileImage(image);
    return Right(response);
  } on ServerException catch (e) {
    return Left(Failure(errMessage: e.errorModel.errMessage));
  }
}
}