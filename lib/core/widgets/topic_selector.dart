import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/features/courses/data/models/topic_response_model.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/topic_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/topic_state.dart';

class TopicSelector extends StatelessWidget {
  final Function(TopicModel) onTopicSelected;

  const TopicSelector({super.key, required this.onTopicSelected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopicCubit, TopicState>(
      builder: (context, state) {
        final cubit = context.read<TopicCubit>();
        final selectedTopic = cubit.selectedTopic;
        final topics = cubit.topicList;

        if (state is TopicLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is TopicFailure) {
          return Container(
            padding: EdgeInsets.all(16.w),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 10.w),
                Expanded(child: Text('Error: ${state.errMessage}')),
              ],
            ),
          );
        }

        if (topics.isEmpty) {
          return  Center(child: Text('No topics available for this category'));
        
        }

        return SizedBox(
          height: 60.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: topics.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final topic = topics[index];
              final isSelected = selectedTopic?.id == topic.id;
              
              return ChoiceChip(
                label: Text(topic.title),
                selected: isSelected,
                onSelected: (selected) {
                  cubit.selectTopic(topic);
                  onTopicSelected(topic);
                },
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Theme.of(context).primaryColor,
                ),
                selectedColor: Theme.of(context).primaryColor,
                backgroundColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              );
            },
          ),
        );
      },
    );
  }
}