// reply_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/comment/data/models/reply_model.dart';
import 'package:learning_management_system/features/comment/data/models/reply_reponse_model.dart';

class ReplyRemoteDataSource {
  final ApiConsumer api;

  ReplyRemoteDataSource({required this.api});

  // Get replies for a comment
  Future<RepliesResponseModel> getReplies(int commentId) async {

    final response = await api.get('${EndPoints.replies}/$commentId',options: Options(extra: {'authRequired': true},));
    return RepliesResponseModel.fromJson(response);
  }

  // Add a new reply
  Future<ReplyResponseModel> addReply({
    required int commentId,
    required String content,
  }) async {
    
    final response = await api.post(
      '${EndPoints.createReplies}/$commentId',
      data: {'content': content},
      options: Options(extra: {'authRequired': true},)
    );
    return ReplyResponseModel.fromJson(response);
  }

  // Update a reply
  Future<ReplyModel> updateReply({
    required int replyId,
    required String content,
  }) async {

    final response = await api.put(
      '${EndPoints.updateReply}/$replyId',
      data: {'content': content},
      options: Options(extra: {'authRequired': true},)
    );
    return ReplyModel.fromJson(response['data']);
  }

  // Delete a reply
  Future<String> deleteReply(int replyId,bool isTeacher) async {

    final response = await api.delete('${isTeacher? EndPoints.deleteReplieyForTeacher :EndPoints.deleteReply}/$replyId',options: Options(extra: {'authRequired': true},));
    return response[ApiKey.message];
  }

  Future<ReplyResponseModel> LikeReply(int replyId) async {
    final response = await api.post('${EndPoints.LikeReply}/$replyId',options: Options(extra: {'authRequired': true},));
    return ReplyResponseModel.fromJson(response);
  }
  
}