// features/education/data/datasources/get_education_remote_data_source.dart
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/student/educations/data/models/educations_respons_model.dart';

class GetEducationsRemoteDataSource {
  final ApiConsumer api;

  GetEducationsRemoteDataSource({required this.api});

  Future<EducationResponseModel> getEducations() async {
    final response = await api.get(EndPoints.educations);
    return EducationResponseModel.fromJson(response);
  }
}