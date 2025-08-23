// comment_response_model.dart
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/comment/data/models/comment_model.dart';
import 'package:learning_management_system/features/comment/data/models/meta_model.dart';

class CommentResponseModel {
  final List<CommentModel> comments;
  final MetaModel meta;
  final String message;

  CommentResponseModel({
    required this.comments,
    required this.meta,
    required this.message,
  });

  factory CommentResponseModel.fromJson(Map<String, dynamic> json) {
    return CommentResponseModel(
      comments: (json[ApiKey.data] as List)
          .map((e) => CommentModel.fromJson(e))
          .toList(),
      meta: MetaModel.fromJson(json[ApiKey.meta]),
      message: json[ApiKey.message],
    );
  }
}

