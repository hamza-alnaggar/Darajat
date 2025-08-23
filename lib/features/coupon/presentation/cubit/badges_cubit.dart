// features/badges/presentation/cubit/badges_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/badges/data/repositories/badges_repository.dart';
import 'package:learning_management_system/features/badges/presentation/cubit/badges_state.dart';


class BadgesCubit extends Cubit<BadgesState> {
  final BadgesRepository repository;

  BadgesCubit({required this.repository}) : super(BadgesInitial());

  Future<void> getBadges() async {
    emit(BadgesLoading());
    final response = await repository.getBadges();
    response.fold(
      (failure) => emit(BadgesFailure(errMessage: failure.errMessage)),
      (badges) => emit(BadgesSuccess(badges: badges)),
    );
  }
}