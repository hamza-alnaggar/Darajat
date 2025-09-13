import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/sign_up/data/models/get_country_response_model.dart';

class GetUnivercityRemoteDataSourse {
  ApiConsumer api;

  GetUnivercityRemoteDataSourse({
    required this.api,
  });

  Future<List<String>>getUnivercity()async{

    final response = await api.get(EndPoints.universities);
  
    return response['data'];
  }
}
