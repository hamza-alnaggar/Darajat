// features/education/presentation/cubit/education_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/student/educations/data/repository/get_educations_repository.dart';
import 'package:learning_management_system/features/student/educations/presentation/cubit/get_educations_state.dart';

class GetEducationsCubit extends Cubit<GetEducationsState> {
  final GetEducationsRepository repository;
  List<String> educations = [];
  String? selectedEducation;

  GetEducationsCubit(this.repository) : super(EducationInitial());

  Future<void> eitherFailureOrGetEducations() async {
    emit(EducationLoading());
    final result = await repository.getEducations();
    result.fold(
      (failure) => emit(EducationFailure(errMessage: failure.errMessage)),
      (response) {
        educations = response.educations;
        emit(EducationLoaded());
      },
    );
  }
  void setInitialEducation(String education) {
  selectedEducation = education;
  emit(EducationLoaded());
}

  void selectEducation(String education) {
    selectedEducation = education;
    emit(EducationSelectionChanged());
  }
}