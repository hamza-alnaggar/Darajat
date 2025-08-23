import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/core/databases/cache/cache_helper.dart';
import 'package:learning_management_system/core/errors/expentions.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;
  
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  DioConsumer({required this.dio}) {
    dio.options
      ..baseUrl = EndPoints.baserUrl
      ..headers = _defaultHeaders; // Set default headers here
    
    _addDioInterceptor();
  }

  void _addDioInterceptor() {
    dio.interceptors.addAll([
      // Token interceptor
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
          // Apply default headers first (already set, but ensure per-request consistency)
          options.headers.addAll(_defaultHeaders);

          final String local = await SharedPrefHelper.getString('local') ?? 'ar';
  options.headers['Accept-Language'] = local.isNotEmpty ? local : 'ar';
          
          if (options.extra['authRequired'] == true) {
            try {
              final token = await SharedPrefHelper.getString('accessToken');
              if (token != null) {
                options.headers['Authorization'] = 'Bearer $token';
              }
            } catch (e) {
              handler.reject(
                DioException(
                  requestOptions: options,
                  error: 'Token retrieval failed: $e',
                ),
                true,
              );
              return;
            }
          }
          handler.next(options);
        },
      ),
  
    PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
    ),
    ]);
  }


  //!POST
  @override
 Future post(String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
    Options ?options}) async {
    try {
      var res = await dio.post(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
        options: options
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  //!GET
  @override
  Future get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options ?options
  }) async {
    try {
      var res = await dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  //!DELETE
  @override
  Future delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
        Options ?options

  }) async {
    try {
      var res = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  //!PATCH
  @override
  Future put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
    Options ?options

  }) async {
    try {
      var res = await dio.put(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
        options: options
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }
}
