import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/sign_up/data/models/get_country_response_model.dart';

class GetCountryRemoteDataSource {
  ApiConsumer api;

  GetCountryRemoteDataSource({
    required this.api,
  });

  Future<GetCountryResponseModel>getCountry()async{

    final response = await api.get(EndPoints.getCountry);
  
    return GetCountryResponseModel.fromJson(response);
  }

}
