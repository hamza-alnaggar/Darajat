

abstract class SignUpState {}

final class SignUpInitial extends SignUpState {}


final class SignUpLoading extends SignUpState{}

final class SignUpFailure extends SignUpState{
  final String errMessage;
 

  SignUpFailure({required this.errMessage});
}
final class SignUpSuccessfully extends SignUpState{
  final String message ;

  SignUpSuccessfully({required this.message});

}

