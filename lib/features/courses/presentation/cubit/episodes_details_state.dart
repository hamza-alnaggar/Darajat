
import 'package:learning_management_system/features/courses/data/models/episode_response_model.dart';

abstract class EpisodeDetailState {
  const EpisodeDetailState();
}

class EpisodeDetailInitial extends EpisodeDetailState {}

class EpisodeDetailLoading extends EpisodeDetailState {}

class EpisodeDetailLoaded extends EpisodeDetailState {
  final EpisodeResponse episode;
   EpisodeDetailLoaded(this.episode);
}

class EpisodeDetailLoadVideoOrPoster extends EpisodeDetailState {
}

class EpisodeDetailDownloadSuccess extends EpisodeDetailState {
  final String savedPath;
  EpisodeDetailDownloadSuccess(this.savedPath);
}

class EpisodeDetailDownloading extends EpisodeDetailState {}


class EpisodeDetailError extends EpisodeDetailState {
  final String message;
  const EpisodeDetailError(this.message);
}