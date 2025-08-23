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
      '${EndPoints.replies}/$commentId',
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
      '${EndPoints.replies}/$replyId',
      data: {'content': content},
      options: Options(extra: {'authRequired': true},)
    );
    return ReplyModel.fromJson(response);
  }

  // Delete a reply
  Future<String> deleteReply(int replyId,bool isTeacher) async {

    final response = await api.delete('${isTeacher? EndPoints.deleteReplieyForTeacher :EndPoints.replies}/$replyId',options: Options(extra: {'authRequired': true},));
    return response[ApiKey.message];
  }

  // Add like to a reply
  Future<ReplyResponseModel> addLikeReply(int replyId) async {
    final response = await api.post('${EndPoints.addLikeReply}/$replyId',options: Options(extra: {'authRequired': true},));
    return ReplyResponseModel.fromJson(response);
  }

  // Remove like from a reply
  Future<ReplyResponseModel> removeLikeReply(int replyId) async {
    
    final response = await api.delete('${EndPoints.removeLikeReply}/$replyId',options:Options(extra: {'authRequired': true},));
    return ReplyResponseModel.fromJson(response);
  }
}