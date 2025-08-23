import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/sign_up/data/datasources/get_language_remote_data_source.dart';
import 'package:learning_management_system/features/sign_up/data/models/get_country_response_model.dart';

class GetLanguageRepository {

  final GetLanguageRemoteDataSource getLanguageRemoteDataSource;

  GetLanguageRepository({
    required this.getLanguageRemoteDataSource,
  });

Future<Either<Failure, GetCountryOrLanguageResponseModel>> getLanguage() async {
  try {
    final response = await getLanguageRemoteDataSource.getLanguage(
    );
    return Right(response);
  } on ServerException catch (e) {
   return Left(Failure(errMessage: e.errorModel.errMessage)) ;
}
}
}

