// features/levels/presentation/cubit/level_state.dart
abstract class GetLevelsState {}

class LevelInitial extends GetLevelsState {}

class LevelLoading extends GetLevelsState {}

class LevelLoaded extends GetLevelsState {}

class LevelFailure extends GetLevelsState {
  final String errMessage;
  LevelFailure({required this.errMessage});
}

class LevelSelectionChanged extends GetLevelsState {}