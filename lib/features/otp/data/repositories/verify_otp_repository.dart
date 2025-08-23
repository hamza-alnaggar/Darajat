import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/otp/data/datasources/verify_otp_remote_data_source.dart';

class VerifyOtpRepository {

  final VerifyOtpRemoteDataSource verifyOtpRemoteDataSource;

  VerifyOtpRepository({
    required this.verifyOtpRemoteDataSource,
  });

Future<Either<Failure, String>> verifyOtp({required String ?otp,required String email}) async {
  try {
    final response = await verifyOtpRemoteDataSource.verfiyOtp(
      email: email,
      otp: otp
    );
    return Right(response);
  } on ServerException catch (e) {
   return Left(Failure(errMessage: e.errorModel.errMessage)) ;
}
}
}

