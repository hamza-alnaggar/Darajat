// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/logout/data/datasource/logout_remote_data_source.dart';
import 'package:learning_management_system/features/logout/data/models/log_out_response_model.dart';

class LogOutRepository  {

  LogOutRemoteDataSource logoutRemoteDataSource;

  LogOutRepository({
    required this.logoutRemoteDataSource,
  });

  Future<Either<Failure,LogOutResponseModel>>logout() async{
    try{
    final response =await  logoutRemoteDataSource.logout();
    return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
  }
}
}