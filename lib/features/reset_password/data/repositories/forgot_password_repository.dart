import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/reset_password/data/datasources/forgot_password_remote_data_source.dart';

class ForgotPasswordRepository {

  final ForgotPasswordRemoteDataSource forgotPasswordRemoteDataSource;

  ForgotPasswordRepository({
    required this.forgotPasswordRemoteDataSource,
  });

Future<Either<Failure, String>> forgotPassword(String email) async {
  try {
    final response = await forgotPasswordRemoteDataSource.forgotPassword(
      email
    );
    return Right(response);
  } on ServerException catch (e) {
   return Left(Failure(errMessage: e.errorModel.errMessage)) ;
}
}
}

