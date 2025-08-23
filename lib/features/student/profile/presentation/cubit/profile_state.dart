// features/profile/presentation/cubit/profile_state.dart
import 'package:learning_management_system/features/sign_up/data/models/auth_response_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  AuthResponseModel profile;

  ProfileLoaded({required this.profile});

}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}



class ProfileImageUpdating extends ProfileState {}
class ProfileImageUpdateSuccess extends ProfileState {}
class ProfileImageUpdateError extends ProfileState {
  final String message;
  ProfileImageUpdateError(this.message);
}

class ChangePasswordLoading extends ProfileState {}
class ChangePasswordSuccess extends ProfileState {}
class ChangePasswordError extends ProfileState {
  final String message;
  ChangePasswordError(this.message);
}