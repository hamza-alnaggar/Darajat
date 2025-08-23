// features/badges/presentation/cubit/badges_state.dart

import 'package:learning_management_system/features/badges/data/models/badges_response_model.dart';

sealed class BadgesState {}

final class BadgesInitial extends BadgesState {}

final class BadgesLoading extends BadgesState {}

final class BadgesSuccess extends BadgesState {
  final BadgesResponseModel badges;

  BadgesSuccess({required this.badges});
}

final class BadgesFailure extends BadgesState {
  final String errMessage;

  BadgesFailure({required this.errMessage});
}