import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/reset_password/data/datasources/reset_password_remote_data_source.dart';
import 'package:learning_management_system/features/reset_password/data/models/reset_password_body.dart';

class ResetPasswordRepository {

  final ResetPasswordRemoteDataSource resetPasswordRemoteDataSource;

  ResetPasswordRepository({
    required this.resetPasswordRemoteDataSource,
  });

Future<Either<Failure, String>> resetPassword({
  required ResetPasswordBody resetPasswordBody,
}) async {
  try {
    final response = await resetPasswordRemoteDataSource.resetPassword(
      resetPasswordBody: resetPasswordBody
    );
    return Right(response);
  } on ServerException catch (e) {
   return Left(Failure(errMessage: e.errorModel.errMessage)) ;
}
}
}

