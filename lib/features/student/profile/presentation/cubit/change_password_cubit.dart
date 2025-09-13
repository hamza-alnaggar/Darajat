
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/student/profile/data/models/change_password_profile_body.dart';
import 'package:learning_management_system/features/student/profile/data/repository/change_password_repository.dart';
import 'package:learning_management_system/features/student/profile/presentation/cubit/change_password_state.dart';

import 'package:learning_management_system/features/student/profile/presentation/cubit/profile_state.dart';
import 'package:learning_management_system/features/sign_up/data/models/auth_response_model.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {

  final ChangePasswordRepository changePasswordRepository;
  AuthResponseModel? profile;


  final formKey = GlobalKey<FormState>();
  
  TextEditingController currentPasswordController = TextEditingController();
TextEditingController newPasswordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();

// Add this method to validate passwords
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  if (value.length < 8) {
    return 'Password must be at least 8 characters';
  }
  if (!value.contains(RegExp(r'[A-Z]'))) {
    return 'Password must contain at least one uppercase letter';
  }
  if (!value.contains(RegExp(r'[0-9]'))) {
    return 'Password must contain at least one number';
  }
  if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    return 'Password must contain at least one special character';
  }
  return null;
}

void clearPasswordFields() {
  currentPasswordController.clear();
  newPasswordController.clear();
  confirmPasswordController.clear();
}


  ChangePasswordCubit(
    this.changePasswordRepository,
  ) : super(ChangePasswordInitial());


  

  Future<void> changePassword() async {
  if (newPasswordController.text != confirmPasswordController.text) {
    emit(ChangePasswordError('New passwords do not match'));
    return;
  }
  
  // Validate password strength
  final passwordError = validatePassword(newPasswordController.text);
  if (passwordError != null) {
    emit(ChangePasswordError(passwordError));
    return;
  }
  
  emit(ChangePasswordLoading());
  
  final body = ChangePasswordProfileBody(
    oldPassword: currentPasswordController.text,
    newPassword: newPasswordController.text,
    newPasswordConfirmation: confirmPasswordController.text
  );
  
  final result = await changePasswordRepository.changePasswordInProfile(body);
  
  result.fold(
    (failure) {
      emit(ChangePasswordError(failure.errMessage));
    },
    (success) {
      clearPasswordFields();
      emit(ChangePasswordSuccess());
    },
  );
}



}