// quiz_creation_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_create_body.dart';
import 'package:learning_management_system/features/student/quiz/data/repositories/quiz_repository.dart';
import 'package:learning_management_system/features/student/quiz/presentation/cubit/create_quiz_state.dart';

class QuizCreationCubit extends Cubit<QuizCreationState> {
  final QuizCreationRepository repository;

  QuizCreationCubit({required this.repository}) : super(QuizCreationInitial());

  Future<int> createQuiz(
    QuizCreateBody request,
    int episodeId,
    bool isCopy,
  ) async {
    emit(QuizCreationLoading());
    try {
      final result = await repository.createQuiz(
        request: request,
        episodeId: episodeId,
        isCopy: isCopy,
      );

      return result.fold(
        (failure) {
          emit(QuizCreationFailure(errMessage: failure.errMessage));
          return -1;
        },
        (response) {
          emit(QuizCreationSuccess(message: response.message));
          return response.quiz.quizId;
        },
      );
    } catch (e) {
      emit(QuizCreationFailure(errMessage: 'Unexpected error'));
      return -1;
    }
  }

  Future<bool> updateQuiz(
    QuizCreateBody request,
    int episodeId,
    bool isCopy,
  ) async {
    emit(QuizCreationLoading());
    try {
      final result = await repository.updateQuiz(
        request: request,
        episodeId: episodeId,
        isCopy: isCopy,
      );

      return result.fold(
        (failure) {
          emit(QuizCreationFailure(errMessage: failure.errMessage));
          return false;
        },
        (response) {
          emit(QuizCreationSuccess(message: response));
          return true;
        },
      );
    } catch (e) {
      emit(QuizCreationFailure(errMessage: 'Unexpected error'));
      return false;
    }
  }

  Future<bool> deleteQuiz(int episodeId, bool isCopy) async {
    emit(QuizCreationLoading());
    final result = await repository.deleteQuiz(
      episodeId: episodeId,
      isCopy: isCopy,
    );

    return result.fold(
      (failure) {
        emit(QuizCreationFailure(errMessage: failure.errMessage));
        return false;
      },
      (response) {
        emit(QuizCreationSuccess(message: response));
        return true;
      },
    );
  }
}
