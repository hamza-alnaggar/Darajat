import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:learning_management_system/core/databases/api/dio_consumer.dart';
import 'package:learning_management_system/features/login/data/datasources/login_remote_data_source.dart';
import 'package:learning_management_system/features/login/data/repositories/login_repository.dart';
import 'package:learning_management_system/features/login/presentation/cubit/login_cubit.dart';
import 'package:learning_management_system/features/logout/data/datasource/logout_remote_data_source.dart';
import 'package:learning_management_system/features/logout/data/repositories/log_out_repository.dart';
import 'package:learning_management_system/features/sign_up/data/datasources/get_country_remote_data_source.dart';
import 'package:learning_management_system/features/sign_up/data/datasources/sign_up_remote_data_source.dart';
import 'package:learning_management_system/features/sign_up/data/repositories/get_country_repository.dart';
import 'package:learning_management_system/features/sign_up/data/repositories/sign_up_repository_impl.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_country_cubit.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/sign_up_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> getItInit() async {
  // get filter
  sl.registerLazySingleton<Dio>(() => Dio());

  sl.registerLazySingleton<DioConsumer>(() => DioConsumer(dio: sl<Dio>()));



  sl.registerLazySingleton<SignUpRemoteDataSource>(
      () => SignUpRemoteDataSource(api: sl<DioConsumer>()));

  sl.registerLazySingleton<SignUpRepository>(() => SignUpRepository(
      signUpRemoteDataSource: sl<SignUpRemoteDataSource>()));

  sl.registerFactory<SignUpCubit>(() => SignUpCubit(signUpRepository: sl<SignUpRepository>()));

  sl.registerLazySingleton<LoginRemoteDataSource>(
      () => LoginRemoteDataSource(api: sl<DioConsumer>()));

  sl.registerLazySingleton<LoginRepository>(() => LoginRepository(
      loginRemoteDataSource: sl<LoginRemoteDataSource>()));

  sl.registerFactory<LoginCubit>(() => LoginCubit(loginRepository: sl<LoginRepository>()));



  sl.registerLazySingleton<GetCountryRemoteDataSource>(
      () => GetCountryRemoteDataSource(api: sl<DioConsumer>()));

  sl.registerLazySingleton<GetCountryRepository>(() => GetCountryRepository(
      getCountryRemoteDataSource: sl<GetCountryRemoteDataSource>()));

  sl.registerFactory<GetCountryCubit>(() => GetCountryCubit(sl<GetCountryRepository>()));
  
  sl.registerLazySingleton<LogOutRemoteDataSource>(
      () => LogOutRemoteDataSource(api: sl<DioConsumer>()));

  sl.registerLazySingleton<LogOutRepository>(() => LogOutRepository(
      logoutRemoteDataSource: sl<LogOutRemoteDataSource>()));
}
