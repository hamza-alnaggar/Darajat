// features/profile/presentation/cubit/profile_state.dart

abstract class PromoteStudentState {}

class PromoteStudentInitial extends PromoteStudentState {}

class PromoteStudentLoading extends PromoteStudentState {}
class PromoteStudentSuccess extends PromoteStudentState {
  final String message;

  PromoteStudentSuccess({required this.message});
}
class PromoteStudentError extends PromoteStudentState {
  final String message;
  PromoteStudentError(this.message);
}