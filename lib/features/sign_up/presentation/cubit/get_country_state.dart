abstract class GetCountryState {}

class GetCountrynitial extends GetCountryState {}

class GetCountrySuccessfully extends GetCountryState {}

class GetCountryFailure extends GetCountryState {
  final String errMessage;
  GetCountryFailure({required this.errMessage});
}

class ChangeData extends GetCountryState {
}
