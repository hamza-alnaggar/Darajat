// features/education/presentation/cubit/education_state.dart
abstract class JobTitleState {}

class JobTitleInitial extends JobTitleState {}

class JobTitleLoading extends JobTitleState {}

class JobTitleLoaded extends JobTitleState {}

class JobTitleFailure extends JobTitleState {
  final String errMessage;
  JobTitleFailure({required this.errMessage});
}

class JobTitleSelectionChanged extends JobTitleState {}