import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/databases/cache/cache_helper.dart';
import 'package:learning_management_system/features/otp/data/repositories/resend_otp_repository.dart';
import 'package:learning_management_system/features/otp/data/repositories/verify_otp_repository.dart';
import 'package:learning_management_system/features/otp/presentation/cubit/otp_state.dart';



class OtpCubit extends Cubit<OtpState> {
  OtpCubit({required this.resendOtpRepository,required this.verifyOtpRepository,}) : super(VerifyOtpInitial());

  ResendOtpRepository resendOtpRepository ;
  VerifyOtpRepository verifyOtpRepository ;


  // Sign Up Method
  Future<void> eitherFailureOrResendOtp() async {
    emit(ResendLoading());

    final failureOrResendOtp = await resendOtpRepository.resendOtp(
      email:await getUserEmail()
      );
    failureOrResendOtp.fold(
      (failure) => emit(ResendFailure(errMessage: failure.errMessage)),
      (resendOtp) async{
      
        emit(ResendSuccessfully(resendOtp: resendOtp));
      } 
    );
  }

  Future<void> eitherFailureOrVerifyOtp({required String ?otp}) async {
    emit(VerifyOtpLoading());
    final failureOrVerifyOtp = await verifyOtpRepository.verifyOtp(
      email:await getUserEmail(),
      otp: otp
      );
    failureOrVerifyOtp.fold(
      (failure) => emit(VerifyOtpFailure(errMessage: failure.errMessage)),
      (token) async{
        await saveUserToken(token);
        emit(VerifyOtpSuccessfully());
      } 
    );
  }

  Future<String> getUserEmail() async {
  return await SharedPrefHelper.getString("email");
  }

  Future<void> saveUserToken(String accessToken ) async {
    await SharedPrefHelper.setData("accessToken", accessToken);
  }


}
