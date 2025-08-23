// features/education/presentation/cubit/education_state.dart
abstract class GetEducationsState {}

class EducationInitial extends GetEducationsState {}

class EducationLoading extends GetEducationsState {}

class EducationLoaded extends GetEducationsState {}

class EducationFailure extends GetEducationsState {
  final String errMessage;
  EducationFailure({required this.errMessage});
}

class EducationSelectionChanged extends GetEducationsState {}