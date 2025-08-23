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

  /// `Title In Page One`
  String get on_boarding_title_page_one {
    return Intl.message(
      'Title In Page One',
      name: 'on_boarding_title_page_one',
      desc: '',
      args: [],
    );
  }

  /// `Title In Page Two`
  String get on_boarding_title_page_two {
    return Intl.message(
      'Title In Page Two',
      name: 'on_boarding_title_page_two',
      desc: '',
      args: [],
    );
  }

  /// `Title In Page Three`
  String get on_boarding_title_page_three {
    return Intl.message(
      'Title In Page Three',
      name: 'on_boarding_title_page_three',
      desc: '',
      args: [],
    );
  }

  /// `Title In Page Four`
  String get on_boarding_title_page_four {
    return Intl.message(
      'Title In Page Four',
      name: 'on_boarding_title_page_four',
      desc: '',
      args: [],
    );
  }

  /// `Sub Title In Page One`
  String get on_boarding_sub_title_page_one {
    return Intl.message(
      'Sub Title In Page One',
      name: 'on_boarding_sub_title_page_one',
      desc: '',
      args: [],
    );
  }

  /// `Sub Title In Page Two`
  String get on_boarding_sub_title_page_two {
    return Intl.message(
      'Sub Title In Page Two',
      name: 'on_boarding_sub_title_page_two',
      desc: '',
      args: [],
    );
  }

  /// `Sub Title In Page Three`
  String get on_boarding_sub_title_page_three {
    return Intl.message(
      'Sub Title In Page Three',
      name: 'on_boarding_sub_title_page_three',
      desc: '',
      args: [],
    );
  }

  /// `Sub Title In Page Four`
  String get on_boarding_sub_title_page_four {
    return Intl.message(
      'Sub Title In Page Four',
      name: 'on_boarding_sub_title_page_four',
      desc: '',
      args: [],
    );
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

  /// `Discover Courses`
  String get discover_courses {
    return Intl.message(
      'Discover Courses',
      name: 'discover_courses',
      desc: '',
      args: [],
    );
  }

  /// `Top Categories`
  String get top_categories {
    return Intl.message(
      'Top Categories',
      name: 'top_categories',
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
