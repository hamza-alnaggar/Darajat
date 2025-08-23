abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccessfully extends ForgotPasswordState {}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String errMessage;
  ForgotPasswordFailure({required this.errMessage});
}

