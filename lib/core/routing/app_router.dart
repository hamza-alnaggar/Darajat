
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/di/dependency_injection.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/widgets/flame.dart';
import 'package:learning_management_system/core/widgets/home.dart';
import 'package:learning_management_system/core/widgets/side_bar.dart';
import 'package:learning_management_system/features/category_screen.dart';
import 'package:learning_management_system/features/courses/presentation/screen/preview_course.dart';
import 'package:learning_management_system/features/comment/presentation/cubit/comment_cubit.dart';
import 'package:learning_management_system/features/comment/presentation/screen/chat_screen.dart';
import 'package:learning_management_system/features/comment/presentation/screen/create_course_screen.dart';
import 'package:learning_management_system/features/courses/data/repositories/episodes_repository.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/category_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/course_search_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/courses_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/create_cousre_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/create_update_episode_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episodes_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/episodes_details_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/get_course_for_techer_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/show_course_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/topic_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/screen/courses_by_category_or_topic_screen.dart';
import 'package:learning_management_system/features/courses/presentation/screen/search_screen.dart';
import 'package:learning_management_system/features/flame.dart';
import 'package:learning_management_system/features/onboarding/screen/onboarding_screen.dart';
import 'package:learning_management_system/features/student/profile/presentation/screens/profile_screen.dart';
import 'package:learning_management_system/features/student/cource_details/presentation/screen/course_details.dart';
import 'package:learning_management_system/features/student/educations/presentation/cubit/get_educations_cubit.dart';
import 'package:learning_management_system/features/student/home/presentation/screen/entry_point.dart';
import 'package:learning_management_system/features/student/job_titles/presentation/cubit/job_title_cubit.dart';
import 'package:learning_management_system/features/student/levels/presentation/cubit/get_levels_cubit.dart';
import 'package:learning_management_system/features/login/presentation/cubit/login_cubit.dart';
import 'package:learning_management_system/features/login/presentation/screen/login_screen.dart';
import 'package:learning_management_system/features/otp/data/repositories/resend_otp_repository.dart';
import 'package:learning_management_system/features/otp/data/repositories/verify_otp_repository.dart';
import 'package:learning_management_system/features/otp/presentation/cubit/otp_cubit.dart';
import 'package:learning_management_system/features/otp/presentation/screens/otp_screen.dart';
import 'package:learning_management_system/features/student/profile/presentation/cubit/profile_cubit.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_model.dart';
import 'package:learning_management_system/features/student/quiz/presentation/cubit/quiz_cubit.dart';
import 'package:learning_management_system/features/student/quiz/presentation/screen/quiz_questions.dart';
import 'package:learning_management_system/features/student/quiz/presentation/screen/quiz_result_screen.dart';
import 'package:learning_management_system/features/student/quiz/presentation/screen/start_quiz.dart';
import 'package:learning_management_system/features/reset_password/data/repositories/reset_password_repository.dart';
import 'package:learning_management_system/features/reset_password/presentation/cubit/check_code_reset_password_cubit.dart';
import 'package:learning_management_system/features/reset_password/presentation/cubit/forgot_passwrod_cubit.dart';
import 'package:learning_management_system/features/reset_password/presentation/cubit/reset_password_cubit.dart';
import 'package:learning_management_system/features/reset_password/presentation/screens/check_code_reset_password_screen.dart';
import 'package:learning_management_system/features/reset_password/presentation/screens/forgot_password_screen.dart';
import 'package:learning_management_system/features/reset_password/presentation/screens/reset_password_screen.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_country_cubit.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_language_cubit.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/sign_up_cubit.dart';
import 'package:learning_management_system/features/sign_up/presentation/screens/sign_up_screen.dart';
import 'package:learning_management_system/features/student/skills/presentation/cubit/get_skills_cubit.dart';
import 'package:learning_management_system/features/splash_screen/splash_screen.dart';
import 'package:learning_management_system/features/teacher/is_changed_cubit.dart';
import 'package:learning_management_system/features/teacher/screens/create_episodes_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case Routes.flameOfEnthusiasm:
        return MaterialPageRoute(
          builder: (context) => FlameOfEnthusiasm(currentStreak: 1),
        );
      case Routes.onboarding:
        return MaterialPageRoute(builder: (context) => OnboardingPage());
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<LoginCubit>())
              ],
            child: const LoginScreen(),
          ),
        );
      case Routes.categoryScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [ BlocProvider(create: (context) => sl<CourseSearchCubit>()),
                BlocProvider(create: (context) => sl<CategoryCubit>()),],
            child: const CategoryScreen(),
          ),
        );
      case Routes.startQuizScreen:
        final arg = settings.arguments as QuizModel;
        return MaterialPageRoute(
          builder: (_) => StartQuizScreen(quizModel: arg,),
        );
      case Routes.coursesByCategoryOrTopicScreen:
        return MaterialPageRoute(
          builder: (_) {
            final arg = settings.arguments as String;
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      sl<CourseSearchCubit>()..getCoursesByCategory(arg),
                ),
                BlocProvider(
                  create: (context) =>
                      sl<TopicCubit>()..getTopicsByCategory(int.parse(arg)),
                ),
              ],
              child: CoursesByCategoryOrTopicScreen(),
            );
          },
        );
      // case Routes.createQuiz:
      //   return MaterialPageRoute(
      //     builder: (_) => MultiBlocProvider(
      //       providers: [
      //         BlocProvider(create: (context) => sl<QuizCreationCubit>()),
      //       ],
      //       child: CreateQuisForm(episodeId: 3),
      //     ),
      //   );
      case Routes.resultScreen:
        return MaterialPageRoute(
          builder: (context) {
            final arg = settings.arguments as Map?;
            final result = arg?['result'];
            return MultiBlocProvider(
              providers: [BlocProvider(create: (context) => sl<QuizCubit>())],
              child: QuizResultScreen(result: result),
            );
          },
        );
      case Routes.questionScreen:
        return MaterialPageRoute(
          builder: (context) {
            final quizModel = settings.arguments as QuizModel;
            return MultiBlocProvider(
              providers: [BlocProvider(create: (context) => sl<QuizCubit>())],
              child: QuizQuestions(quizModel: quizModel),
            );
          },
        );
      case Routes.otpScreen:
        return MaterialPageRoute(
          builder: (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => OtpCubit(
                    resendOtpRepository: sl<ResendOtpRepository>(),
                    verifyOtpRepository: sl<VerifyOtpRepository>(),
                  ),
                ),
              ],
              child: const OtpScreen(),
            );
          },
        );
      case Routes.resetPasswordScreen:
        return MaterialPageRoute(
          builder: (context) {
            final code = settings.arguments as String ;
            return BlocProvider(
              create: (context) => ResetPasswordCubit(
                resetPasswordRepository: sl<ResetPasswordRepository>(),
                code: code,
              ),
              child: const ResetPasswordScreen(),
            );
          },
        );
      case Routes.commentScreen:
        return MaterialPageRoute(
          builder: (context) {
            final postId = settings.arguments as int;
            return BlocProvider(
              create: (context) => sl<CommentCubit>(),
              child:  CommentsScreen(postId: postId),
            );
          },
        );
      

      case Routes.searchScreen:
        return MaterialPageRoute(
          builder: (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => sl<CourseSearchCubit>()),
                BlocProvider(create: (context) => sl<CategoryCubit>()),
              ],
              child: const SearchScreen(),
            );
          },
        );
      case Routes.checkCodeResetPassword:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => sl<CheckCodeResetPasswordCubit>(),
              ),
            ],
            child: const CheckCodeResetPasswordScreen(),
          ),
        );
      case Routes.forgotPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<ForgotPasswordCubit>()),
            ],
            child: const ForgotPasswordScreen(),
          ),
        );
      case Routes.signUpScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<SignUpCubit>()),
              BlocProvider(
                create: (context) =>
                    sl<GetCountryCubit>()..eitherFailureOrGetCountry(),
              ),
              BlocProvider(
                create: (context) =>
                    sl<GetLanguageCubit>()..eitherFailureOrGetLanguage(),
              ),
            ],
            child: const SignUpScreen(),
          ),
        );
      case Routes.entryPoint:
        return MaterialPageRoute(builder: (context) => EntryPoint());
      case Routes.createEpisodesScreen:
        return MaterialPageRoute(
          builder: (context) { 
            final arg = settings.arguments as Map?;
            return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<CreateCourseCubit>()),
              BlocProvider.value(value:arg!['bloc'],),
              BlocProvider(create: (context) => sl<CreateUpdateEpisodeCubit>()),
              
              BlocProvider(
                create: (context) => EpisodesListCubit(
                  repository: sl<EpisodesRepository>(),
                  isStudent: false,
                ),
              ),
            ],
            child: CreateEpisodesScreen(courseId: arg['courseId'],isCopy:arg['isCopy'] ,status: arg['status'],),
          );
          },
        );
      case Routes.createCourseScreen:
        return MaterialPageRoute(
          builder: (context) { 
            final arg = settings.arguments as Map;
            return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    sl<GetLanguageCubit>()..eitherFailureOrGetLanguage(),
              ),
              BlocProvider(
                create: (context) => sl<CategoryCubit>()..getAllCategories(),
              ),
              BlocProvider(create: (context) => sl<TopicCubit>()),
              BlocProvider(create: (context) => sl<CreateCourseCubit>()),
              BlocProvider(create: (context) => IsChangedCubit()),
              BlocProvider(create: (context) => sl<ShowCourseCubit>()),
            ],
            child: CreateCourseScreen(courseId:arg['courseId'],status: arg['status'],isCopy: arg['isCopy'],),
          );},
        );
      case Routes.episodesScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => EpisodesListCubit(
                  repository: sl<EpisodesRepository>(),
                  isStudent: false,
                ),
              ),
              BlocProvider(create: (context) => sl<ShowCourseCubit>()),
              BlocProvider(
                create: (context) => EpisodeDetailCubit(
                  isStudent: true,
                  repository: sl<EpisodesRepository>(),
                ),
              ),
            ],
            child: CoursePage(courseId: 1, isStudent: false),
            // CreateCourse(courseId: 1,isInstructor: true,),
          ),
        );
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => sl<CoursesCubit>(),
              ),
            ],
            child: Home(),
          ),
        );
      case Routes.courseDetailsScreen:
        return MaterialPageRoute(
          builder: (context) {
            final arg = settings.arguments as Map;
            return MultiBlocProvider(
          providers: [
                BlocProvider(
                  create: (context) =>
                      sl<ShowCourseCubit>()..showCourseForStudent(arg['course']),
                ),
                BlocProvider(
                  create: (context) =>
                      sl<ProfileCubit>()..loadProfile(arg['profile']),
                ),
              ],
              child: CourseDetails(),
            );
          },
        );
      case Routes.flameScreen:
        return MaterialPageRoute(builder: (context) => Flame());
      case Routes.sidebar:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<GetCourseForTecherCubit>()),
              BlocProvider(create: (context) => sl<TopicCubit>()),
              BlocProvider(create: (context) => sl<CategoryCubit>()),
            ],
            child: TeacherCoursesScreen(),
          ),
        );
      case Routes.profileScreen:
        return MaterialPageRoute(
          builder: (_) { 
            final arg = settings.arguments as bool? ?? true ;
          return 
            MultiBlocProvider(
            
            providers: [
              BlocProvider(
                create: (context) =>
                    sl<GetSkillsCubit>()..eitherFailureOrGetSkills(),
                    lazy: false,
              ),
              BlocProvider(
                create: (context) => sl<ProfileCubit>()..loadProfile(2),
                lazy: false,
              ),
              BlocProvider(
                create: (context) =>
                    sl<JobTitleCubit>()..eitherFailureOrJobTitle(),
                    lazy: false,
              ),
              BlocProvider(
                create: (context) =>
                    sl<GetEducationsCubit>()..eitherFailureOrGetEducations(),
                    lazy: false,
              ),
              BlocProvider(
                create: (context) =>
                    sl<GetCountryCubit>()..eitherFailureOrGetCountry(),
                    lazy: false,
              ),
              BlocProvider(
                create: (context) =>
                    sl<GetLevelsCubit>()..eitherFailureOrGetLevels(),
                    lazy: false,
            ),
              BlocProvider(
                create: (context) =>
                    sl<GetLanguageCubit>()..eitherFailureOrGetLanguage(),
                    lazy: false,
              ),
            ],
            child:ProfileScreen(isUser:arg ,),
          );},
        );
      default:
        return null;
    }
  }
}
