// features/skills/presentation/cubit/skill_state.dart
abstract class GetSkillsState {}

class SkillInitial extends GetSkillsState {}

class SkillLoading extends GetSkillsState {}

class SkillLoaded extends GetSkillsState {}

class SkillFailure extends GetSkillsState {
  final String errMessage;
  SkillFailure({required this.errMessage});
}

class SkillSelectionChanged extends GetSkillsState {}
class SkillsListUpdated extends GetSkillsState {}