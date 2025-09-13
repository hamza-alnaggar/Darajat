
import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/core/databases/cache/cache_helper.dart';
import 'package:learning_management_system/features/logout/data/models/log_out_response_model.dart';

class LogOutRemoteDataSource {
  ApiConsumer api;

  LogOutRemoteDataSource({
    required this.api,
  });

  Future<LogOutResponseModel>logout()async{


    final response = await api.get(EndPoints.logout,options: Options(extra: {
      'authRequired':true
    }));

    return LogOutResponseModel.fromJson(response);
  }
  
}
