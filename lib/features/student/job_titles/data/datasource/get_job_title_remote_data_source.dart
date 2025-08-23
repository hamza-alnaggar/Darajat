// features/education/data/datasources/get_education_remote_data_source.dart
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/sign_up/data/models/get_country_response_model.dart';

class GetJobTitleRemoteDataSource {
  final ApiConsumer api;

  GetJobTitleRemoteDataSource({required this.api});

  Future<GetCountryOrLanguageResponseModel> getJobTitle() async {
    final response = await api.get(EndPoints.jobTitle);
    return GetCountryOrLanguageResponseModel.fromJson(response,true);
  }
}