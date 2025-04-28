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
