// features/statistics/presentation/cubit/statistics_state.dart


import 'package:learning_management_system/features/statistics/data/models/statistics_resopnse_model.dart';

sealed class StatisticsState {}

final class StatisticsInitial extends StatisticsState {}

final class StatisticsLoading extends StatisticsState {}

final class StatisticsSuccess extends StatisticsState {
  final StatisticsResponseModel statistics;

  StatisticsSuccess({required this.statistics});
}

final class StatisticsFailure extends StatisticsState {
  final String errMessage;

  StatisticsFailure({required this.errMessage});
}