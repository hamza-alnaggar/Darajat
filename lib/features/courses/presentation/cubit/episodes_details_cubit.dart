// features/courses/presentation/cubit/episode_detail_cubit.dart
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bloc/bloc.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_management_system/features/courses/data/models/episode_response_model.dart';
import 'package:learning_management_system/features/courses/data/repositories/episodes_repository.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episodes_details_state.dart';
import 'package:learning_management_system/generated/intl/messages_ar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class EpisodeDetailCubit extends Cubit<EpisodeDetailState> {
  final EpisodesRepository repository;
  final bool isStudent;
  int? episodeId;
  double _progress = 0.0;

  EpisodeModel? episode;

  Uint8List? poster;
  Uint8List? file;
  Stream<Uint8List>? videoStream;

  EpisodeDetailCubit({required this.repository, required this.isStudent})
    : super(EpisodeDetailInitial());

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

  Future<void> loadEpisodeMedia(int id, bool newVideo, bool isCopy) async {
    if (!newVideo) {
      final posterResult = await repository.getEpisodePoster(id, isCopy);
      posterResult.fold(
        (failure) => emit(EpisodeDetailError(failure.errMessage)),
        (data) {
          poster = data;
          emit(EpisodeDetailLoadVideoOrPoster());
        },
      );
    }
    final videoResult = await repository.getEpisodeVideo(id, isCopy);
    videoResult.fold(
      (failure) => emit(EpisodeDetailError(failure.errMessage)),
      (stream) {
        videoStream = stream;
        emit(EpisodeDetailLoadVideoOrPoster());
      },
    );
  }

  Future<void> getEpisode(int id) async {
    episodeId = id;
    emit(EpisodeDetailLoading());
    final result = await repository.showEpisode(isStudent, id);
    result.fold((failure) => emit(EpisodeDetailError(failure.errMessage)), (
      ep,
    ) {
      emit(EpisodeDetailLoaded(ep));
      episode = EpisodeModel(
        id: ep.episodeModel.id,
        title: ep.episodeModel.title,
        episodeNumber: ep.episodeModel.episodeNumber,
        duration: ep.episodeModel.duration,
        isLiked: ep.episodeModel.isLiked,
        likes: ep.episodeModel.likes,
        isQuizCompleted: ep.episodeModel.isQuizCompleted,
        isWatched: ep.episodeModel.isWatched,
        views: ep.episodeModel.views,
        quiz: ep.episodeModel.quiz,
      );
    });
  }

  Future<void> downloadFile(int id) async {
   // emit(EpisodeDetailLoading());
    final fileName = '${episode!.title.replaceAll(' ', '_')}.pdf';
    final savePath = await _getDownloadPath(fileName);
    final downloadResult = await repository.downloadFile(id, savePath);
    downloadResult.fold(
      (failure) => emit(EpisodeDetailError(failure.errMessage)),
      (path) {
        emit(EpisodeDetailDownloadSuccess('File downloaded to $path'));
      },
    );
  }

  Future<String> _getDownloadPath(String fileName) async {
    final directory = Directory('/storage/emulated/0/Download'); // 📂 Downloads folder
    return '${directory.path}/$fileName';
  }

  Future<void> finishEpisode(int episodeId) async {
    //if(episode!.isWatched!= null)
    if (!episode!.isWatched!) {
      final result = await repository.finishEpisode(episodeId);
      result.fold(
        (failure) {
          emit(EpisodeDetailError(failure.errMessage));
        },
        (_) {
          emit(EpisodeDetailLoaded(EpisodeResponse(episodeModel: episode!.copyWith(views: episode!.views+1,isWatched: true), message: 'Episode Watched')));
        },
      );
    }
  }

  /// Returns true if the like/unlike request succeeded.
  Future<bool> toggleLike(int episodeId) async {
    final result = await repository.LikeEpisode(episodeId);

    bool success = false;

    result.fold(
      (failure) {
        emit(EpisodeDetailError(failure.errMessage));
        success = false;
      },
      (episodeResponse) {
        if (episode != null) {
          episode = episode!.copyWith(
            isLiked: episodeResponse.episodeModel.isLiked,
            likes: episodeResponse.episodeModel.likes,
          );
        }
        emit(EpisodeDetailLoaded(episodeResponse));
        success = true;
      },
    );

    return success;
  }

}
