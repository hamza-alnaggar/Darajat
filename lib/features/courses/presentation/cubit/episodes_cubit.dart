import 'package:bloc/bloc.dart';
import 'package:learning_management_system/features/courses/data/repositories/episodes_repository.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episode_list_state.dart';


class EpisodesListCubit extends Cubit<EpisodesListState> {
  final EpisodesRepository repository;
  final bool isStudent;

  EpisodesListCubit({
    required this.repository,
    required this.isStudent,
  }) : super(EpisodesListInitial());

  Future<void> getEpisodes(int courseId,bool isCopy,bool isStudent) async {
    emit(EpisodesListLoading());
    final result = await repository.getEpisodes(isStudent,isCopy,courseId);
    result.fold(
      (failure) => emit(EpisodesListError(failure.errMessage)),
      (response) => emit(EpisodesListLoaded(response)),
    );
  }
}