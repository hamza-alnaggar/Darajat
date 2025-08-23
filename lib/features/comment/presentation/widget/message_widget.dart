import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/comment/data/models/comment_model.dart';
import 'package:learning_management_system/features/comment/data/models/reply_model.dart';
import 'package:learning_management_system/features/comment/data/repositories/reply_repository.dart';
import 'package:learning_management_system/features/comment/presentation/cubit/reply_cubit.dart';

class CommentItem extends StatefulWidget {
  final CommentModel comment;
  final int episodeId;

  const CommentItem({
    Key? key,
    required this.comment,
    required this.episodeId,
  }) : super(key: key);

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool _showReplies = false;
  final TextEditingController _replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                    backgroundColor: Colors.grey.shade200,
                  child: Text(
                    widget.comment.user.fullName[0],
                    style:  TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.comment.user.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                            Text(
                              widget.comment.commentDate,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),)
                        ],
                      ),
                      const SizedBox(height: 6),
                        Text(
                          widget.comment.content,
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildActionButton(
                              icon: 
                              Icons.favorite_border,
                              label: widget.comment.likes.toString(),
                              color:  Colors.red
                            ),
                            const SizedBox(width: 20),
                            _buildActionButton(
                              icon: Icons.reply,
                              label: 'Reply',
                              color: Colors.grey.shade600,
                              onPressed: (){
                              }
                            ),
                            const Spacer(),
                              IconButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.grey.shade600,
                                  size: 20,
                                ),
                                onPressed: (){

                                },
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
            
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () => setState(() => _showReplies = !_showReplies),
                  child: Text(
                    '${widget.comment.numOfReplies} replies',
                    style: TextStyle(color:CustomColors.textSecondary),
                  ),
                ),
              ],
            ),
            if (_showReplies) _buildRepliesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: color),
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 13,
        ),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }


  Widget _buildRepliesSection() {
    return BlocProvider(
      create: (context) => ReplyCubit(
        repository: context.read<ReplyRepository>(), // Fix: Specify type
        commentId: widget.comment.id,
      )..getReplies(),
      child: Column(
        children: [
          BlocBuilder<ReplyCubit, ReplyState>(
            builder: (context, state) {
              if (state is ReplyLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ReplyFailure) {
                return Text('Error: ${state.errMessage}');
              } else if (state is RepliesLoaded) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.replies.length,
                  itemBuilder: (context, index) {
                    return ReplyItem(reply: state.replies[index]);
                  },
                );
              }
              return Container();
            },
          ),
          _buildReplyInput(),
        ],
      ),
    );
  }

  Widget _buildReplyInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _replyController,
              decoration: InputDecoration(
                hintText: 'Write a reply...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (_replyController.text.trim().isNotEmpty) {
                final cubit = context.read<ReplyCubit>();
                cubit.addReply(_replyController.text.trim());
                _replyController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}

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