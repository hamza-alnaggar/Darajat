import 'package:learning_management_system/core/databases/api/end_points.dart';

class CommentModel {
  final int id;
  final String content;
  final int numOfReplies;
  final String commentDate;
  final int likes;
  final bool isLiked;
  final CommentUserModel user;

  CommentModel({
    required this.id,
    required this.content,
    required this.numOfReplies,
    required this.commentDate,
    required this.isLiked,
    required this.likes,
    required this.user,
  });
  CommentModel copyWith({
    int ?id,
String ?content,
int ?numOfReplies,
String ?commentDate,
int ?likes,
bool ?isLiked,
CommentUserModel ?user
  }) {
    return CommentModel(
      id: id ?? this.id,
      content: content ?? this.content,
      numOfReplies: numOfReplies ?? this.numOfReplies,
      commentDate: commentDate ?? this.commentDate,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      user: user?? this.user
    );
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json[ApiKey.id],
      content: json[ApiKey.content],
      numOfReplies: json[ApiKey.numOfReplies],
      commentDate: json[ApiKey.commentDate],
      likes: json[ApiKey.likes],
      isLiked: json['is_liked'],
      user: CommentUserModel.fromJson(json['commenter']),
    );
  }
}

class CommentUserModel {
  final int id;
  final String fullName;
  final String? profileImageUrl;

  CommentUserModel({
    required this.id,
    required this.fullName,
    this.profileImageUrl,
  });

  factory CommentUserModel.fromJson(Map<String, dynamic> json) {
    return CommentUserModel(
      id: json[ApiKey.id],
      fullName: json[ApiKey.fullName],
      profileImageUrl: json[ApiKey.profileImageUrl],
    );
  }
}