

import 'package:learning_management_system/features/logout/data/models/log_out_response_model.dart';

class LogOutState {}

final class LogOutInitial extends LogOutState {}


final class LogOutLoading extends LogOutState{}

final class LogOutFailure extends LogOutState{
  final String errMessage;
 

  LogOutFailure({required this.errMessage});
}
final class LogOutSuccessfully extends LogOutState{
  final LogOutResponseModel logOutResponseModel;

  LogOutSuccessfully({required this.logOutResponseModel});
}

