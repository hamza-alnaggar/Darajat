import 'package:learning_management_system/core/databases/api/end_points.dart';

class ErrorModel {
  final String errMessage;

  ErrorModel({ required this.errMessage });

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    final dynamic raw = json[ApiKey.message];

    if (raw == null) {
      // No message at all
      return ErrorModel(errMessage: 'Unknown error');
    }

    if (raw is String) {
      // Simple string message
      return ErrorModel(errMessage: raw);
    }

    if (raw is Map<String, dynamic>) {
      final formatted = raw.entries.map((entry) {
        final List<String> messages =
            (entry.value as List<dynamic>).map((e) => e.toString()).toList();
        return '${entry.key}: ${messages.join(', ')}';
      }).join('\n');
      return ErrorModel(errMessage: formatted);
    }

    // Fallback if it's some other unexpected type
    return ErrorModel(errMessage: raw.toString());
  }
}
