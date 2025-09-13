// features/statistics/presentation/cubit/statistics_state.dart

import 'package:learning_management_system/features/statistics/data/models/statistics_item_model.dart';

abstract class StatisticsState {}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsSuccess extends StatisticsState {
  final List<StatisticsItemModel> statistics;

  StatisticsSuccess({required this.statistics});
}

class StatisticsFailure extends StatisticsState {
  final String errMessage;

  StatisticsFailure({required this.errMessage});
}