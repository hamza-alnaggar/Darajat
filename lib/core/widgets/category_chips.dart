import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/features/courses/data/models/category_response_model.dart';
import 'package:learning_management_system/features/courses/data/models/topic_response_model.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/category_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/category_state.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/course_search_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryChips extends StatefulWidget {
  const CategoryChips({super.key});

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<CategoryCubit>()..getAllCategories();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategorySuccess) {
          return ChipsCategoryWidget(categories: state.categories);
        } else if (state is CategoryLoading) {
          return Skeletonizer(  // Skeleton for loading state
            enabled: true,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(5, (index) => Chip(
                label: const Text('Loading category'),
                avatar: CircleAvatar(backgroundColor: Colors.transparent),
              )),
            ),
          );
        } else if (state is CategoryFailure) {
          return Text(' ${state.errMessage}');
        }
        return Container();
      },
    );
  }
}

class ChipsCategoryWidget extends StatelessWidget {
  const ChipsCategoryWidget({super.key, required this.categories});

  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context).textTheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          categories.take(5).map((category) {
            return GestureDetector(
              onTap: () {
                context.pushNamed(
                  Routes.coursesByCategoryOrTopicScreen,
                  arguments: category.id.toString(),
                );
              },
              child: Chip(
                label: Text(category.title,style: theme.headlineSmall,),
                avatar: CircleAvatar(
                  radius: 40.r,
                  backgroundImage: NetworkImage(category.imageUrl,),
                ),
                shape: StadiumBorder(
                  side: BorderSide(color: isDark ? Colors.white : Colors.black),
                ),
              ),
            );
          }).toList(),
    );
  }
}

class ChipsTopicWidget extends StatelessWidget {
  const ChipsTopicWidget({super.key, required this.ctx, required this.topics});

  final BuildContext ctx;
  final List<TopicModel> topics;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          topics.map((topic) {
            return GestureDetector(
              onTap: () {
                ctx.read<CourseSearchCubit>().getCoursesByTopic(topic.id.toString());
              },
              child: Chip(
                label: Text(topic.title),
                shape: StadiumBorder(
                  side: BorderSide(color: isDark ? Colors.white : Colors.black),
                ),
              ),
            );
          }).toList(),
    );
  }
}
