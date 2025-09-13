// features/education/presentation/cubit/education_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/student/job_titles/data/repository/get_job_title_repository.dart';
import 'package:learning_management_system/features/student/job_titles/presentation/cubit/job_title_state.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/country_sub_model.dart';

class JobTitleCubit extends Cubit<JobTitleState> {
  final GetJobTitleRepository repository;
  List<CountryOrLanguageSubModel> jobTitles = [];
  CountryOrLanguageSubModel? selectedJobTitle;

  JobTitleCubit(this.repository) : super(JobTitleInitial());

  Future<void> eitherFailureOrJobTitle() async {
    emit(JobTitleLoading());
    final result = await repository.getJobTitle();
    result.fold(
      (failure) => emit(JobTitleFailure(errMessage: failure.errMessage)),
      (response) {
        jobTitles = response.list;
        emit(JobTitleLoaded());
      },
    );
  }

  void selectJobTitle(CountryOrLanguageSubModel jobTitle) {
    selectedJobTitle = jobTitle;
    emit(JobTitleSelectionChanged());
  }

}