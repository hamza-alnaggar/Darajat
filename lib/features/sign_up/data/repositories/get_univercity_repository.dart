import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/sign_up/data/datasources/get_univercity_remote_data_sourse.dart';
import 'package:learning_management_system/features/sign_up/data/models/get_country_response_model.dart';

class GetUnivercityRepository {

  final GetUnivercityRemoteDataSourse remoteDataSourse;

  GetUnivercityRepository({
    required this.remoteDataSourse,
  });

Future<Either<Failure, List<String>>> getUnivercity() async {
  try {
    final response = await remoteDataSourse.getUnivercity(
    );
    return Right(response);
  } on ServerException catch (e) {
   return Left(Failure(errMessage: e.errorModel.errMessage)) ;
}
}
}

