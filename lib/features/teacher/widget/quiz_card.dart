import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_create_body.dart';
import 'package:learning_management_system/features/student/quiz/data/models/sub_models/question_sub_models.dart';
import 'package:learning_management_system/features/student/quiz/presentation/cubit/create_quiz_cubit.dart';
import 'package:learning_management_system/features/student/quiz/presentation/cubit/create_quiz_state.dart';
import 'package:learning_management_system/features/student/quiz/presentation/screen/create_quis_form.dart';
import 'package:learning_management_system/features/teacher/screens/create_episodes_screen.dart';
import 'package:learning_management_system/features/teacher/widget/question_item.dart';

class QuizCard extends StatefulWidget {
  final int episodeId; 
  final Quiz quiz;
  final bool isDark;
  final String status;
  final TextTheme theme;
  final Function(int?) onDelete; 
  final Function onAddQuiz; 
  final Function(Quiz) onQuizUpdated;

  const QuizCard({
    super.key,
    required this.episodeId,
    required this.quiz,
    required this.isDark,
    required this.theme,
    required this.status,
    required this.onDelete,
    required this.onAddQuiz,
    required this.onQuizUpdated,
  });

  @override
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  late Quiz _currentQuiz;
  bool _isEditing = false;
  bool _isSaving = false;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _addFormKey = GlobalKey();
  final GlobalKey _closeFormKey = GlobalKey();
  final Map<int, GlobalKey> _editFormKeys = {};

  @override
  void initState() {
    super.initState();
    _currentQuiz = widget.quiz;
  }

