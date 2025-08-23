
import 'package:learning_management_system/features/courses/data/models/episode_response_model.dart';

abstract class EpisodesListState {
  const EpisodesListState();
}

class EpisodesListInitial extends EpisodesListState {}

class EpisodesListLoading extends EpisodesListState {}

class EpisodesListLoaded extends EpisodesListState {
  final EpisodeResponseModel response;
  const EpisodesListLoaded(this.response);
}

class EpisodesListError extends EpisodesListState {
  final String message;
  const EpisodesListError(this.message);
}