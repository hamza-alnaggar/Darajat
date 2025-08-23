// features/profile/data/datasources/profile_remote_data_source.dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/core/databases/cache/cache_helper.dart';
import 'package:learning_management_system/features/sign_up/data/models/auth_response_model.dart';

class UpdateProfileImageRemoteDataSource {
  final ApiConsumer api;

  UpdateProfileImageRemoteDataSource({required this.api});

 // features/profile/data/datasources/profile_remote_data_source.dart (add)
Future<AuthResponseModel> updateProfileImage(File image) async {
  
  final accessToken = await SharedPrefHelper.getString('accessToken');

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  final response = await api.post(
    EndPoints.updateProfileImage,
    isFormData: true,
    data: {
      'profile_image_url': MultipartFile.fromFileSync(image.path),
    },
    options: Options(headers: headers)
  );
  
  return AuthResponseModel.fromJson(response);
}
}