  void _scrollToForm(GlobalKey key) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (key.currentContext != null) {
        final context = key.currentContext!;
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _handleQuestionSaved(QuestionSubModels newQuestion) async {
    setState(() => _isSaving = true);
    
    final updatedQuiz = _currentQuiz.copyWith(
      questions: [..._currentQuiz.questions, newQuestion],
      addQuestion: false,
    );

    final success = await _saveQuizToBackend(updatedQuiz);
    
    if (success && mounted) {
      setState(() {
        _currentQuiz = updatedQuiz;
      });
    }
    
    setState(() => _isSaving = false);
  }

  Future<void> _handleQuestionUpdated(QuestionSubModels updatedQuestion) async {
    final previousQuiz = _currentQuiz; 
    
    setState(() {
      _isSaving = true;
      _currentQuiz = _currentQuiz.copyWith(
        editingQuestion: null,
        questions: _currentQuiz.questions.map((q) =>
          q.questionNumber == updatedQuestion.questionNumber ? updatedQuestion : q
        ).toList(),
      );
    });

    try {
      final success = await _saveQuizToBackend(_currentQuiz);
      
      if (!success && mounted) {
        setState(() => _currentQuiz = previousQuiz);
      } else if (mounted) {
        widget.onQuizUpdated(_currentQuiz);
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteQuestion(QuestionSubModels question) async {
    setState(() => _isSaving = true);
    
    final updatedQuestions = _currentQuiz.questions
      .where((q) => q.questionNumber != question.questionNumber)
      .toList();

    final updatedQuiz = _currentQuiz.copyWith(questions: updatedQuestions);

    final success = await _saveQuizToBackend(updatedQuiz);
    
    if (success && mounted) {
      setState(() {
        _currentQuiz = updatedQuiz;
        widget.onQuizUpdated(_currentQuiz);
      });
    }
    
    setState(() => _isSaving = false);
  }

  Future<bool> _saveQuizToBackend(Quiz quiz) async {
    try {
      if (quiz.quizId != null) {
        final result = await context.read<QuizCreationCubit>().updateQuiz(
          _toCreateBody(quiz),
          quiz.quizId!,
          false
        );
        
        return result == true;
      } else  {
        final newQuizId = await context.read<QuizCreationCubit>().createQuiz(
          _toCreateBody(quiz),
          widget.episodeId,
          false
        );
        
        if (newQuizId > 0) {
          quiz = quiz.copyWith(quizId: newQuizId);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuizCreationCubit, QuizCreationState>(
      listener: (context, state) {
        if (state is QuizCreationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        else if (state is QuizCreationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تمت العملية بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: Stack(
        children:[ 
          Container(
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: widget.isDark ? CustomColors.darkContainer : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: ExpansionTile(
              key: _closeFormKey,
              tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              leading: Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.quiz, color: Colors.deepPurpleAccent, size: 20.r),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Quiz',
                      style: widget.theme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: widget.isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Row(
                children: [
                  Text(
                    '${_currentQuiz.questions.length} questions',
                    style: widget.theme.bodyMedium?.copyWith(
                      color: widget.isDark ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 22.r,
                    color: widget.isDark ? Colors.white70 : Colors.grey.shade600,
                  ),
                ],
              ),
              trailing:widget.status !='approved'? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete_outline, size: 18.r,
                        color: widget.isDark ? Colors.white70 : Colors.grey.shade700),
                    onPressed: () => widget.onDelete(_currentQuiz.quizId),
                  ),
                  IconButton(
                    icon: Icon(
                      _isEditing ? Icons.close : Icons.edit,
                      size: 18.r,
                    ),
                    onPressed: () => setState(() => _isEditing = !_isEditing),
                    color: widget.isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ],
              ):null,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Questions",
                            style: widget.theme.titleMedium?.copyWith(
                              color: widget.isDark ? Colors.white70 : Colors.grey.shade700,
                            ),
                          ),
                          if (_isEditing)
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _currentQuiz = _currentQuiz.copyWith(
                                    addQuestion: true,
                                    editingQuestion: null,
                                  );
                                });
                                SchedulerBinding.instance.addPostFrameCallback((_) {
                                  _scrollToForm(_addFormKey);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.isDark 
                                    ? Colors.deepPurple.shade800 
                                    : Colors.deepPurpleAccent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.add, size: 16.r),
                                  SizedBox(width: 4.w),
                                  Text('Add Question', style: TextStyle(fontSize: 12.sp)),
                                ],
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      if (_currentQuiz.addQuestion)
                        CreateQuisForm(
                          key: _addFormKey,
                          episodeId: widget.episodeId,
                          initialQuestion: null,
                          questionNumber: _currentQuiz.questions.length+1,
                          onSave: _handleQuestionSaved,
                          onCancel: () => setState(() {
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                                _scrollToForm(_closeFormKey);
                              });
                            _currentQuiz = _currentQuiz.copyWith(addQuestion: false);
                            
                          }),
                        ),
                      
                      if (_currentQuiz.editingQuestion != null)
                        CreateQuisForm(
                          key: _editFormKeys[_currentQuiz.editingQuestion!.questionNumber],
                          episodeId: widget.episodeId,
                          initialQuestion: _currentQuiz.editingQuestion,
                          questionNumber: _currentQuiz.editingQuestion!.questionNumber,
                          onSave: (updatedQuestion) {
                            _handleQuestionUpdated(updatedQuestion);
                            setState(() => _currentQuiz = _currentQuiz.copyWith(editingQuestion: null));
                          },
                          onCancel: () { 
                            setState(() {
                              _currentQuiz = _currentQuiz.copyWith(editingQuestion: null, addQuestion: false);
                            });
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              _scrollToForm(_closeFormKey);
                            });
                          }
                        ),
                      
                      ..._currentQuiz.questions.map((q) => QuestionItem(
                        question: q,
                        isDark: widget.isDark,
                        isEditing: _isEditing,
                        onEdit: () {
                          if (!_editFormKeys.containsKey(q.questionNumber)) {
                            _editFormKeys[q.questionNumber] = GlobalKey();
                          }
                          
                          setState(() {
                            _currentQuiz = _currentQuiz.copyWith(editingQuestion: q, addQuestion: false);
                          });
                          
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            _scrollToForm(_editFormKeys[q.questionNumber]!);
                          });
                        },
                        onDelete: () { _deleteQuestion(q);}
                      )),
                      
                      if (!_currentQuiz.addQuestion && 
                          _currentQuiz.editingQuestion == null &&
                          _currentQuiz.questions.isEmpty)
                        Center(
                          child: Padding(
                                padding: EdgeInsets.all(16.w),
                                child: Text(
                                  'Add questions for Quiz',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                        ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isSaving)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  QuizCreateBody _toCreateBody(Quiz quiz) {
    return QuizCreateBody(
      episodeId: widget.episodeId,
      numOfQuestions: quiz.questions.length,
      questions: quiz.questions.map((q) {
        return QuestionCreationModel(
          questionNumber: q.questionNumber,
          content: q.content,
          answerA: q.answerA,
          answerB: q.answerB,
          answerC: q.answerC,
          answerD: q.answerD,
          rightAnswer: q.rightAnswer!.toLowerCase(),
          explanation: q.explanation,
        );
      }).toList(),
    );
  }
}