// features/skills/presentation/cubit/skill_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/student/skills/data/models/sub_models/skills_sub_models.dart';
import 'package:learning_management_system/features/student/skills/data/repository/get_skills_repository.dart';
import 'package:learning_management_system/features/student/skills/presentation/cubit/get_skills_state.dart';

class GetSkillsCubit extends Cubit<GetSkillsState> {
  final GetSkillsRepository repository;
  List<SkillSubModel> allSkills = [];
  List<SkillSubModel> availableSkills = [];
  SkillSubModel? selectedSkill;

  GetSkillsCubit(this.repository) : super(SkillInitial());

  Future<void> eitherFailureOrGetSkills() async {
    emit(SkillLoading());
    final result = await repository.getSkills();
    result.fold(
      (failure) => emit(SkillFailure(errMessage: failure.errMessage)),
      (response) {
        allSkills = response.skills;
        availableSkills = allSkills; 
        emit(SkillLoaded());
      },
    );
  }

  void updateAvailableSkills(List<SkillSubModel> userSkills) {
    availableSkills = allSkills.where(
      (skill) => !userSkills.any((userSkill) => userSkill.id == skill.id)
    ).toList();
    emit(SkillsListUpdated()); 
  }

  void selectSkill(SkillSubModel? skill) {
    selectedSkill = skill;
    emit(SkillSelectionChanged());
  }
}