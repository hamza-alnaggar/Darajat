// features/profile/data/datasources/profile_remote_data_source.dart
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/student/profile/data/models/change_password_profile_body.dart';
import 'package:learning_management_system/features/sign_up/data/models/auth_response_model.dart';

class ChangePasswordProfileRemoteDataSource {
  final ApiConsumer api;

  ChangePasswordProfileRemoteDataSource({required this.api});

  Future<AuthResponseModel> changePasswordInProfile(ChangePasswordProfileBody body) async {
    final response = await api.get(EndPoints.changePassword,data: body.toJson());
    return AuthResponseModel.fromJson(response);
  }
}