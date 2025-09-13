import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/sign_up/data/datasources/get_country_remote_data_source.dart';
import 'package:learning_management_system/features/sign_up/data/datasources/get_specialized_remote_data_sourse.dart';
import 'package:learning_management_system/features/sign_up/data/models/get_country_response_model.dart';

class GetSpeciRepository {

  final GetSpecializedRemoteDataSourse remoteDataSourse;

  GetSpeciRepository({
    required this.remoteDataSourse,
  });

Future<Either<Failure, GetCountryOrLanguageResponseModel>> getSpec() async {
  try {
    final response = await remoteDataSourse.getSpecialized(
    );
    return Right(response);
  } on ServerException catch (e) {
   return Left(Failure(errMessage: e.errorModel.errMessage)) ;
}
}
}

