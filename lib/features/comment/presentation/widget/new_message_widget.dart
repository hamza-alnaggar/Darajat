import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/comment/presentation/cubit/reply_cubit.dart';

class ReplyCubitProvider extends StatelessWidget {
  final int commentId;
  final Widget child;

  const ReplyCubitProvider({
    Key? key,
    required this.commentId,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReplyCubit(
        repository: context.read(),
        commentId: commentId,
      ),
      child: child,
    );
  }
}