// features/courses/presentation/cubit/episode_detail_cubit.dart
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:learning_management_system/features/courses/data/models/episode_response_model.dart';
import 'package:learning_management_system/features/courses/data/repositories/episodes_repository.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episodes_details_state.dart';

class EpisodeDetailCubit extends Cubit<EpisodeDetailState> {
  final EpisodesRepository repository;
  final bool isStudent;
  int? episodeId;
  double _progress = 0.0;

  EpisodeModel ?episode;

  Uint8List? poster;
  Stream<Uint8List>? videoStream;

  EpisodeDetailCubit({
    required this.repository,
    required this.isStudent,
  }) : super(EpisodeDetailInitial());

  double get progress => _progress;
  
  void updateProgress(double progress) {
    _progress = progress;
  }

  void checkCompletion(int episodeId) {
    if (_progress >= 0.5) {
      finishEpisode(episodeId);
    }
  }

  void reset() {
    episodeId = null;
    videoStream = null;
    poster = null;
    emit(EpisodeDetailInitial());
  }
  Future<void> loadEpisodeMedia(int id,bool newVideo,bool isCopy) async {
    if(!newVideo)
    {final posterResult = await repository.getEpisodePoster(id,isCopy);
    posterResult.fold(
      (failure) => emit(EpisodeDetailError(failure.errMessage)),
      (data) {
        poster = data;
        emit(EpisodeDetailLoadVideoOrPoster());
      }
    );}
    final videoResult =  await repository.getEpisodeVideo(id,isCopy);
    videoResult.fold(
      (failure) => emit(EpisodeDetailError(failure.errMessage)),
      (stream) {
        videoStream = stream;
        emit(EpisodeDetailLoadVideoOrPoster());
      }
    );
  }

  Future<void> getEpisode(int id) async {
    episodeId = id;
    emit(EpisodeDetailLoading());
    final result = await repository.showEpisode(isStudent, id);
    result.fold(
      (failure) => emit(EpisodeDetailError(failure.errMessage)),
      (episode) => emit(EpisodeDetailLoaded(episode)),
    );
  }

  Future<void> finishEpisode(int episodeId) async {
    //if(episode!.isWatched!= null)
      if (!episode!.isWatched !) {
        final result = await repository.finishEpisode(episodeId);
        result.fold(
          (failure) {
            emit(EpisodeDetailError(failure.errMessage));
          },
          (_){
          emit(EpisodeDetailLoaded(
          episode!.copyWith(isWatched: true,views: episode!.views+1),
        ));
          }
        );
      }
  }
  Future<void> toggleLike(int episodeId, bool isLiked) async {
    final result = isLiked
        ? await repository.removeLikeFromEpisode(episodeId)
        : await repository.addLikeToEpisode(episodeId);

    result.fold(
      (failure) {
        emit(EpisodeDetailError(failure.errMessage));
      },
      (_) {
        emit(EpisodeDetailLoaded(
        episode!.copyWith(
          isLiked: !isLiked,
          likes: isLiked 
              ? episode!.likes - 1 
              : episode!.likes + 1,
        ),
      ));
      }
    );
  }
}


