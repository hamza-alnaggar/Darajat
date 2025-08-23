import 'package:email_validator/email_validator.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/reset_password/data/repositories/forgot_password_repository.dart';
import 'package:learning_management_system/features/reset_password/presentation/cubit/forgot_password_state.dart';


class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordRepository forgotPasswordRepository;

  ForgotPasswordCubit(this.forgotPasswordRepository) : super(ForgotPasswordInitial());

  TextEditingController emailController = TextEditingController() ;

  final formKey = GlobalKey<FormState>();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty)      return 'Email is required.';
    if (value.length > 255)                  return 'Must be at most 255 characters.';
    if (!EmailValidator.validate(value))     return 'Invalid email address.';
    // NOTE: “unique:people” can only be enforced server‐side; you could optionally do an async call here.
    return null;
  }





  Future<void> eitherFailureOrForgotPassword() async {
    emit(ForgotPasswordLoading());
    final failureOrForgotPassword = await forgotPasswordRepository.forgotPassword(
      emailController.text
    );
    failureOrForgotPassword.fold(
      (failure) => emit(ForgotPasswordFailure(errMessage: failure.errMessage)),
      (forgotPassword) {
        emit(ForgotPasswordSuccessfully());
      },
    );
  }


}