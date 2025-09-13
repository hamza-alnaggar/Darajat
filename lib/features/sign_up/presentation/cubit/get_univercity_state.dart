abstract class GetUnivercityState {}

class GetUnivercityInitial extends GetUnivercityState {}

class GetUnivercitySuccessfully extends GetUnivercityState {}

class GetUnivercityFailure extends GetUnivercityState {
  final String errMessage;
 GetUnivercityFailure({required this.errMessage});
}

class ChangeUnivercity extends GetUnivercityState {
}
