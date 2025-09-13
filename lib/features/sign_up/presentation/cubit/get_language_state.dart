
abstract class GetLanguageState {}

class GetLanguageInitial extends GetLanguageState {}

class GetLanguageSuccessfully extends GetLanguageState {

}
class GetLanguageUpdate extends GetLanguageState {

}

class GetLanguageFailure extends GetLanguageState {
  final String errMessage;
  GetLanguageFailure({required this.errMessage});
}

class ChangeData extends GetLanguageState {
}
