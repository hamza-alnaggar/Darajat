import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/otp/data/datasources/resed_otp_remote_data_source.dart';

class ResendOtpRepository {

  final ResedOtpRemoteDataSource resedOtpRemoteDataSource;

  ResendOtpRepository({
    required this.resedOtpRemoteDataSource,
  });

Future<Either<Failure, String>> resendOtp({required String email}) async {
  try {
    final response = await resedOtpRemoteDataSource.resendOtp(email: email);
    
    return Right(response);
  } on ServerException catch (e) {
   return Left(Failure(errMessage: e.errorModel.errMessage)) ;
}
}
}

