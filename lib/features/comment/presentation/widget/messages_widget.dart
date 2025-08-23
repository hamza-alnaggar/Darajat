import 'package:flutter/material.dart';
import 'package:learning_management_system/features/comment/data/models/reply_model.dart';

class ReplyItem extends StatelessWidget {
  final ReplyModel reply;

  const ReplyItem({Key? key, required this.reply}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, top: 8.0),
      child: Card(
        color: Colors.grey[100],
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: Text(
                      reply.user.fullName[0],
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reply.user.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          reply.replyDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
                  Text(reply.likes.toString()),
                ],
              ),
              const SizedBox(height: 8),
              Text(reply.content),
            ],
          ),
        ),
      ),
    );
  }
}