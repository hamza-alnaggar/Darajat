import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/sign_up/data/datasources/sign_up_remote_data_source.dart';
import 'package:learning_management_system/features/sign_up/data/models/sign_up_body_model.dart';
import 'package:learning_management_system/features/sign_up/data/models/sign_up_response_model.dart';

class SignUpRepository {

  final SignUpRemoteDataSource signUpRemoteDataSource;

  SignUpRepository({
    required this.signUpRemoteDataSource,
  });

Future<Either<Failure, SignUpResponseModel>> signup({
  required SignUpBodyModel signUpBodyModel,
}) async {
  try {
    final response = await signUpRemoteDataSource.signup(
      signUpBodyModel: signUpBodyModel,
    );
    return Right(response);
  } on ServerException catch (e) {
   return Left(Failure(errMessage: e.errorModel.errorMessage)) ;
}
}
}

