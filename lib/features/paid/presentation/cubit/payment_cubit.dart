import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/di/dependency_injection.dart';

import 'package:learning_management_system/features/paid/data/repositories/create_payment_repository.dart';
import 'package:learning_management_system/features/paid/presentation/cubit/payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {


  PaymentCubit() : super(PaymentInitial());

   eitherFailureOrCreatePayment (
    int courseId
  )async{
    emit(CreatePaymentLoading());
    final failureOrLogOut = await sl<CreatePaymentRepository>().createPayment(courseId: courseId);
    failureOrLogOut.fold(
      (failure) => emit(CreatePaymentFailure(errMessage: failure.errMessage)),
      (response) => emit(CreatePaymentSuccessfully(clientSecret: response)),
    );
  }
   eitherFailureOrEnrollFreeCourse (
    int courseId
  )async{
    emit(CreatePaymentLoading());
    final failureOrLogOut = await sl<CreatePaymentRepository>().enrollFreeCourse(courseId: courseId);
    failureOrLogOut.fold(
      (failure) => emit(CreatePaymentFailure(errMessage: failure.errMessage)),
      (response) => emit(EnrollFreeCourseSuccessfully(message: response)),
    );
  }
}
