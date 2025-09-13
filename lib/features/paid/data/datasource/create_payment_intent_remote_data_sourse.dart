import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';

class CreatePaymentIntentRemoteDataSourse {
  ApiConsumer api;

  CreatePaymentIntentRemoteDataSourse({
    required this.api,
  });

  Future<String>createPaymentIntent({required int courseId})async{


    final response = await api.post(EndPoints.createPaymentIntent,data: {'course_id':courseId},options:Options(extra: {'authRequired':true}));
  
    return response['clientSecret'];
  }
  Future<String>enrollFreeCourse({required int courseId})async{


    final response = await api.get('${EndPoints.enrollFreeCourse}/$courseId',options:Options(extra: {'authRequired':true}));
  
    return response['message'];
  }

}
