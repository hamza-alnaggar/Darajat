// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Learn Anytime, Anywhere`
  String get on_boarding_title_page_one {
    return Intl.message(
      'Learn Anytime, Anywhere',
      name: 'on_boarding_title_page_one',
      desc: '',
      args: [],
    );
  }

  /// `Interactive Lessons`
  String get on_boarding_title_page_two {
    return Intl.message(
      'Interactive Lessons',
      name: 'on_boarding_title_page_two',
      desc: '',
      args: [],
    );
  }

  /// `Learn with Top Instructors`
  String get on_boarding_title_page_three {
    return Intl.message(
      'Learn with Top Instructors',
      name: 'on_boarding_title_page_three',
      desc: '',
      args: [],
    );
  }

  /// `Start Your Journey Today`
  String get on_boarding_title_page_four {
    return Intl.message(
      'Start Your Journey Today',
      name: 'on_boarding_title_page_four',
      desc: '',
      args: [],
    );
  }

  /// `Your smart learning platform is here to help you grow.`
  String get on_boarding_sub_title_page_one {
    return Intl.message(
      'Your smart learning platform is here to help you grow.',
      name: 'on_boarding_sub_title_page_one',
      desc: '',
      args: [],
    );
  }

  /// `Engaging and simplified lessons for all levels.`
  String get on_boarding_sub_title_page_two {
    return Intl.message(
      'Engaging and simplified lessons for all levels.',
      name: 'on_boarding_sub_title_page_two',
      desc: '',
      args: [],
    );
  }

  /// `Guidance from experts and professionals throughout your journey.`
  String get on_boarding_sub_title_page_three {
    return Intl.message(
      'Guidance from experts and professionals throughout your journey.',
      name: 'on_boarding_sub_title_page_three',
      desc: '',
      args: [],
    );
  }

  /// `Join thousands of learners and achieve your goals.`
  String get on_boarding_sub_title_page_four {
    return Intl.message(
      'Join thousands of learners and achieve your goals.',
      name: 'on_boarding_sub_title_page_four',
      desc: '',
      args: [],
    );
  }

  /// `delete`
  String get delete {
    return Intl.message('delete', name: 'delete', desc: '', args: []);
  }

  /// `Question`
  String get question {
    return Intl.message('Question', name: 'question', desc: '', args: []);
  }

  /// `Please enter an answer`
  String get enter_answer {
    return Intl.message(
      'Please enter an answer',
      name: 'enter_answer',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message('Clear', name: 'clear', desc: '', args: []);
  }

  /// `Answer`
  String get answer {
    return Intl.message('Answer', name: 'answer', desc: '', args: []);
  }

  /// `Please enter the question`
  String get enter_question {
    return Intl.message(
      'Please enter the question',
      name: 'enter_question',
      desc: '',
      args: [],
    );
  }

  /// `Type your question here...`
  String get enter_question_hint {
    return Intl.message(
      'Type your question here...',
      name: 'enter_question_hint',
      desc: '',
      args: [],
    );
  }

  /// `Answers`
  String get answers {
    return Intl.message('Answers', name: 'answers', desc: '', args: []);
  }

  /// `My courses`
  String get my_courses {
    return Intl.message('My courses', name: 'my_courses', desc: '', args: []);
  }

  /// `Loading courses...`
  String get loading_courses {
    return Intl.message(
      'Loading courses...',
      name: 'loading_courses',
      desc: '',
      args: [],
    );
  }

  /// `Error loading courses`
  String get error_loading_courses {
    return Intl.message(
      'Error loading courses',
      name: 'error_loading_courses',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Create your first course to get started`
  String get create_first_course {
    return Intl.message(
      'Create your first course to get started',
      name: 'create_first_course',
      desc: '',
      args: [],
    );
  }

  /// `Create Course`
  String get create_course {
    return Intl.message(
      'Create Course',
      name: 'create_course',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `My courses arrange`
  String get my_courses_arrange {
    return Intl.message(
      'My courses arrange',
      name: 'my_courses_arrange',
      desc: '',
      args: [],
    );
  }

  /// `Approved`
  String get status_approved {
    return Intl.message(
      'Approved',
      name: 'status_approved',
      desc: '',
      args: [],
    );
  }

  /// `Draft`
  String get status_draft {
    return Intl.message('Draft', name: 'status_draft', desc: '', args: []);
  }

  /// `Pending`
  String get status_pending {
    return Intl.message('Pending', name: 'status_pending', desc: '', args: []);
  }

  /// `Rejected`
  String get status_rejected {
    return Intl.message(
      'Rejected',
      name: 'status_rejected',
      desc: '',
      args: [],
    );
  }

  /// `Deleted`
  String get status_deleted {
    return Intl.message('Deleted', name: 'status_deleted', desc: '', args: []);
  }

  /// `Categories`
  String get categories {
    return Intl.message('Categories', name: 'categories', desc: '', args: []);
  }

  /// `Category Courses`
  String get category_courses {
    return Intl.message(
      'Category Courses',
      name: 'category_courses',
      desc: '',
      args: [],
    );
  }

  /// `No courses found in this category`
  String get no_courses_in_category {
    return Intl.message(
      'No courses found in this category',
      name: 'no_courses_in_category',
      desc: '',
      args: [],
    );
  }

  /// `Check other categories for more courses`
  String get check_other_categories {
    return Intl.message(
      'Check other categories for more courses',
      name: 'check_other_categories',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get Languages {
    return Intl.message('Languages', name: 'Languages', desc: '', args: []);
  }

  /// `Skills`
  String get Skills {
    return Intl.message('Skills', name: 'Skills', desc: '', args: []);
  }

  /// `Badges`
  String get Badges {
    return Intl.message('Badges', name: 'Badges', desc: '', args: []);
  }

  /// `App Language`
  String get App_Language {
    return Intl.message(
      'App Language',
      name: 'App_Language',
      desc: '',
      args: [],
    );
  }

  /// `Become a Teacher`
  String get Become_a_Teacher {
    return Intl.message(
      'Become a Teacher',
      name: 'Become_a_Teacher',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get Sign_Out {
    return Intl.message('Sign Out', name: 'Sign_Out', desc: '', args: []);
  }

  /// `Add Language`
  String get Add_Language {
    return Intl.message(
      'Add Language',
      name: 'Add_Language',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to upgrade to a teacher account? This will give you access to create courses and manage students.`
  String get Are_you_sure_you_want_to_upgrade {
    return Intl.message(
      'Are you sure you want to upgrade to a teacher account? This will give you access to create courses and manage students.',
      name: 'Are_you_sure_you_want_to_upgrade',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get Cancel {
    return Intl.message('Cancel', name: 'Cancel', desc: '', args: []);
  }

  /// `Upgrade`
  String get Upgrade {
    return Intl.message('Upgrade', name: 'Upgrade', desc: '', args: []);
  }

  /// `Account Upgraded!`
  String get Account_Upgraded {
    return Intl.message(
      'Account Upgraded!',
      name: 'Account_Upgraded',
      desc: '',
      args: [],
    );
  }

  /// `You're now a verified teacher. Start creating your first course!`
  String get You_are_now_a_verified_teacher {
    return Intl.message(
      'You\'re now a verified teacher. Start creating your first course!',
      name: 'You_are_now_a_verified_teacher',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get Get_Started {
    return Intl.message('Get Started', name: 'Get_Started', desc: '', args: []);
  }

  /// `Are you sure you want to sign out?`
  String get Are_you_sure_you_want_to_sign_out {
    return Intl.message(
      'Are you sure you want to sign out?',
      name: 'Are_you_sure_you_want_to_sign_out',
      desc: '',
      args: [],
    );
  }

  /// `navigate to teacher view`
  String get teacher_view {
    return Intl.message(
      'navigate to teacher view',
      name: 'teacher_view',
      desc: '',
      args: [],
    );
  }

  /// `navigate to student view`
  String get student_view {
    return Intl.message(
      'navigate to student view',
      name: 'student_view',
      desc: '',
      args: [],
    );
  }

  /// `Flame of Enthusiasm`
  String get flame {
    return Intl.message(
      'Flame of Enthusiasm',
      name: 'flame',
      desc: '',
      args: [],
    );
  }

  /// `Discover Courses`
  String get discover_courses {
    return Intl.message(
      'Discover Courses',
      name: 'discover_courses',
      desc: '',
      args: [],
    );
  }

  /// `All Categories`
  String get all_categories {
    return Intl.message(
      'All Categories',
      name: 'all_categories',
      desc: '',
      args: [],
    );
  }

  /// `Search Results`
  String get search_results {
    return Intl.message(
      'Search Results',
      name: 'search_results',
      desc: '',
      args: [],
    );
  }

  /// `Search courses`
  String get search_courses_hint {
    return Intl.message(
      'Search courses',
      name: 'search_courses_hint',
      desc: '',
      args: [],
    );
  }

  /// `No courses found`
  String get no_courses_found {
    return Intl.message(
      'No courses found',
      name: 'no_courses_found',
      desc: '',
      args: [],
    );
  }

  /// `Try different keywords or browse categories`
  String get try_different_keywords {
    return Intl.message(
      'Try different keywords or browse categories',
      name: 'try_different_keywords',
      desc: '',
      args: [],
    );
  }

  /// `Clear Search`
  String get clear_search {
    return Intl.message(
      'Clear Search',
      name: 'clear_search',
      desc: '',
      args: [],
    );
  }

  /// `Premium Courses`
  String get premium_courses {
    return Intl.message(
      'Premium Courses',
      name: 'premium_courses',
      desc: '',
      args: [],
    );
  }

  /// `Courses`
  String get courses {
    return Intl.message('Courses', name: 'courses', desc: '', args: []);
  }

  /// `Failed to load courses`
  String get failed_to_load_courses {
    return Intl.message(
      'Failed to load courses',
      name: 'failed_to_load_courses',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get try_again {
    return Intl.message('Try Again', name: 'try_again', desc: '', args: []);
  }

  /// `No courses available`
  String get no_courses_available {
    return Intl.message(
      'No courses available',
      name: 'no_courses_available',
      desc: '',
      args: [],
    );
  }

  /// `Check back later for new courses`
  String get check_back_later {
    return Intl.message(
      'Check back later for new courses',
      name: 'check_back_later',
      desc: '',
      args: [],
    );
  }

  /// `Browse our curated collection`
  String get browse_curated_collection {
    return Intl.message(
      'Browse our curated collection',
      name: 'browse_curated_collection',
      desc: '',
      args: [],
    );
  }

  /// `You've reached the end`
  String get end_of_list {
    return Intl.message(
      'You\'ve reached the end',
      name: 'end_of_list',
      desc: '',
      args: [],
    );
  }

  /// `Exit App`
  String get exitApp {
    return Intl.message('Exit App', name: 'exitApp', desc: '', args: []);
  }

  /// `Are you sure you want to exit?`
  String get exitAppConfirmation {
    return Intl.message(
      'Are you sure you want to exit?',
      name: 'exitAppConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Exit`
  String get exit {
    return Intl.message('Exit', name: 'exit', desc: '', args: []);
  }

  /// `Darajat`
  String get app_name {
    return Intl.message('Darajat', name: 'app_name', desc: '', args: []);
  }

  /// `Free Courses`
  String get free_courses {
    return Intl.message(
      'Free Courses',
      name: 'free_courses',
      desc: '',
      args: [],
    );
  }

  /// `Paid Courses`
  String get paid_courses {
    return Intl.message(
      'Paid Courses',
      name: 'paid_courses',
      desc: '',
      args: [],
    );
  }

  /// `All Courses`
  String get all_courses {
    return Intl.message('All Courses', name: 'all_courses', desc: '', args: []);
  }

  /// `See All`
  String get see_all {
    return Intl.message('See All', name: 'see_all', desc: '', args: []);
  }

  /// `Create new account`
  String get create_new_account {
    return Intl.message(
      'Create new account',
      name: 'create_new_account',
      desc: '',
      args: [],
    );
  }

  /// `Login with your account`
  String get login_with_your_account {
    return Intl.message(
      'Login with your account',
      name: 'login_with_your_account',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Already have an account ?`
  String get already_have_an_account {
    return Intl.message(
      'Already have an account ?',
      name: 'already_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `Login here !`
  String get login_here {
    return Intl.message('Login here !', name: 'login_here', desc: '', args: []);
  }

  /// `Dont have an account ?`
  String get Dont_have_an_account {
    return Intl.message(
      'Dont have an account ?',
      name: 'Dont_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `Register here !`
  String get register_here {
    return Intl.message(
      'Register here !',
      name: 'register_here',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Fist Name`
  String get fist_name {
    return Intl.message('Fist Name', name: 'fist_name', desc: '', args: []);
  }

  /// `Last Nmae`
  String get last_name {
    return Intl.message('Last Nmae', name: 'last_name', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `passwordConfirmation`
  String get password_confirmation {
    return Intl.message(
      'passwordConfirmation',
      name: 'password_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Verify Otp`
  String get verify_otp {
    return Intl.message('Verify Otp', name: 'verify_otp', desc: '', args: []);
  }

  /// `Forget Password`
  String get forget_password {
    return Intl.message(
      'Forget Password',
      name: 'forget_password',
      desc: '',
      args: [],
    );
  }

  /// `Check email`
  String get check_email {
    return Intl.message('Check email', name: 'check_email', desc: '', args: []);
  }

  /// `Check code`
  String get check_code {
    return Intl.message('Check code', name: 'check_code', desc: '', args: []);
  }

  /// `Set password`
  String get set_password {
    return Intl.message(
      'Set password',
      name: 'set_password',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get change_password {
    return Intl.message(
      'Change password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Password change Successfully`
  String get password_change_successfully {
    return Intl.message(
      'Password change Successfully',
      name: 'password_change_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Current password`
  String get current_password {
    return Intl.message(
      'Current password',
      name: 'current_password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter you current password`
  String get please_enter_your_current_password {
    return Intl.message(
      'Please enter you current password',
      name: 'please_enter_your_current_password',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get new_Password {
    return Intl.message(
      'New password',
      name: 'new_Password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm new password`
  String get Confirm_New_Password {
    return Intl.message(
      'Confirm new password',
      name: 'Confirm_New_Password',
      desc: '',
      args: [],
    );
  }

  /// `password do not match`
  String get Passwords_do_not_match {
    return Intl.message(
      'password do not match',
      name: 'Passwords_do_not_match',
      desc: '',
      args: [],
    );
  }

  /// `password must contain`
  String get Password_must_contain {
    return Intl.message(
      'password must contain',
      name: 'Password_must_contain',
      desc: '',
      args: [],
    );
  }

  /// `one special character`
  String get One_special_character {
    return Intl.message(
      'one special character',
      name: 'One_special_character',
      desc: '',
      args: [],
    );
  }

  /// `one number`
  String get One_number {
    return Intl.message('one number', name: 'One_number', desc: '', args: []);
  }

  /// `one uppercase letter`
  String get One_uppercase_letter {
    return Intl.message(
      'one uppercase letter',
      name: 'One_uppercase_letter',
      desc: '',
      args: [],
    );
  }

  /// `at least 8 characters`
  String get At_least_8_characters {
    return Intl.message(
      'at least 8 characters',
      name: 'At_least_8_characters',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Teacher Rules and Guidelines`
  String get Teacher_Rules {
    return Intl.message(
      'Teacher Rules and Guidelines',
      name: 'Teacher_Rules',
      desc: '',
      args: [],
    );
  }

  /// `Technical Quality Standards`
  String get Technical_Quality_Standards {
    return Intl.message(
      'Technical Quality Standards',
      name: 'Technical_Quality_Standards',
      desc: '',
      args: [],
    );
  }

  /// `Educational Value and Content Quality`
  String get Educational_Value {
    return Intl.message(
      'Educational Value and Content Quality',
      name: 'Educational_Value',
      desc: '',
      args: [],
    );
  }

  /// `Legal and Policy Compliance`
  String get Legal_Compliance {
    return Intl.message(
      'Legal and Policy Compliance',
      name: 'Legal_Compliance',
      desc: '',
      args: [],
    );
  }

  /// `Student Engagement`
  String get Student_Engagement {
    return Intl.message(
      'Student Engagement',
      name: 'Student_Engagement',
      desc: '',
      args: [],
    );
  }

  /// `Monetization (If Applicable)`
  String get Monetization {
    return Intl.message(
      'Monetization (If Applicable)',
      name: 'Monetization',
      desc: '',
      args: [],
    );
  }

  /// `Review and Publication Process`
  String get Review_Process {
    return Intl.message(
      'Review and Publication Process',
      name: 'Review_Process',
      desc: '',
      args: [],
    );
  }

  /// `I have read and agree to all the terms and conditions`
  String get Accept_Rules {
    return Intl.message(
      'I have read and agree to all the terms and conditions',
      name: 'Accept_Rules',
      desc: '',
      args: [],
    );
  }

  /// `Accept and Continue`
  String get Accept_And_Continue {
    return Intl.message(
      'Accept and Continue',
      name: 'Accept_And_Continue',
      desc: '',
      args: [],
    );
  }

  /// `All video lessons must be recorded in High Definition (HD), with a minimum resolution of 720p.`
  String get Rule_1_1 {
    return Intl.message(
      'All video lessons must be recorded in High Definition (HD), with a minimum resolution of 720p.',
      name: 'Rule_1_1',
      desc: '',
      args: [],
    );
  }

  /// `All audio must be clear, audible, and free from background noise and distortions.`
  String get Rule_1_2 {
    return Intl.message(
      'All audio must be clear, audible, and free from background noise and distortions.',
      name: 'Rule_1_2',
      desc: '',
      args: [],
    );
  }

  /// `Courses must be produced using adequate equipment to ensure professional audio and video quality.`
  String get Rule_1_3 {
    return Intl.message(
      'Courses must be produced using adequate equipment to ensure professional audio and video quality.',
      name: 'Rule_1_3',
      desc: '',
      args: [],
    );
  }

  /// `The course must have clear, defined learning objectives and outcomes for students.`
  String get Rule_2_1 {
    return Intl.message(
      'The course must have clear, defined learning objectives and outcomes for students.',
      name: 'Rule_2_1',
      desc: '',
      args: [],
    );
  }

  /// `All course content must be original, created by you, and provide genuine educational value.`
  String get Rule_2_2 {
    return Intl.message(
      'All course content must be original, created by you, and provide genuine educational value.',
      name: 'Rule_2_2',
      desc: '',
      args: [],
    );
  }

  /// `The course must be well-structured with a logical sequence of modules and lessons.`
  String get Rule_2_3 {
    return Intl.message(
      'The course must be well-structured with a logical sequence of modules and lessons.',
      name: 'Rule_2_3',
      desc: '',
      args: [],
    );
  }

  /// `You affirm that you own or possess the necessary legal rights to all content you publish, including videos, text, and resources.`
  String get Rule_3_1 {
    return Intl.message(
      'You affirm that you own or possess the necessary legal rights to all content you publish, including videos, text, and resources.',
      name: 'Rule_3_1',
      desc: '',
      args: [],
    );
  }

  /// `You agree not to post any content that is illegal, offensive, infringes on intellectual property rights, or violates our platform's policies.`
  String get Rule_3_2 {
    return Intl.message(
      'You agree not to post any content that is illegal, offensive, infringes on intellectual property rights, or violates our platform\'s policies.',
      name: 'Rule_3_2',
      desc: '',
      args: [],
    );
  }

  /// `You commit to actively engaging with your students by responding to questions in the Q&A section within a reasonable timeframe.`
  String get Rule_4_1 {
    return Intl.message(
      'You commit to actively engaging with your students by responding to questions in the Q&A section within a reasonable timeframe.',
      name: 'Rule_4_1',
      desc: '',
      args: [],
    );
  }

  /// `You agree to consider student feedback for the continual improvement of your course content.`
  String get Rule_4_2 {
    return Intl.message(
      'You agree to consider student feedback for the continual improvement of your course content.',
      name: 'Rule_4_2',
      desc: '',
      args: [],
    );
  }

  /// `If you choose to offer a paid course, you agree to the platform's revenue share model as defined in the pricing and payments policy.`
  String get Rule_5_1 {
    return Intl.message(
      'If you choose to offer a paid course, you agree to the platform\'s revenue share model as defined in the pricing and payments policy.',
      name: 'Rule_5_1',
      desc: '',
      args: [],
    );
  }

  /// `The course price must be set within the allowed price tiers specified by the platform.`
  String get Rule_5_2 {
    return Intl.message(
      'The course price must be set within the allowed price tiers specified by the platform.',
      name: 'Rule_5_2',
      desc: '',
      args: [],
    );
  }

  /// `You understand and accept that every course must be submitted for review and approved by the platform's administration before it is published.`
  String get Rule_6_1 {
    return Intl.message(
      'You understand and accept that every course must be submitted for review and approved by the platform\'s administration before it is published.',
      name: 'Rule_6_1',
      desc: '',
      args: [],
    );
  }

  /// `The platform reserves the right to reject or remove any course that does not meet the quality standards or violates these terms without prior notice.`
  String get Rule_6_2 {
    return Intl.message(
      'The platform reserves the right to reject or remove any course that does not meet the quality standards or violates these terms without prior notice.',
      name: 'Rule_6_2',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
