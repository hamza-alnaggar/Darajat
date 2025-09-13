import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learning_management_system/features/student/quiz/data/models/answer_model.dart';
import 'package:learning_management_system/features/student/quiz/data/repositories/calculat_quiz_result_repository.dart';
import 'package:learning_management_system/features/student/quiz/data/repositories/process_answer_repository.dart';
import 'package:learning_management_system/features/student/quiz/data/repositories/start_quiz_repository.dart';
import 'package:learning_management_system/features/student/quiz/presentation/cubit/quiz_state.dart';


class QuizCubit extends Cubit<QuizState> {
  QuizCubit({required this.startQuizRepository,required this.processAnswerRepository,required this.calculatQuizResultRepository}) : super(QuizInitial());

  StartQuizRepository startQuizRepository ;
  ProcessAnswerRepository processAnswerRepository ;
  CalculatQuizResultRepository calculatQuizResultRepository ;

  

  
  final formKey = GlobalKey<FormState>();


  // Sign Up Method
  Future<void> eitherFailureOrStartQuiz({required int quizId}) async {
    emit(QuizLoading());
    final failureOrStartQuiz = await startQuizRepository.startQuiz(
        quizId: quizId
      );
    failureOrStartQuiz.fold(
      (failure) => emit(QuizFailure(errMessage: failure.errMessage)),
      (quiz) async{
          emit(QuizSuccessfully(quizModel: quiz));
      } 
    );
  }

  Future<bool> processAnswer({
    required int quizId,
    required int questionNumber,
    required String answer,
  }) async {
    emit(ProcessAnswerLoading());
    final failureOrResult = await processAnswerRepository.processAnswer(
      quizId: quizId,
      questionNumber: questionNumber,
      answer: answer,
    );

    bool success = false;
    failureOrResult.fold(
      (failure) {
        emit(ProcessAnswerFailure(errMessage: failure.errMessage));
        success = false;
      },
      (result) {
        emit(ProcessAnswerSuccessfully(answerModel: result));
        success = true;
      },
    );

    return success;
  }

  Future<void> calculateQuizResult({
    required int quizId,
    required List<AnswerModel> answers,
  }) async {
    emit(CalculateQuizResultLoading());
    final failureOrResult = await calculatQuizResultRepository.calculateQuizResult(
      quizId: quizId,
      answers: answers,
    );
    
    failureOrResult.fold(
      (failure) => emit(CalculateQuizResultFailure(errMessage: failure.errMessage)),
      (result) => emit(CalculateQuizResultSuccessfully(quizResultModel: result)),
    );
  }
}




