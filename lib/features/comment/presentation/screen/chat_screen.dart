import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/di/dependency_injection.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_bar.dart';
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
      appBar: CustomAppBar(
        title: 
          'Comments',
      
      ),
      body: BlocProvider(
        create: (context) =>
            CommentCubit(repository: sl<CommentRepository>())..getInitialComments(postId),
        child: CommentList(postId: postId),
      ),
    );
  }
}

class CommentList extends StatefulWidget {
  final int postId;
  const CommentList({super.key, required this.postId});

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  final ScrollController _scrollController = ScrollController();
  int _prevCommentsCount = 0;
  bool _isLoadingMoreTriggered = false;

  // NEW: track whether initial comments load finished (so we DON'T auto-scroll on first load)
  bool _initialCommentsLoaded = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final cubit = context.read<CommentCubit>();
    final meta = cubit.state.meta;
    // trigger load when near bottom
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        meta?.hasMorePages == true &&
        !_isLoadingMoreTriggered) {
      _isLoadingMoreTriggered = true;
      cubit.loadMoreComments(widget.postId);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _animateToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommentCubit, CommentState>(
      listener: (context, state) {
        // Reset loading-more trigger flags when loading/loaded/error finishes
        if (state is CommentLoaded ||
            state is CommentLoadMoreError ||
            state is CommentFailure ||
            state is CommentOperationSuccess ||
            state is CommentOperationInProgress) {
          _isLoadingMoreTriggered = false;
        }

        // If this is the first CommentLoaded we mark initial load complete but DO NOT scroll
        if (state is CommentLoaded) {
          if (!_initialCommentsLoaded) {
            _initialCommentsLoaded = true;
            // set prev count to avoid detection of "new" items equal to initial
            _prevCommentsCount = state.comments.length;
            return; // do not scroll on initial arrival
          }

          // If the cubit provided an explicit success message for added comment, scroll
          // (your CommentCubit adds message: 'Comment added successfully' after addComment)
          if (state.message != null && state.message == 'Comment added successfully') {
            // animate to bottom because a new comment was added by user
            _animateToBottom();
            // update prev count
            _prevCommentsCount = state.comments.length;
            return;
          }

          // For other CommentLoaded events (like loadMore), we DO NOT auto-scroll.
          // However, if you want auto-scroll when comments count grows for other reasons,
          // you could add additional logic here (currently intentionally conservative).
          _prevCommentsCount = state.comments.length;
        }
      },
      child: BlocBuilder<CommentCubit, CommentState>(
        builder: (context, state) {
          if ((state is CommentInitial || state is CommentLoading) && state.comments.isEmpty) {
            return const Center(child: CircularProgressIndicator(strokeWidth: 2.0));
          }

          if (state is CommentFailure && state.comments.isEmpty) {
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
          }

          final comments = state.comments;
          final meta = state.meta;

          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          // oldest at index 0, newest at the end
                          return CommentItem(comment: comments[index]);
                        },
                        childCount: comments.length,
                      ),
                    ),

                    // Bottom loading indicator when there are more pages
                    if (meta?.hasMorePages == true)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Center(
                            child: Builder(builder: (context) {
                              if (state is CommentLoadingMore) {
                                return SizedBox(
                                  height: 48.h,
                                  width: 48.h,
                                  child: const CircularProgressIndicator(strokeWidth: 2.0),
                                );
                              } else {
                                // keep a small spacer so user can scroll to trigger load
                                return SizedBox(height: 48.h);
                              }
                            }),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              AddCommentField(postId: widget.postId),
            ],
          );
        },
      ),
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

  void _handleLikeComment() {
    if (widget.comment.isLiked) {
      context.read<CommentCubit>().removeLikeComment(widget.comment.id);
    } else {
      context.read<CommentCubit>().addLikeComment(widget.comment.id);
    }
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
                                  Center(child: Text(widget.comment.user.fullName[0])),
                            )
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
                  if (widget.comment.isMyComment)
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
                      icon: widget.comment.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: widget.comment.isLiked ? Colors.red : null,
                      count: widget.comment.likes,
                      onPressed: _handleLikeComment,
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
                ReplyList(), // not const
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

class ReplyList extends StatefulWidget {
  const ReplyList({super.key});

  @override
  State<ReplyList> createState() => _ReplyListState();
}

class _ReplyListState extends State<ReplyList> {
  final ScrollController _replyScrollController = ScrollController();
  int _prevRepliesCount = 0;

  // NEW: track whether initial replies load finished (so we DON'T auto-scroll on first replies load)
  bool _initialRepliesLoaded = false;

  @override
  void dispose() {
    _replyScrollController.dispose();
    super.dispose();
  }

  void _animateReplyListToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_replyScrollController.hasClients) {
        _replyScrollController.animateTo(
          _replyScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReplyCubit, ReplyState>(
      listener: (context, state) {
        if (state is RepliesLoaded) {
          final replies = state.replies;
          if (!_initialRepliesLoaded) {
            // mark initial load done and sync prev count — do not scroll
            _initialRepliesLoaded = true;
            _prevRepliesCount = replies.length;
            return;
          }

          // after initial load: if replies increased, animate to bottom
          final curCount = replies.length;
          if (curCount > _prevRepliesCount) {
            _prevRepliesCount = curCount;
            _animateReplyListToBottom();
          } else {
            _prevRepliesCount = curCount;
          }
        } else if (state is ReplyOperationInProgress) {
          // keep state consistent; we won't scroll on operation in progress itself
        } else if (state is ReplyFailure) {
          // do nothing special here
        }
      },
      child: BlocBuilder<ReplyCubit, ReplyState>(
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

            return ListView.builder(
              controller: _replyScrollController,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: replies.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: ReplyItem(reply: replies[index]),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
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

  void _handleLikeReply() {
    if (widget.reply.isLiked) {
      context.read<ReplyCubit>().removeLikeReply(widget.reply.id);
    } else {
      context.read<ReplyCubit>().addLikeReply(widget.reply.id);
    }
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
                              Center(child: Text(widget.reply.user.fullName[0])),
                        )
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
              if(widget.reply.isMyReply!)
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
                  icon: widget.reply.isLiked ? Icons.favorite : Icons.favorite_border,
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
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
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
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
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
                    child: Icon(Icons.send, color: Theme.of(context).hintColor, size: 20.r),
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
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
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
                    child: Icon(Icons.send, color: Theme.of(context).hintColor, size: 18.r),
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
