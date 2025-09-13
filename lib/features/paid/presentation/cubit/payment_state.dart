


class PaymentState {}

final class PaymentInitial extends PaymentState {}


final class CreatePaymentLoading extends PaymentState{}

final class CreatePaymentFailure extends PaymentState{
  final String errMessage;
 CreatePaymentFailure({required this.errMessage});
}
final class CreatePaymentSuccessfully extends PaymentState{
 final String clientSecret ;

  CreatePaymentSuccessfully({required this.clientSecret}); 
}
final class EnrollFreeCourseSuccessfully extends PaymentState{
 final String message ;

  EnrollFreeCourseSuccessfully({required this.message}); 
}

