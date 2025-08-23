import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/reset_password/data/repositories/ckeck_code_reset_password_repository.dart';
import 'package:learning_management_system/features/reset_password/presentation/cubit/check_code_reset_password_state.dart';


class CheckCodeResetPasswordCubit extends Cubit<CheckCodeResetPasswordState> {
  final CheckCodeResetPasswordRepository checkCodeResetPasswordRepository;

  String ?checkCode ;

  CheckCodeResetPasswordCubit(this.checkCodeResetPasswordRepository) : super(CheckCodeInitial());

  Future<void> eitherFailureOrCheckCode({required String ?code}) async {
    emit(CheckCodeLoading());
    final failureOrCheckCode = await checkCodeResetPasswordRepository.checkCodeResetPassword(
      code
    );
    failureOrCheckCode.fold(
      (failure) => emit(CheckCodeFailure(errMessage: failure.errMessage)),
      (checkCode) {
        emit(CheckCodeSuccessfully(checkCode: checkCode));
      this.checkCode = code;
      },
    );
  }
}