// features/statistics/presentation/cubit/statistics_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/statistics/data/repositories/statistics_repository.dart';
import 'package:learning_management_system/features/statistics/presentation/cubit/statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final StatisticsRepository repository;

  StatisticsCubit({required this.repository}) : super(StatisticsInitial());

  Future<void> getStatistics(bool isEnthusiasm) async {
    emit(StatisticsLoading());
    final response = await repository.getStatistics(isEnthusiasm);
    response.fold(
      (failure) => emit(StatisticsFailure(errMessage: failure.errMessage)),
      (stats) => emit(StatisticsSuccess(statistics: stats.data)),
    );
  }
}