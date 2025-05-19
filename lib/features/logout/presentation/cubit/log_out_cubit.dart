import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/di/dependency_injection.dart';
import 'package:learning_management_system/features/logout/data/repositories/log_out_repository.dart';
import 'package:learning_management_system/features/logout/presentation/cubit/log_out_state.dart';

class LogOutCubit extends Cubit<LogOutState> {

  LogOutCubit() : super(LogOutInitial());

   eitherFailureOrLogOut ()async{
    emit(LogOutLoading());
    final failureOrLogOut = await sl<LogOutRepository>().logout();
    failureOrLogOut.fold(
      (failure) => emit(LogOutFailure(errMessage: failure.errMessage)),
      (logOut) => emit(LogOutSuccessfully(logOutResponseModel: logOut)),
    );
  }
}
