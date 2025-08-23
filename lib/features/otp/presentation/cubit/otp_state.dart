

abstract class OtpState {}

final class ResendInitial extends OtpState {}


final class ResendLoading extends OtpState{}

final class ResendFailure extends OtpState{
  final String errMessage;


  ResendFailure({required this.errMessage});
}
final class ResendSuccessfully extends OtpState{
  final String resendOtp;

  ResendSuccessfully({required this.resendOtp});
}
final class VerifyOtpInitial extends OtpState {}


final class VerifyOtpLoading extends OtpState{}

final class VerifyOtpFailure extends OtpState{
  final String errMessage;


  VerifyOtpFailure({required this.errMessage});
}
final class VerifyOtpSuccessfully extends OtpState{

}

