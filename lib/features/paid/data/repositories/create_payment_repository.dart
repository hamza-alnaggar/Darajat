import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/paid/data/datasource/create_payment_intent_remote_data_sourse.dart';
import 'package:learning_management_system/features/sign_up/data/datasources/sign_up_remote_data_source.dart';
import 'package:learning_management_system/features/sign_up/data/models/sign_up_body_model.dart';
import 'package:learning_management_system/features/sign_up/data/models/auth_response_model.dart';

class CreatePaymentRepository {

  final CreatePaymentIntentRemoteDataSourse remoteDataSourse;

  CreatePaymentRepository({
    required this.remoteDataSourse,
  });

Future<Either<Failure, String>> createPayment({
  required int courseId,
}) async {
  try {
    final response = await remoteDataSourse.createPaymentIntent(
      courseId: courseId
    );
    return Right(response);
  } on ServerException catch (e) {
   return Left(Failure(errMessage: e.errorModel.errMessage)) ;
}
}
Future<Either<Failure, String>> enrollFreeCourse({
  required int courseId,
}) async {
  try {
    final response = await remoteDataSourse.enrollFreeCourse(
      courseId: courseId
    );
    return Right(response);
  } on ServerException catch (e) {
   return Left(Failure(errMessage: e.errorModel.errMessage)) ;
}
}
}

