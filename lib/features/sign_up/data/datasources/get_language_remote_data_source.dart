import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/sign_up/data/models/get_country_response_model.dart';

class GetLanguageRemoteDataSource {
  ApiConsumer api;

  GetLanguageRemoteDataSource({
    required this.api,
  });

  Future<GetCountryOrLanguageResponseModel>getLanguage()async{

    final response = await api.get(EndPoints.getLanguages);
  
    return GetCountryOrLanguageResponseModel.fromJson(response,false);
  }
}
