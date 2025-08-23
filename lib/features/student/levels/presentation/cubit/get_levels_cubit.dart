// features/levels/presentation/cubit/level_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/student/levels/data/repository/get_levels_repository.dart';
import 'package:learning_management_system/features/student/levels/presentation/cubit/get_levels_state.dart';

class GetLevelsCubit extends Cubit<GetLevelsState> {
  final GetLevelsRepository repository;
  List<String> levels = [];
  String? selectedLevel;

  GetLevelsCubit(this.repository) : super(LevelInitial());

  Future<void> eitherFailureOrGetLevels() async {
    emit(LevelLoading());
    final result = await repository.getLevels();
    result.fold(
      (failure) => emit(LevelFailure(errMessage: failure.errMessage)),
      (response) {
        levels = response.levels;
        emit(LevelLoaded());
      },
    );
  }

  void selectLevel(String level) {
    selectedLevel = level;
    emit(LevelSelectionChanged());
  }
}