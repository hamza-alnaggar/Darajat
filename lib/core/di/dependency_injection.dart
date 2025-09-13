import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:learning_management_system/core/databases/api/dio_consumer.dart';
import 'package:learning_management_system/core/widgets/firebase_auth_service.dart';
import 'package:learning_management_system/features/badges/data/datasource/badges_remote_data_source.dart';
import 'package:learning_management_system/features/badges/data/repositories/badges_repository.dart';
import 'package:learning_management_system/features/badges/presentation/cubit/badges_cubit.dart';
import 'package:learning_management_system/features/comment/data/datasources/comment_remote_data_source.dart';
import 'package:learning_management_system/features/comment/data/datasources/reply_remote_data_source.dart';
import 'package:learning_management_system/features/comment/data/repositories/comment_repository.dart';
import 'package:learning_management_system/features/comment/data/repositories/reply_repository.dart';
import 'package:learning_management_system/features/comment/presentation/cubit/comment_cubit.dart';
import 'package:learning_management_system/features/courses/data/datasources/category_remote_data_source.dart';
import 'package:learning_management_system/features/courses/data/datasources/courses_remote_data_source.dart';
import 'package:learning_management_system/features/courses/data/datasources/create_course_remote_data_source.dart';
import 'package:learning_management_system/features/courses/data/datasources/create_update_episode_remote_data_source.dart';
import 'package:learning_management_system/features/courses/data/datasources/episodes_remote_data_sourse.dart';
import 'package:learning_management_system/features/courses/data/datasources/get_certificate_remote_data_source.dart';
import 'package:learning_management_system/features/courses/data/datasources/get_course_for_techer_remote_data_source.dart';
import 'package:learning_management_system/features/courses/data/datasources/get_followed_course_for_student_remote_data_source.dart';
import 'package:learning_management_system/features/courses/data/datasources/rate_course_remote_data_source.dart';
import 'package:learning_management_system/features/courses/data/datasources/show_course_for_student_remote_data_sourse.dart';
import 'package:learning_management_system/features/courses/data/datasources/show_course_for_techer_remote_data_sourse.dart';
import 'package:learning_management_system/features/courses/data/datasources/topic_remote_data_source.dart';
import 'package:learning_management_system/features/courses/data/repositories/category_repository.dart';
import 'package:learning_management_system/features/courses/data/repositories/courses_repository.dart';
import 'package:learning_management_system/features/courses/data/repositories/course_status_repository.dart';
import 'package:learning_management_system/features/courses/data/repositories/create_update_episode_repository.dart';
import 'package:learning_management_system/features/courses/data/repositories/episodes_repository.dart';
import 'package:learning_management_system/features/courses/data/repositories/get_certificate_repository.dart';
import 'package:learning_management_system/features/courses/data/repositories/get_course_for_techer_repository.dart';
import 'package:learning_management_system/features/courses/data/repositories/get_followed_course_for_student_repository.dart';
import 'package:learning_management_system/features/courses/data/repositories/rate_course_repository.dart';
import 'package:learning_management_system/features/courses/data/repositories/show_course_for_student_repository.dart';
import 'package:learning_management_system/features/courses/data/repositories/show_course_for_techer_repository.dart';
import 'package:learning_management_system/features/courses/data/repositories/topic_repository.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/category_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/course_search_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/courses_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/create_cousre_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/create_update_episode_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/followed_course_for_student_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/get_certificate_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/get_course_for_techer_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/rate_course_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/show_course_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/topic_cubit.dart';
import 'package:learning_management_system/features/logout/presentation/cubit/log_out_cubit.dart';
import 'package:learning_management_system/features/paid/data/datasource/create_payment_intent_remote_data_sourse.dart';
import 'package:learning_management_system/features/paid/data/repositories/create_payment_repository.dart';
import 'package:learning_management_system/features/sign_up/data/datasources/get_specialized_remote_data_sourse.dart';
import 'package:learning_management_system/features/sign_up/data/datasources/get_univercity_remote_data_sourse.dart';
import 'package:learning_management_system/features/sign_up/data/repositories/get_speci_repository.dart';
import 'package:learning_management_system/features/sign_up/data/repositories/get_univercity_repository.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_speci_cubit.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_speci_state.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_univercity_cubit.dart';
import 'package:learning_management_system/features/statistics/data/datasource/statistics_remote_data_source.dart';
import 'package:learning_management_system/features/statistics/data/repositories/statistics_repository.dart';
import 'package:learning_management_system/features/student/educations/data/datasource/get_educations_remote_data_source.dart';
import 'package:learning_management_system/features/student/educations/data/repository/get_educations_repository.dart';
import 'package:learning_management_system/features/student/educations/presentation/cubit/get_educations_cubit.dart';
import 'package:learning_management_system/features/student/job_titles/data/datasource/get_job_title_remote_data_source.dart';
import 'package:learning_management_system/features/student/job_titles/data/repository/get_job_title_repository.dart';
import 'package:learning_management_system/features/student/job_titles/presentation/cubit/job_title_cubit.dart';
import 'package:learning_management_system/features/student/levels/data/datasource/get_levels_remote_data_source.dart';
import 'package:learning_management_system/features/student/levels/data/repository/get_levels_repository.dart';
import 'package:learning_management_system/features/student/levels/presentation/cubit/get_levels_cubit.dart';
import 'package:learning_management_system/features/login/data/datasources/login_remote_data_source.dart';
import 'package:learning_management_system/features/login/data/repositories/login_repository.dart';
import 'package:learning_management_system/features/login/presentation/cubit/login_cubit.dart';
import 'package:learning_management_system/features/logout/data/datasource/logout_remote_data_source.dart';
import 'package:learning_management_system/features/logout/data/repositories/log_out_repository.dart';
import 'package:learning_management_system/features/otp/data/datasources/resed_otp_remote_data_source.dart';
import 'package:learning_management_system/features/otp/data/datasources/verify_otp_remote_data_source.dart';
import 'package:learning_management_system/features/otp/data/repositories/resend_otp_repository.dart';
import 'package:learning_management_system/features/otp/data/repositories/verify_otp_repository.dart';
import 'package:learning_management_system/features/otp/presentation/cubit/otp_cubit.dart';
import 'package:learning_management_system/features/student/profile/data/datasource/change_password_profile_remote_data_source.dart';
import 'package:learning_management_system/features/student/profile/data/datasource/get_profile_remote_data_source.dart';
import 'package:learning_management_system/features/student/profile/data/datasource/promote_student_remote_data_sourse.dart';
import 'package:learning_management_system/features/student/profile/data/datasource/update_profile_image_remote_data_source.dart';
import 'package:learning_management_system/features/student/profile/data/datasource/update_profile_remote_data_source.dart';
import 'package:learning_management_system/features/student/profile/data/repository/change_password_repository.dart';
import 'package:learning_management_system/features/student/profile/data/repository/get_profile_repository.dart';
import 'package:learning_management_system/features/student/profile/data/repository/promote_student_repository.dart';
import 'package:learning_management_system/features/student/profile/data/repository/update_profile_image_repository.dart';
import 'package:learning_management_system/features/student/profile/data/repository/update_profile_repository.dart';
import 'package:learning_management_system/features/student/profile/presentation/cubit/change_password_cubit.dart';
import 'package:learning_management_system/features/student/profile/presentation/cubit/profile_cubit.dart';
import 'package:learning_management_system/features/student/profile/presentation/cubit/promote_student_cubit.dart';
import 'package:learning_management_system/features/student/quiz/data/datasources/calculat_quiz_result_remote_data_source.dart';
import 'package:learning_management_system/features/student/quiz/data/datasources/process_answer_remote_data_source.dart';
import 'package:learning_management_system/features/student/quiz/data/datasources/quiz_remote_data_source.dart';
import 'package:learning_management_system/features/student/quiz/data/datasources/start_quiz_remote_data_source.dart';
import 'package:learning_management_system/features/student/quiz/data/repositories/calculat_quiz_result_repository.dart';
import 'package:learning_management_system/features/student/quiz/data/repositories/quiz_repository.dart';
import 'package:learning_management_system/features/student/quiz/data/repositories/process_answer_repository.dart';
import 'package:learning_management_system/features/student/quiz/data/repositories/start_quiz_repository.dart';
import 'package:learning_management_system/features/student/quiz/presentation/cubit/create_quiz_cubit.dart';
import 'package:learning_management_system/features/student/quiz/presentation/cubit/quiz_cubit.dart';
import 'package:learning_management_system/features/reset_password/data/datasources/check_code_reset_password_remote_data_source.dart';
import 'package:learning_management_system/features/reset_password/data/datasources/forgot_password_remote_data_source.dart';
import 'package:learning_management_system/features/reset_password/data/datasources/reset_password_remote_data_source.dart';
import 'package:learning_management_system/features/reset_password/data/repositories/ckeck_code_reset_password_repository.dart';
import 'package:learning_management_system/features/reset_password/data/repositories/forgot_password_repository.dart';
import 'package:learning_management_system/features/reset_password/data/repositories/reset_password_repository.dart';
import 'package:learning_management_system/features/reset_password/presentation/cubit/check_code_reset_password_cubit.dart';
import 'package:learning_management_system/features/reset_password/presentation/cubit/forgot_passwrod_cubit.dart';
import 'package:learning_management_system/features/reset_password/presentation/cubit/reset_password_cubit.dart';
import 'package:learning_management_system/features/sign_up/data/datasources/get_country_remote_data_source.dart';
import 'package:learning_management_system/features/sign_up/data/datasources/get_language_remote_data_source.dart';
import 'package:learning_management_system/features/sign_up/data/datasources/sign_up_remote_data_source.dart';
import 'package:learning_management_system/features/sign_up/data/repositories/get_country_repository.dart';
import 'package:learning_management_system/features/sign_up/data/repositories/get_language_repository.dart';
import 'package:learning_management_system/features/sign_up/data/repositories/sign_up_repository_impl.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_country_cubit.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_language_cubit.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/sign_up_cubit.dart';
import 'package:learning_management_system/features/student/skills/data/datasource/get_skills_remote_data_source.dart';
import 'package:learning_management_system/features/student/skills/data/repository/get_skills_repository.dart';
import 'package:learning_management_system/features/student/skills/presentation/cubit/get_skills_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> getItInit() async {
  // get filter
  sl.registerLazySingleton<Dio>(() => Dio());

  sl.registerLazySingleton<DioConsumer>(() => DioConsumer(dio: sl<Dio>()));

  sl.registerLazySingleton<SignUpRemoteDataSource>(
    () => SignUpRemoteDataSource(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<SignUpRepository>(
    () =>
        SignUpRepository(signUpRemoteDataSource: sl<SignUpRemoteDataSource>()),
  );

  sl.registerFactory<SignUpCubit>(
    () => SignUpCubit(signUpRepository: sl<SignUpRepository>()),
  );

  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSource(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepository(loginRemoteDataSource: sl<LoginRemoteDataSource>()),
  );
  sl.registerLazySingleton<StatisticsRemoteDataSource>(
    () => StatisticsRemoteDataSource(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<StatisticsRepository>(
    () => StatisticsRepository(remoteDataSource: sl<StatisticsRemoteDataSource>()),
  );
  sl.registerLazySingleton<BadgesRemoteDataSource>(
    () => BadgesRemoteDataSource(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<BadgesRepository>(
    () => BadgesRepository(remoteDataSource: sl<BadgesRemoteDataSource>()),
  );
  sl.registerLazySingleton<BadgesCubit>(
    () => BadgesCubit(repository: sl<BadgesRepository>()),
  );

  sl.registerLazySingleton<GoogleAuthService>(
    () => GoogleAuthService(),
  );

  sl.registerFactory<LoginCubit>(
    () => LoginCubit(loginRepository: sl<LoginRepository>(),googleAuthService: sl<GoogleAuthService>()),
  );

  sl.registerLazySingleton<GetCountryRemoteDataSource>(
    () => GetCountryRemoteDataSource(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<GetCountryRepository>(
    () => GetCountryRepository(
      getCountryRemoteDataSource: sl<GetCountryRemoteDataSource>(),
    ),
  );

  sl.registerFactory<GetCountryCubit>(
    () => GetCountryCubit(sl<GetCountryRepository>()),
  );

  sl.registerLazySingleton<GetLanguageRemoteDataSource>(
    () => GetLanguageRemoteDataSource(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<GetLanguageRepository>(
    () => GetLanguageRepository(
      getLanguageRemoteDataSource: sl<GetLanguageRemoteDataSource>(),
    ),
  );

  sl.registerFactory<GetLanguageCubit>(
    () => GetLanguageCubit(sl<GetLanguageRepository>()),
  );

  sl.registerLazySingleton<ResedOtpRemoteDataSource>(
    () => ResedOtpRemoteDataSource(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<ResendOtpRepository>(
    () => ResendOtpRepository(
      resedOtpRemoteDataSource: sl<ResedOtpRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<VerifyOtpRemoteDataSource>(
    () => VerifyOtpRemoteDataSource(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<VerifyOtpRepository>(
    () => VerifyOtpRepository(
      verifyOtpRemoteDataSource: sl<VerifyOtpRemoteDataSource>(),
    ),
  );

  sl.registerFactory<OtpCubit>(
    () => OtpCubit(
      resendOtpRepository: sl<ResendOtpRepository>(),
      verifyOtpRepository: sl<VerifyOtpRepository>(),
    ),
  );

  sl.registerLazySingleton<CheckCodeResetPasswordRemoteDataSource>(
    () => CheckCodeResetPasswordRemoteDataSource(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<CheckCodeResetPasswordRepository>(
    () => CheckCodeResetPasswordRepository(
      checkCodeResetPasswordRemoteDataSource:
          sl<CheckCodeResetPasswordRemoteDataSource>(),
    ),
  );

  sl.registerFactory<CheckCodeResetPasswordCubit>(
    () => CheckCodeResetPasswordCubit(sl<CheckCodeResetPasswordRepository>()),
  );

  sl.registerLazySingleton<ForgotPasswordRemoteDataSource>(
    () => ForgotPasswordRemoteDataSource(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<ForgotPasswordRepository>(
    () => ForgotPasswordRepository(
      forgotPasswordRemoteDataSource: sl<ForgotPasswordRemoteDataSource>(),
    ),
  );

  sl.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(sl<ForgotPasswordRepository>()),
  );

  sl.registerLazySingleton<ResetPasswordRemoteDataSource>(
    () => ResetPasswordRemoteDataSource(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<ResetPasswordRepository>(
    () => ResetPasswordRepository(
      resetPasswordRemoteDataSource: sl<ResetPasswordRemoteDataSource>(),
    ),
  );

  sl.registerFactory<ResetPasswordCubit>(
    () => ResetPasswordCubit(
      resetPasswordRepository: sl<ResetPasswordRepository>(),
      code: '',
    ),
  );

  sl.registerLazySingleton<GetEducationsRemoteDataSource>(
    () => GetEducationsRemoteDataSource(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<GetEducationsRepository>(
    () => GetEducationsRepository(
      remoteDataSource: sl<GetEducationsRemoteDataSource>(),
    ),
  );

  sl.registerFactory<GetEducationsCubit>(
    () => GetEducationsCubit(sl<GetEducationsRepository>()),
  );

  sl.registerLazySingleton<GetSkillsRemoteDataSource>(
    () => GetSkillsRemoteDataSource(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<GetSkillsRepository>(
    () =>
        GetSkillsRepository(remoteDataSource: sl<GetSkillsRemoteDataSource>()),
  );

  sl.registerFactory<GetSkillsCubit>(
    () => GetSkillsCubit(sl<GetSkillsRepository>()),
  );
  sl.registerLazySingleton<GetUnivercityRemoteDataSourse>(
    () => GetUnivercityRemoteDataSourse(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<GetUnivercityRepository>(
    () =>
        GetUnivercityRepository(remoteDataSourse: sl<GetUnivercityRemoteDataSourse>()),
  );

  sl.registerFactory<GetUnivercityCubit>(
    () => GetUnivercityCubit(sl<GetUnivercityRepository>()),
  );
  sl.registerLazySingleton<GetSpecializedRemoteDataSourse>(
    () => GetSpecializedRemoteDataSourse(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<GetSpeciRepository>(
    () =>
        GetSpeciRepository(remoteDataSourse: sl<GetSpecializedRemoteDataSourse>()),
  );

  sl.registerFactory<GetSpeciCubit>(
    () => GetSpeciCubit(sl<GetSpeciRepository>()),
  );
  sl.registerLazySingleton<GetCertificateRemoteDataSource>(
    () => GetCertificateRemoteDataSource(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<GetCertificateRepository>(
    () =>
        GetCertificateRepository(remoteDataSource: sl<GetCertificateRemoteDataSource>()),
  );

  sl.registerFactory<GetCertificateCubit>(
    () => GetCertificateCubit(repository:  sl<GetCertificateRepository>()),
  );

  

  sl.registerLazySingleton<GetJobTitleRemoteDataSource>(
    () => GetJobTitleRemoteDataSource(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<GetJobTitleRepository>(
    () => GetJobTitleRepository(
      remoteDataSource: sl<GetJobTitleRemoteDataSource>(),
    ),
  );

  sl.registerFactory<JobTitleCubit>(
    () => JobTitleCubit(sl<GetJobTitleRepository>()),
  );

  sl.registerLazySingleton<GetLevelsRemoteDataSource>(
    () => GetLevelsRemoteDataSource(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<GetLevelsRepository>(
    () =>
        GetLevelsRepository(remoteDataSource: sl<GetLevelsRemoteDataSource>()),
  );

  sl.registerFactory<GetLevelsCubit>(
    () => GetLevelsCubit(sl<GetLevelsRepository>()),
  );

  sl.registerLazySingleton<UpdateProfileImageRemoteDataSource>(
    () => UpdateProfileImageRemoteDataSource(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<UpdateProfileImageRepository>(
    () =>
        UpdateProfileImageRepository(remoteDataSource: sl<UpdateProfileImageRemoteDataSource>()),
  );
  sl.registerLazySingleton<UpdateProfileRemoteDataSource>(
    () => UpdateProfileRemoteDataSource(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<UpdateProfileRepository>(
    () =>
        UpdateProfileRepository(remoteDataSource: sl<UpdateProfileRemoteDataSource>()),
  );
 

  sl.registerLazySingleton<GetProfileRemoteDataSource>(
    () => GetProfileRemoteDataSource(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<GetProfileRepository>(
    () =>
        GetProfileRepository(remoteDataSource: sl<GetProfileRemoteDataSource>()),
  );

  sl.registerFactory<ProfileCubit>(
    () => ProfileCubit(sl<GetProfileRepository>(),sl<UpdateProfileRepository>(),sl<UpdateProfileImageRepository>()),
  );
  sl.registerLazySingleton<PromoteStudentRemoteDataSourse>(
    () => PromoteStudentRemoteDataSourse(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<PromoteStudentRepository>(
    () =>
        PromoteStudentRepository(remoteDataSource: sl<PromoteStudentRemoteDataSourse>()),
  );

  sl.registerFactory<PromoteStudentCubit>(
    () => PromoteStudentCubit(sl<PromoteStudentRepository>()),
  );

  sl.registerLazySingleton<StartQuizRemoteDataSource>(
    () => StartQuizRemoteDataSource(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<StartQuizRepository>(
    () =>
        StartQuizRepository(startQuizRemoteDataSource: sl<StartQuizRemoteDataSource>()),
  );
  sl.registerLazySingleton<ProcessAnswerRemoteDataSource>(
    () => ProcessAnswerRemoteDataSource(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<ProcessAnswerRepository>(
    () =>
        ProcessAnswerRepository(processAnswerRemoteDataSource: sl<ProcessAnswerRemoteDataSource>()),
  );

  sl.registerLazySingleton<CalculatQuizResultRemoteDataSource>(
    () => CalculatQuizResultRemoteDataSource(api: sl<DioConsumer>()),
  );
  sl.registerLazySingleton<CalculatQuizResultRepository>(
    () =>
        CalculatQuizResultRepository(calculatQuizResultRemoteDataSource: sl<CalculatQuizResultRemoteDataSource>()),
  );

  sl.registerFactory<QuizCubit>(
    () => QuizCubit(startQuizRepository: sl<StartQuizRepository>(),processAnswerRepository:sl<ProcessAnswerRepository>() ,calculatQuizResultRepository:sl<CalculatQuizResultRepository>() ),
  );

  sl.registerLazySingleton<QuizCreationRemoteDataSource>(
    () => QuizCreationRemoteDataSource(api: sl<DioConsumer>()),
  );
  sl.registerLazySingleton<QuizCreationRepository>(
    () =>
        QuizCreationRepository(remoteDataSource: sl<QuizCreationRemoteDataSource>()),
  );

  sl.registerFactory<QuizCreationCubit>(
    () => QuizCreationCubit(repository: sl<QuizCreationRepository>()),
  );
  sl.registerLazySingleton<CommentRemoteDataSource>(
    () => CommentRemoteDataSource(api: sl<DioConsumer>()),
  );
  sl.registerLazySingleton<CommentRepository>(
    () =>
        CommentRepository(remoteDataSource: sl<CommentRemoteDataSource>()),
  );
  sl.registerFactory<CommentCubit>(
    () => CommentCubit(repository: sl<CommentRepository>()),
  );

  sl.registerLazySingleton<ReplyRemoteDataSource>(
    () => ReplyRemoteDataSource(api: sl<DioConsumer>()),
  );
  sl.registerLazySingleton<ReplyRepository>(
    () =>
        ReplyRepository(remoteDataSource: sl<ReplyRemoteDataSource>()),
  );


  sl.registerLazySingleton<CoursesRemoteDataSource>(
    () => CoursesRemoteDataSource(api: sl<DioConsumer>()),
  );
  sl.registerLazySingleton<CoursesRepository>(
    () =>
      CoursesRepository(remoteDataSource: sl<CoursesRemoteDataSource>()),
  );

  sl.registerFactory<CoursesCubit>(
    () => CoursesCubit(repository: sl<CoursesRepository>()),
  );

  sl.registerFactory<CourseSearchCubit>(
    () => CourseSearchCubit(repository: sl<CoursesRepository>()),
  );
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSource(api: sl<DioConsumer>()),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () =>
        CategoryRepository(remoteDataSource: sl<CategoryRemoteDataSource>()),
  );
  sl.registerFactory<CategoryCubit>(
    () => CategoryCubit(repository: sl<CategoryRepository>()),
  );

  sl.registerLazySingleton<TopicRemoteDataSource>(
    () => TopicRemoteDataSource(api: sl<DioConsumer>()),
  );
  sl.registerLazySingleton<TopicRepository>(
    () =>
        TopicRepository(remoteDataSource: sl<TopicRemoteDataSource>()),
  );
  sl.registerFactory<TopicCubit>(
    () => TopicCubit(repository: sl<TopicRepository>()),
  );

  

  
  sl.registerLazySingleton<CreateCourseRemoteDataSource>(
    () => CreateCourseRemoteDataSource(api: sl<DioConsumer>()),
  );
  sl.registerLazySingleton<CourseStatusRepository>(
    () =>
        CourseStatusRepository(remoteDataSource: sl<CreateCourseRemoteDataSource>()),
  );

  sl.registerFactory<CreateCourseCubit>(
    () => CreateCourseCubit(repository: sl<CourseStatusRepository>()),
  );

  sl.registerLazySingleton<ShowCourseForTecherRemoteDataSourse>(
    () => ShowCourseForTecherRemoteDataSourse(api: sl<DioConsumer>()),
  );
  sl.registerLazySingleton<ShowCourseForTecherRepository>(
    () =>
        ShowCourseForTecherRepository(remoteDataSource: sl<ShowCourseForTecherRemoteDataSourse>()),
  );
  sl.registerLazySingleton<ShowCourseForStudentRemoteDataSourse>(
    () => ShowCourseForStudentRemoteDataSourse(api: sl<DioConsumer>()),
  );
  sl.registerLazySingleton<ShowCourseForStudentRepository>(
    () =>
        ShowCourseForStudentRepository(remoteDataSource: sl<ShowCourseForStudentRemoteDataSourse>()),
  );


  sl.registerFactory<ShowCourseCubit>(
    () => ShowCourseCubit(studentRepository: sl<ShowCourseForStudentRepository>(),teacherRepository:sl<ShowCourseForTecherRepository>() ),
  );

  sl.registerLazySingleton<CreateUpdateEpisodeRemoteDataSource>(
    () => CreateUpdateEpisodeRemoteDataSource(api: sl<DioConsumer>()),
  );
  sl.registerLazySingleton<CreateUpdateEpisodeRepository>(
    () =>
        CreateUpdateEpisodeRepository(remoteDataSource: sl<CreateUpdateEpisodeRemoteDataSource>()),
  );

  sl.registerFactory<CreateUpdateEpisodeCubit>(
    () => CreateUpdateEpisodeCubit(repository: sl<CreateUpdateEpisodeRepository>()),
  );

  sl.registerLazySingleton<GetCourseForTecherRemoteDataSource>(
    () => GetCourseForTecherRemoteDataSource(api: sl<DioConsumer>()),
  );
  
  sl.registerLazySingleton<GetCourseForTecherRepository>(
    () =>
        GetCourseForTecherRepository(remoteDataSource: sl<GetCourseForTecherRemoteDataSource>()),
  );

  sl.registerFactory<GetCourseForTecherCubit>(
    () => GetCourseForTecherCubit(repository: sl<GetCourseForTecherRepository>()),
  );

  sl.registerLazySingleton<GetFollowedCourseForStudentRemoteDataSource>(
    () => GetFollowedCourseForStudentRemoteDataSource(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<GetFollowedCourseForStudentRepository>(
    () =>
        GetFollowedCourseForStudentRepository(remoteDataSource: sl<GetFollowedCourseForStudentRemoteDataSource>()),
  );

  sl.registerFactory<FollowedCourseForStudentCubit>(
    () => FollowedCourseForStudentCubit(repository: sl<GetFollowedCourseForStudentRepository>()),
  );

  sl.registerLazySingleton<RateCourseRemoteDataSource>(
    () => RateCourseRemoteDataSource(api: sl<DioConsumer>()),
  );
  sl.registerLazySingleton<RateCourseRepository>(
    () =>
        RateCourseRepository(remoteDataSource: sl<RateCourseRemoteDataSource>()),
  );

  sl.registerFactory<RateCourseCubit>(
    () => RateCourseCubit(repository: sl<RateCourseRepository>()),
  );

  sl.registerLazySingleton<ChangePasswordProfileRemoteDataSource>(
    () => ChangePasswordProfileRemoteDataSource(api: sl<DioConsumer>()),
  );
  sl.registerLazySingleton<ChangePasswordRepository>(
    () =>
        ChangePasswordRepository(remoteDataSource: sl<ChangePasswordProfileRemoteDataSource>()),
  );

  sl.registerFactory<ChangePasswordCubit>(
    () => ChangePasswordCubit( sl<ChangePasswordRepository>()),
  );

  sl.registerLazySingleton<EpisodesRemoteDataSource>(
    () => EpisodesRemoteDataSource(api: sl<DioConsumer>()),
  );
  sl.registerLazySingleton<EpisodesRepository>(
    () =>
        EpisodesRepository(remoteDataSource: sl<EpisodesRemoteDataSource>()),
  );

  

  sl.registerLazySingleton<LogOutRemoteDataSource>(
    () => LogOutRemoteDataSource(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<LogOutRepository>(
    () =>
        LogOutRepository(logoutRemoteDataSource: sl<LogOutRemoteDataSource>()),
  );
  sl.registerLazySingleton<CreatePaymentIntentRemoteDataSourse>(
    () => CreatePaymentIntentRemoteDataSourse(api: sl<DioConsumer>()),
  );

  sl.registerLazySingleton<CreatePaymentRepository>(
    () =>
        CreatePaymentRepository(remoteDataSourse: sl<CreatePaymentIntentRemoteDataSourse>()),
  );
    sl.registerFactory<LogOutCubit>(
    () => LogOutCubit(),
  );

}
