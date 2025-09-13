abstract class GetSpeciState {}

class GetSpeciInitial extends GetSpeciState {}

class GetSpeciSuccessfully extends GetSpeciState {}

class GetSpeciFailure extends GetSpeciState {
  final String errMessage;
  GetSpeciFailure({required this.errMessage});
}

class ChangeData extends GetSpeciState {
}
