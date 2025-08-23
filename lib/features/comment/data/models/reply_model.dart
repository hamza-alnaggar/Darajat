// reply_model.dart
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/comment/data/models/comment_model.dart';

class ReplyModel {
  final int id;
  final dynamic commentId;
  final String content;
  final String replyDate;
  final bool isLiked;
  final int likes;
  final CommentUserModel user;

  ReplyModel({
    required this.id,
    required this.commentId,
    required this.content,
    required this.replyDate,
    required this.user,
    required this.likes,
    required this.isLiked,
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    return ReplyModel(
      id: json[ApiKey.id],
      commentId: json[ApiKey.commentId],
      content: json[ApiKey.content],
      replyDate: json[ApiKey.replyDate],
      likes: json[ApiKey.likes],
      isLiked: json['is_liked'],
      user: CommentUserModel.fromJson(json['replier']),
    );
  }

  ReplyModel copyWith({
    int? id,
    dynamic commentId,
    String? content,
    String? replyDate,
    int? likes,
    bool? isLiked,
    CommentUserModel? user,
  }) {
    return ReplyModel(
      id: id ?? this.id,
      commentId: commentId ?? this.commentId,
      content: content ?? this.content,
      replyDate: replyDate ?? this.replyDate,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      user: user ?? this.user,
    );
  }
}