
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/student/profile/data/models/change_password_profile_body.dart';
import 'package:learning_management_system/features/student/profile/data/repository/change_password_repository.dart';
import 'package:learning_management_system/features/student/profile/data/repository/promote_student_repository.dart';

import 'package:learning_management_system/features/student/profile/presentation/cubit/promote_student_state.dart';

class PromoteStudentCubit extends Cubit<PromoteStudentState> {

  final PromoteStudentRepository promoteStudentRepository;



  PromoteStudentCubit(
    this.promoteStudentRepository,
  ) : super(PromoteStudentInitial());


  Future<void> promoteStudent() async {
  emit(PromoteStudentLoading());

  final result = await promoteStudentRepository.promoteStudent();
  
  result.fold(
    (failure) {
      emit(PromoteStudentError(failure.errMessage));
    },
    (success) {
      emit(PromoteStudentSuccess(message:success));
    },
  );
}
}