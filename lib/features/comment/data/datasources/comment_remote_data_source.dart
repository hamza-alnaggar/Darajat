import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/comment/data/models/comment_model.dart';
import 'package:learning_management_system/features/comment/data/models/comment_response_model.dart';

class CommentRemoteDataSource {
  final ApiConsumer api;

  CommentRemoteDataSource({required this.api});

  Future<CommentResponseModel> getInitialComments(int episodeId) async {

    final response = await api.get(
      '${EndPoints.getComment}/$episodeId',options: Options(extra: {'authRequired': true},)
    );
    return CommentResponseModel.fromJson(response);
  }

  Future<CommentResponseModel> loadMoreComments(
      int episodeId, int page) async {

    
        
    final response = await api.post(
      '${EndPoints.getMoreComment}/$episodeId',
      data: {'page': page},
      options: Options(extra: {'authRequired': true},)
    );
    return CommentResponseModel.fromJson(response);
  }
  Future<CommentResponseModel> getMyComments(int episodeId) async {
    final response = await api.get('${EndPoints.getMyComment}/$episodeId');
    return CommentResponseModel.fromJson(response);
  }

  // Add a new comment
  Future<CommentModel> addComment({
    required int episodeId,
    required String content,
  }) async {

    

    final response = await api.post(
    '${EndPoints.createComment}/$episodeId',
      data: {'content': content},
      options: Options(extra: {'authRequired': true},)
    
    );
    return CommentModel.fromJson(response[ApiKey.data]);
  }

  Future<CommentModel> updateComment({
    required int commentId,
    required String content,
  }) async {

    
    final response = await api.put(
      '${EndPoints.updateComment}/$commentId',
      data: {'content': content},
      options: Options(extra: {'authRequired': true},)
    );
    return CommentModel.fromJson(response[ApiKey.data]);
  }

  Future<String> deleteComment(int commentId,bool isTeacher) async {

    
    final response = await api.delete('${isTeacher?EndPoints.deleteCommentForTeacher : EndPoints.deleteComment}/$commentId',options:  Options(extra: {'authRequired': true},));
    return response[ApiKey.message];
  }

  Future<CommentModel> addLike(int commentId) async {
   

  final response = await api.post('${EndPoints.addLike}/$commentId',options: Options(extra: {'authRequired': true},));
  return CommentModel.fromJson(response['data']);
}


}