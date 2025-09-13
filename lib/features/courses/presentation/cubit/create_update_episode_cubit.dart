import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/courses/data/models/create_episode_body_model.dart';
import 'package:learning_management_system/features/courses/data/repositories/create_update_episode_repository.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/create_episode_state.dart';

class CreateUpdateEpisodeCubit extends Cubit<EpisodeState> {
  final CreateUpdateEpisodeRepository repository;

  CreateUpdateEpisodeCubit({required this.repository}) : super(EpisodeInitial());

  Future<void> createEpisode({
    required int courseId,
    required CreateEpisodeBodyModel request,
    required bool isCopy,

  }) async {
    try {
      emit(EpisodeLoading());
      
      final response = await repository.createEpisode(
        courseId: courseId,
        request: request,
        isCopy:isCopy
      );

      response.fold(
        (failure) => emit(EpisodeFailure(errMessage: failure.errMessage)),
        (data) { emit(EpisodeSuccess(
          message: data
        ));
        },
      );
    } catch (e) {
      emit(EpisodeFailure(errMessage: e.toString()));
    }
  }
  Future<void> updateEpisode({
    required int episodeId,
    required CreateEpisodeBodyModel request,
    required bool  isCopy,
  }) async {
    //try {
      emit(EpisodeLoading());
      
      final response = await repository.updateEpisode(
        episodeId: episodeId,
        request: request,
        isCopy: isCopy,
      );

      response.fold(
        (failure) => emit(EpisodeFailure(errMessage: failure.errMessage)),
        (data) { emit(EpisodeSuccess(
          message: data
        ));
        }
      );
   // }
    //  catch (e) {
    //   emit(EpisodeFailure(errMessage: e.toString()));
    // }
  }

Future<bool> deleteEpisode(int episodeId, bool isCopy) async {
  emit(EpisodeLoading());
  final result = await repository.deleteEpisode(isCopy, episodeId);

  return result.fold(
    (failure) {
      emit(EpisodeFailure(errMessage: failure.errMessage));
      return false;
    },
    (message) {
      emit(EpisodeSuccess(message: message));
      return true;
    },
  );
}
// inside CreateUpdateEpisodeCubit

Future<bool> deleteEpisodeFile(int episodeId, bool isCopy) async {
  try {
  emit(EpisodeLoading());
  final result = await repository.deleteFile( episodeId,isCopy); 
  return result.fold(
    (failure) {
      emit(EpisodeFailure(errMessage: failure.errMessage));
      return false;
    },
    (message) {
      emit(EpisodeSuccess(message: message));
      return true;
    },
  );
  } catch (e) {
  emit(EpisodeFailure(errMessage: e.toString()));
  return false;
  }
}

}
