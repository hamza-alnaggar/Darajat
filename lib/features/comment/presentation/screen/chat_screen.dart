import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/di/dependency_injection.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/comment/data/models/comment_model.dart';
import 'package:learning_management_system/features/comment/data/models/reply_model.dart';
import 'package:learning_management_system/features/comment/data/repositories/comment_repository.dart';
import 'package:learning_management_system/features/comment/data/repositories/reply_repository.dart';
import 'package:learning_management_system/features/comment/presentation/cubit/comment_cubit.dart';
import 'package:learning_management_system/features/comment/presentation/cubit/comment_state.dart';
import 'package:learning_management_system/features/comment/presentation/cubit/reply_cubit.dart';

class CommentsScreen extends StatelessWidget {
  final int postId;

  const CommentsScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Comments',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24.r),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocProvider(
        create: (context) =>
            CommentCubit(repository: sl<CommentRepository>())
              ..getInitialComments(postId),
        child: const CommentList(),
      ),
    );
  }
}

class CommentList extends StatelessWidget {
  const CommentList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentCubit, CommentState>(
      builder: (context, state) {
        if (state is CommentInitial || state is CommentLoading) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          );
        } else if (state is CommentFailure) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Text(
                'Error: ${state.errMessage}',
                style: TextStyle(fontSize: 16.sp, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (state is CommentLoaded ||
            state is CommentOperationInProgress ||
            state is CommentOperationSuccess) {
          final comments = state.comments;
          final meta = state.meta;

          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return CommentItem(comment: comments[index]);
                        },
                        childCount: comments.length,
                      ),
                    ),
                    if (meta?.hasMorePages == true)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () =>
                                  context.read<CommentCubit>().loadMoreComments(1),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.primary2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24.w, vertical: 12.h),
                              ),
                              child: Text(
                                'Load More',
                                style: TextStyle(
                                    fontSize: 15.sp, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              AddCommentField(postId: 1),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class CommentItem extends StatefulWidget {
  final CommentModel comment;

  const CommentItem({super.key, required this.comment});

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {

    void _handleLikeComment() {
    if (widget.comment.isLiked) {
      context.read<CommentCubit>().removeLikeComment(widget.comment.id);
    } else {
      context.read<CommentCubit>().addLikeComment(widget.comment.id);
    }
  }
  bool _showReplies = false;
  bool _isEditing = false;
  final _editController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editController.text = widget.comment.content;
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  void _showEditDeleteMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: CustomColors.primary2),
              title: Text('Edit', style: TextStyle(fontSize: 16.sp)),
              onTap: () {
                Navigator.pop(context);
                setState(() => _isEditing = true);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete', style: TextStyle(fontSize: 16.sp, color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context);
              },
            ),
            SizedBox(height: 8.h),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(fontSize: 16.sp)),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final commentCubit = context.read<CommentCubit>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Comment', style: TextStyle(fontSize: 20.sp)),
        content: Text('Are you sure you want to delete this comment?', style: TextStyle(fontSize: 16.sp)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text('Cancel', style: TextStyle(fontSize: 16.sp)),
          ),
          TextButton(
            onPressed: () {
              commentCubit.deleteComment(widget.comment.id);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(fontSize: 16.sp, color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocProvider(
      create: (context) => ReplyCubit(
        repository: sl<ReplyRepository>(),
        commentId: widget.comment.id,
      )..getReplies(),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Comment Header
              Row(
                children: [
                  Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: CustomColors.primary2, width: 1.5),
                    ),
                    child: ClipOval(
                      child: widget.comment.user.profileImageUrl != null
                          ? Image.network(
                              widget.comment.user.profileImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => 
                                  Center(child: Text(widget.comment.user.fullName[0])))
                          : Center(
                              child: Text(
                                widget.comment.user.fullName[0],
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.primary2,
                                ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.comment.user.fullName,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          widget.comment.commentDate,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(widget.comment.isLiked)
                  IconButton(
                    icon: Icon(Icons.more_vert, size: 22.r),
                    onPressed: () => _showEditDeleteMenu(context),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              
              if (_isEditing) ...[
                TextField(
                  controller: _editController,
                  maxLines: 3,
                  minLines: 1,
                  autofocus: true,
                  style: TextStyle(fontSize: 16.sp),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(16.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: CustomColors.primary2),
                    ),
                    suffixIcon: Container(
                      margin: EdgeInsets.only(right: 8.w),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.close, size: 22.r),
                            onPressed: () => setState(() => _isEditing = false),
                          ),
                          SizedBox(width: 4.w),
                          IconButton(
                            icon: Icon(Icons.check, 
                                size: 22.r, color: CustomColors.primary2),
                            onPressed: () {
                              context.read<CommentCubit>().updateComment(
                                widget.comment.id,
                                _editController.text,
                              );
                              setState(() => _isEditing = false);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ] else ...[
                Text(
                  widget.comment.content,
                  style: TextStyle(fontSize: 16.sp),
                ),
                SizedBox(height: 16.h),
                // Comment Actions
                Row(
                  children: [
                    _buildActionButton(
                      icon:  widget.comment.isLiked 
                          ? Icons.favorite 
                          : Icons.favorite_border,
                      color: widget.comment.isLiked ? Colors.red : null,
                      count: widget.comment.likes,
                      onPressed: _handleLikeComment, // Add like functionality
                    ),
                    SizedBox(width: 16.w),
                    _buildActionButton(
                      icon: Icons.reply,
                      count: widget.comment.numOfReplies,
                      onPressed: () => setState(() => _showReplies = !_showReplies),
                    ),
                  ],
                ),
              ],
              if (_showReplies) ...[
                SizedBox(height: 16.h),
                const ReplyList(),
                SizedBox(height: 16.h),
                AddReplyField(commentId: widget.comment.id),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
 Widget _buildActionButton({
    required IconData icon, 
    required int count, 
    required VoidCallback onPressed,
    Color? color,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18.r, color: color),
            SizedBox(width: 4.w),
            Text(
              count.toString(),
              style: TextStyle(fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }
}
class ReplyList extends StatelessWidget {
  const ReplyList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReplyCubit, ReplyState>(
      builder: (context, state) {
        if (state is ReplyInitial || state is ReplyLoading) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: CircularProgressIndicator(strokeWidth: 2.0),
            ),
          );
        } else if (state is ReplyFailure) {
          return Text(
            'Error: ${state.errMessage}',
            style: TextStyle(color: Colors.red, fontSize: 14.sp),
          );
        } else if (state is RepliesLoaded || state is ReplyOperationInProgress) {
          final replies = (state as dynamic).replies ?? [];

          return Column(
            children: [
              for (final reply in replies)
                Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: ReplyItem(reply: reply),
                )
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class ReplyItem extends StatefulWidget {
  final ReplyModel reply;

  const ReplyItem({super.key, required this.reply});

  @override
  State<ReplyItem> createState() => _ReplyItemState();
}

class _ReplyItemState extends State<ReplyItem> {
  bool _isEditing = false;
  final _editController = TextEditingController();

    void _handleLikeReply() {
    if (widget.reply.isLiked) {
      context.read<ReplyCubit>().removeLikeReply(widget.reply.id);
    } else {
      context.read<ReplyCubit>().addLikeReply(widget.reply.id);
    }
  }

  @override
  void initState() {
    super.initState();
    _editController.text = widget.reply.content;
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  void _showEditDeleteMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: CustomColors.primary2),
              title: Text('Edit', style: TextStyle(fontSize: 16.sp)),
              onTap: () {
                Navigator.pop(context);
                setState(() => _isEditing = true);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete', style: TextStyle(fontSize: 16.sp, color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context);
              },
            ),
            SizedBox(height: 8.h),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(fontSize: 16.sp)),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final replyCubit = context.read<ReplyCubit>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Reply', style: TextStyle(fontSize: 20.sp)),
        content: Text('Are you sure you want to delete this reply?', style: TextStyle(fontSize: 16.sp)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text('Cancel', style: TextStyle(fontSize: 16.sp)),
          ),
          TextButton(
            onPressed: () {
              replyCubit.deleteReply(widget.reply.id);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(fontSize: 16.sp, color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: CustomColors.primary2, width: 1),
                ),
                child: ClipOval(
                  child: widget.reply.user.profileImageUrl != null
                      ? Image.network(
                          widget.reply.user.profileImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                              Center(child: Text(widget.reply.user.fullName[0])))
                      : Center(
                          child: Text(
                            widget.reply.user.fullName[0],
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.primary2,
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.reply.user.fullName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      widget.reply.replyDate,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.more_vert, size: 20.r),
                onPressed: () => _showEditDeleteMenu(context),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          if (_isEditing) ...[
            TextField(
              controller: _editController,
              maxLines: 2,
              minLines: 1,
              autofocus: true,
              style: TextStyle(fontSize: 14.sp),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12.w),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: CustomColors.primary2),
                ),
                suffixIcon: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, size: 20.r),
                        onPressed: () => setState(() => _isEditing = false),
                      ),
                      SizedBox(width: 4.w),
                      IconButton(
                        icon: Icon(Icons.check, 
                            size: 20.r, color: CustomColors.primary2),
                        onPressed: () {
                          context.read<ReplyCubit>().updateReply(
                            widget.reply.id,
                            _editController.text,
                          );
                          setState(() => _isEditing = false);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ] else ...[
            Text(
              widget.reply.content,
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                _buildActionButton(
                  icon: widget.reply.isLiked 
                      ? Icons.favorite 
                      : Icons.favorite_border,
                  count: widget.reply.likes,
                  onPressed: _handleLikeReply,
                  color: widget.reply.isLiked ? Colors.red : null,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildActionButton({
    required IconData icon, 
    required int count, 
    required VoidCallback onPressed,
    Color? color,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16.r, color: color),
            SizedBox(width: 4.w),
            Text(
              count.toString(),
              style: TextStyle(fontSize: 13.sp),
            ),
          ],
        ),
      ),
    );
  }
}

class AddCommentField extends StatefulWidget {
  final int postId;

  const AddCommentField({super.key, required this.postId});

  @override
  State<AddCommentField> createState() => _AddCommentFieldState();
}

class _AddCommentFieldState extends State<AddCommentField> {
  final _controller = TextEditingController();
  bool _isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor))),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (value) => setState(() => _isTyping = value.isNotEmpty),
              maxLines: 3,
              minLines: 1,
              style: TextStyle(fontSize: 16.sp),
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 14.h,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _isTyping
                ? CircleAvatar(
                    backgroundColor: CustomColors.primary2,
                    radius: 24.r,
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white, size: 20.r),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          context.read<CommentCubit>().addComment(
                            widget.postId,
                            _controller.text,
                          );
                          _controller.clear();
                          setState(() => _isTyping = false);
                        }
                      },
                    ),
                  )
                : CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    radius: 24.r,
                    child: Icon(
                      Icons.send,
                      color: Theme.of(context).hintColor,
                      size: 20.r,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AddReplyField extends StatefulWidget {
  final int commentId;

  const AddReplyField({super.key, required this.commentId});

  @override
  State<AddReplyField> createState() => _AddReplyFieldState();
}

class _AddReplyFieldState extends State<AddReplyField> {
  final _controller = TextEditingController();
  bool _isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16.w),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (value) => setState(() => _isTyping = value.isNotEmpty),
              maxLines: 2,
              minLines: 1,
              style: TextStyle(fontSize: 15.sp),
              decoration: InputDecoration(
                hintText: 'Add a reply...',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 12.h,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _isTyping
                ? CircleAvatar(
                    backgroundColor: CustomColors.primary2,
                    radius: 22.r,
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white, size: 18.r),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          context.read<ReplyCubit>().addReply(_controller.text);
                          _controller.clear();
                          setState(() => _isTyping = false);
                        }
                      },
                    ),
                  )
                : CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    radius: 22.r,
                    child: Icon(
                      Icons.send,
                      color: Theme.of(context).hintColor,
                      size: 18.r,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}