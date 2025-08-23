
abstract class EpisodeState {}

class EpisodeInitial extends EpisodeState {}

class EpisodeLoading extends EpisodeState {}
class EpisodeSuccess extends EpisodeState {
  final String message;
  EpisodeSuccess({required this.message,});
}
class EpisodeFailure extends EpisodeState {
  final String errMessage;
  EpisodeFailure({required this.errMessage});
}