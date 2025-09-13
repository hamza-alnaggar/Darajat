import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/login/data/datasources/login_remote_data_source.dart';
import 'package:learning_management_system/features/login/data/models/login_body_model.dart';
import 'package:learning_management_system/features/sign_up/data/models/auth_response_model.dart';

class LoginRepository {

  final LoginRemoteDataSource loginRemoteDataSource;

  LoginRepository({
    required this.loginRemoteDataSource,
  });

Future<Either<Failure, AuthResponseModel>> login({
  required LoginBodyModel loginBodyModel,
}) async {
  try {
    final response = await loginRemoteDataSource.login(
      loginBodyModel: loginBodyModel,
    );
    return Right(response);
  } on ServerException catch (e) {
   return Left(Failure(errMessage: e.errorModel.errMessage)) ;
}
}
Future<Either<Failure, LoginFromGoogleModel>> loginWithGoogle({
  required String token
}) async {
  try {
    final response = await loginRemoteDataSource.loginWithGoogle(
      token: token
    );
    return Right(response);
  } on ServerException catch (e) {
   return Left(Failure(errMessage: e.errorModel.errMessage)) ;
}
}
}

