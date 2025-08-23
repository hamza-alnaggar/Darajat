class Message {
  final int id;
  final String content;
  final String username;
  final String userId;
  final DateTime date;
  final int likes;
  final bool isLiked;
  final List<Message> replies;
  final Message? replyTo;

  const Message({
    required this.id,
    required this.content,
    required this.username,
    required this.userId,
    required this.date,
    this.likes = 0,
    this.isLiked = false,
    this.replies = const [],
    this.replyTo,
  });

  Message copyWith({
    int? id,
    String? content,
    String? username,
    String? userId,
    DateTime? date,
    int? likes,
    bool? isLiked,
    List<Message>? replies,
    Message? replyTo,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      username: username ?? this.username,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      replies: replies ?? this.replies,
      replyTo: replyTo ?? this.replyTo,
    );
  }
}