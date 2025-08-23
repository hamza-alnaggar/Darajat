// reply_response_model.dart
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/comment/data/models/reply_model.dart';

class RepliesResponseModel {
  final List<ReplyModel> replies;
  final String message;

  RepliesResponseModel({
    required this.replies,
    required this.message,
  });

  factory RepliesResponseModel.fromJson(Map<String, dynamic> json) {
    return RepliesResponseModel(
      replies: (json[ApiKey.data] as List)
          .map((e) => ReplyModel.fromJson(e))
          .toList(),
      message: json[ApiKey.message],
    );
  }
}

class ReplyResponseModel {
  final ReplyModel reply;
  final String message;

  ReplyResponseModel({
    required this.reply,
    required this.message,
  });

  factory ReplyResponseModel.fromJson(Map<String, dynamic> json) {
    return ReplyResponseModel(
      reply: ReplyModel.fromJson(json[ApiKey.data]),
      message: json[ApiKey.message],
    );
  }
}

