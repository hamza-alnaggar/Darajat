import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:learning_management_system/core/databases/api/dio_consumer.dart';

final GetIt sl = GetIt.instance;

Future<void> getItInit() async {
  // get filter
  sl.registerLazySingleton<DioConsumer>(() => DioConsumer(dio: Dio()));

}
