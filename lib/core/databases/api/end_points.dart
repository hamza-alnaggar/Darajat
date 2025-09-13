class EndPoints {
  static const String baserUrl = "http://192.168.1.7:8000/api/";
  static const String register = "users/register";
  static const String login = "users/login";
  static const String logout = "users/logout";
  static const String getCountry = "countries";
  static const String specialities = "specialities";
  static const String universities = "universities";
  static const String getLanguages = "languages";
  static const String forgotPassword = "users/password/email";
  static const String checkCodeResetPassword = "users/password/code-check";
  static const String resetPassword = "users/password/reset";
  static const String verfiyOtp = "users/otp/verify";
  static const String resendOtp = "users/otp/resend";
  static const String changePassword = "users/change-password";
  static const String updateProfile = "users/update-profile";
  static const String updateProfileImage = "users/update-profile-image";
  static const String educations = "educations";
  static const String levels = "levels";
  static const String skills = "skills";
  static const String jobTitle = "job_titles";
  static const String profile = "users/show-profile";
  static const String showMyProfile = "users/show-my-profile";
  static const String startQuiz = "quizzes/start-quiz/";
  static const String processAnswer = "quizzes/process-answer";
  static const String calculateQuizResult = "quizzes/result";
  static const String createQuiz = "quizzes/create";
  static const String getComment = "comments";
  static const String createComment = "comments/create";
  static const String addComment= "comments/create";
  static const String updateComment = "comments/update";
  static const String deleteComment = "comments/delete";
  static const String deleteCommentForTeacher = "comments/teacher";
  static const String getMoreComment = "comments/load-more";
  static const String getMyComment   = "comments/get-my-comments";
  static const String addLike   = "comments/like";
  static const String removeLike   = "comments/remove-like";
  static const String replies   = "replies";
  static const String deleteReply   = "replies/delete";
  static const String updateReply = "replies/update";
  static const String createReplies   = "replies/create";
  static const String deleteReplieyForTeacher   = "replies/teacher";
  static const String LikeReply   = "replies/like";
  static const String allCourses   = "courses";
  static const String showCourse   = "courses";
  static const String showCourseForTecher  = "courses/teacher";
  static const String getCopyForCourse = "courses/get-copy-of-course";
  static const String showCourseForStudent   = "courses/student";
  static const String getEpisodesForStudent  = "episodes/student";
  static const String showEpisodesForStudent  = "episodes/show/student";
  static const String getEpisodesFortetcher = "episodes/teacher";
  static const String showEpisodesFortetcher  = "episodes/show/teacher";
  static const String paidCourses  = "courses/paid";
  static const String freeCourses  = "courses/free";
  static const String searchCourse  = "courses/search";
  static const String getCourseByCategory= "courses/category";
  static const String getCourseByTopic= "courses/topic";
  static const String loadMoreCourse  = "courses/load-more";
  static const String categories = "categories";
  static const String topicsInCategory = "topics";
  static const String createCourse = "courses/create-draft";
  static const String deleteEpisode=  "episodes/delete";
  static const String deleteCourse = "courses/soft-delete";
  static const String restoreCourse = "courses/restore";
  static const String draftCourses= "courses/draft";
  static const String pendingCourses= "courses/pending";
  static const String approvedCourses = "courses/approved";
  static const String rejectedCourses = "courses/rejected";
  static const String deletedCourses = "courses/deleted";
  static const String updateDraftCourse = "courses/update-draft";
  static const String updateApprovedCourse= "courses/update-approved";
  static const String publishCourse = "courses/submit";
  static const String coursesWithArrangement = "courses/with-arrangement";
  static const String rateCourse = "courses/evaluation";
  static const String coursesfollowed = "courses/followed";
  static const String finishEpisode= "episodes/finish";
  static const String LikeEpisode = "episodes/like";
  static const String updateEpisode = "episodes/update";
  static const String statistics = "statistics/get-my-statistics";
  static const String statisticsEnthusiasm = "statistics/get-enthusiasm";
  static const String badges = "badges/get";
  static const String getPoster = "episodes/get_poster";
  static const String getVideo = "episodes/get_video";
  static const String repostCourse = "courses/repost-course";
  static const String cancelUpdate = "courses/cancel-updating";
  static const String createEpisode = "episodes/create";
  static const String updateQuiz = "quizzes/update";
  static const String deleteQuiz = "quizzes/delete";
  static const String updateCourse = "courses/update-course";
  static const String deleteDraftCourse = "courses/delete-draft";
  static const String promoteStudent =  "users/promote-student-to-teacher";
  static const String createPaymentIntent = "orders/create-payment-intent";
  static const String enrollFreeCourse= "courses/enroll-in-free-course";
  static const String getPdf = "episodes/get-file";
  static const String deletePdf = "episodes/delete-file";
  static const String downloadFile = "episodes/download-file";
  static const String getCertificate = "courses/get-certificate";



}

class ApiKey {
 
