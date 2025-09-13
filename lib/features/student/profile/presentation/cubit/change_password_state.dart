// features/profile/presentation/cubit/profile_state.dart

abstract class ChangePasswordState {}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}
class ChangePasswordSuccess extends ChangePasswordState {}
class ChangePasswordError extends ChangePasswordState {
  final String message;
  ChangePasswordError(this.message);
}