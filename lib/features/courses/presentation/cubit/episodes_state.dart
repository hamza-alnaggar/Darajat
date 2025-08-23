// features/episodes/presentation/cubit/episodes_state.dart

import 'package:learning_management_system/features/courses/data/models/episode_response_model.dart';

abstract class EpisodesState {}

class EpisodesInitial extends EpisodesState {}

class EpisodesLoading extends EpisodesState {}

class EpisodesSuccess extends EpisodesState {
  final List<EpisodeModel> episodes;

  EpisodesSuccess({required this.episodes});
}

class EpisodesEmpty extends EpisodesState {}

class EpisodesFailure extends EpisodesState {
  final String errMessage;

  EpisodesFailure({required this.errMessage});
}