  static String firstName=  "first_name";
  static String accesstoken=  "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5Zjc3MWUwYy05NzhjLTQ0MjItYjM1NS05YTc4NGEwZTgxNDEiLCJqdGkiOiIzZjBmOTYwMDljYjVkOTNhMzU0MTE1YzAwNTM4NWE2ZmFhMTQ2OTU0M2NhMjdhNDQxYWYyM2Q2N2EwNmVlNjQwMzc5M2U5OTMyOTRlNjRlNyIsImlhdCI6MTc1MzMzOTYyOS4yNjEwOTksIm5iZiI6MTc1MzMzOTYyOS4yNjExMDUsImV4cCI6MTc4NDg3NTYyOS4yMjg4MTUsInN1YiI6IjQiLCJzY29wZXMiOltdfQ.SRPMbHh36vVBB9sd3eWIt0eo9z34xxrBztf5rTKD0_oqJqazXWuQSdttCEVF_4R7it0nYUnMhbiWlGWJgh0gwh9tGWQo9YMMS4dMpioLePifyf9g6mxFcMqpryBER4tElxxr9it1lgZLPaZg5vUgs-hU9GEbaffHhSypvtwV-29PAZvWmKv9jgo3AZaOOUr2HClrSC86uL5gf4ZMUn9hAsBXwA6VgkA2-QhhHAxSartWow6f8Sd6RAEcCqTjaNzJykGiizAMhceHMcxLyH5YAqcTMS6d59zV8TfBHhhHLUkwKCXsBSCgKfX80yELRzsLwZtStin0TdvR_i7f_DYTn6D1KVKdPTWb5obGbVfAtDKm3i33_qzgZkhDxA7StvYcjqKu2pDd3-ObBnN_9JfPPLgU3g5qK0RWY2GI2_TwRnws32Krkd125DpXWriIraABrs2m1WeCAPBLvgtjeuvYX6bGD5ONOX_7GYigeubkKKA8JOs7DK0zhPbVgiloVUG_ivk7z5YtjyVkoul3NyvaoMtJgik7TmapowvkcuybsGDoUGK9A0YABCqCEgYodRjP6VJZXuyJHBZC-XXtiVQhsLR-K1_zyzlaH0cDViBZN0StD6X_7Dd09IDPzawRu49vX1YoPoGHQM7SfGXcRBlh4Mvr3O1BTRpTuQR_w4pM_L0";
  static String message=  "message";
  static String lastName = "last_name";
  static String email = "email";
  static String password = "password";
  static String passwordConfirm = "password_confirmation";
  static String countryId = "country_id";
  static String languageId = "language_id";
  static String country = "country";
  static String user = "user";
  static String token = "token";
  static String profileImageUrl = "profile_image_url";
  static String otpCode = "otp_code";
  static String role = "role";
  static String languages= "languages";
  static String jobTitle = "job_title";
  static String title = "title";
  static String jobTitleID = "job_title_id";
  static String linkedInUrl = "linked_in_url";
  static String education = "education";
  static String university = "university";
  static String speciality = "speciality";
  static String workExperience= "work_experience";
  static String skills = "skills";
  static String code = "code";
  static String level = "level";
  static String skillId = "skill_id";

  static String oldPassword = "old_password";
  static String newPassword = "new_password";
  static String newPasswordConfirmation= "new_password_confirmation";


  static String id = "id";
  static String name = "name";
  static String data = "data";

  static String publishingRequestDate = "publishing_request_date";
  static String createdAt = "created_at";

  static String questionId = "question_id";
  static String quizId = "quiz_id";
  static String questionNumber = "question_number";
  static String numOfQuestions = "num_of_questions";
  static String questions = "questions";
  static String content = "content";
  static String answerA = "answer_a";
  static String answerB = "answer_b";
  static String answerC = "answer_c";
  static String answerD = "answer_d";

  static String isCorrect = "is_correct";
  static String rightAnswer = "right_answer";
  static String explanation = "explanation";


  static String mark = "mark";
  static String percentageMark = "percentage_mark";
  static String answer = "answer";

  static String episodeId= "episode_id";


  static String numOfReplies= "num_of_replies";
  static String commentDate= "comment_date";
  static String likes= "likes";
  static String fullName= "full_name";
  static String meta= "meta";

  static String currentPage= "current_page";
  static String hasMorePages= "has_more_pages";
  static String nextPage= "next_page";

  static String commentId= "comment_id";
  static String replyDate= "reply_date";

  static String description= "description";
  static String imageUrl= "image_url";
  static String teacherId= "teacher_id";
  static String difficultyLevel= "difficulty_level";
  static String numOfHours= "num_of_hours";
  static String price= "price";
  static String rate= "rate";
  static String numOfEpisodes= "num_of_episodes";
  static String publishingDate= "publishing_date";
  static String hasCertificate= "has_certificate";
  static String totalQuizes= "total_quizzes";
  static String deletedAt= "deleted_at";

  
  


}
