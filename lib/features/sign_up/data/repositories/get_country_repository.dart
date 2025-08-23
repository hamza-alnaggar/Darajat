import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/sign_up/data/datasources/get_country_remote_data_source.dart';
import 'package:learning_management_system/features/sign_up/data/models/get_country_response_model.dart';

class GetCountryRepository {

  final GetCountryRemoteDataSource getCountryRemoteDataSource;

  GetCountryRepository({
    required this.getCountryRemoteDataSource,
  });

Future<Either<Failure, GetCountryOrLanguageResponseModel>> getCountry() async {
  try {
    final response = await getCountryRemoteDataSource.getCountry(
    );
    return Right(response);
  } on ServerException catch (e) {
   return Left(Failure(errMessage: e.errorModel.errMessage)) ;
}
}
}

