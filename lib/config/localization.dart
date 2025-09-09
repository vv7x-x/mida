import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Map<String, String> _localizedStrings = {};

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString(
      'lib/lang/${locale.languageCode}.json',
    );
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // Common translations
  String get appName => translate('app_name');
  String get login => translate('login');
  String get register => translate('register');
  String get username => translate('username');
  String get password => translate('password');
  String get fullName => translate('full_name');
  String get studentPhone => translate('student_phone');
  String get parentPhone => translate('parent_phone');
  String get educationStage => translate('education_stage');
  String get age => translate('age');
  String get learningCenter => translate('learning_center');
  String get nationalId => translate('national_id');
  String get dashboard => translate('dashboard');
  String get announcements => translate('announcements');
  String get schedule => translate('schedule');
  String get qrCode => translate('qr_code');
  String get settings => translate('settings');
  String get logout => translate('logout');
  String get darkMode => translate('dark_mode');
  String get lightMode => translate('light_mode');
  String get language => translate('language');
  String get arabic => translate('arabic');
  String get english => translate('english');
  String get save => translate('save');
  String get cancel => translate('cancel');
  String get submit => translate('submit');
  String get loading => translate('loading');
  String get error => translate('error');
  String get success => translate('success');
  String get warning => translate('warning');
  String get info => translate('info');
  String get noData => translate('no_data');
  String get refresh => translate('refresh');
  String get retry => translate('retry');
  String get close => translate('close');
  String get ok => translate('ok');
  String get yes => translate('yes');
  String get no => translate('no');
  String get confirm => translate('confirm');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get view => translate('view');
  String get add => translate('add');
  String get update => translate('update');
  String get search => translate('search');
  String get filter => translate('filter');
  String get sort => translate('sort');
  String get clear => translate('clear');
  String get selectImage => translate('select_image');
  String get camera => translate('camera');
  String get gallery => translate('gallery');
  String get uploadImage => translate('upload_image');
  String get required => translate('required');
  String get invalidEmail => translate('invalid_email');
  String get invalidPhone => translate('invalid_phone');
  String get passwordTooShort => translate('password_too_short');
  String get passwordsDoNotMatch => translate('passwords_do_not_match');
  String get loginSuccess => translate('login_success');
  String get loginFailed => translate('login_failed');
  String get registrationSuccess => translate('registration_success');
  String get registrationFailed => translate('registration_failed');
  String get accountPending => translate('account_pending');
  String get accountApproved => translate('account_approved');
  String get accountRejected => translate('account_rejected');
  String get networkError => translate('network_error');
  String get serverError => translate('server_error');
  String get unknownError => translate('unknown_error');
  String get noInternet => translate('no_internet');
  String get timeoutError => translate('timeout_error');
  String get teacherNews => translate('teacher_news');
  String get newAnnouncement => translate('new_announcement');
  String get scheduleChanged => translate('schedule_changed');
  String get attendanceMarked => translate('attendance_marked');
  String get profileUpdated => translate('profile_updated');
  String get notificationSettings => translate('notification_settings');
  String get enableNotifications => translate('enable_notifications');
  String get disableNotifications => translate('disable_notifications');
  String get theme => translate('theme');
  String get systemTheme => translate('system_theme');
  String get about => translate('about');
  String get version => translate('version');
  String get developer => translate('developer');
  String get contact => translate('contact');
  String get feedback => translate('feedback');
  String get rateApp => translate('rate_app');
  String get shareApp => translate('share_app');
  String get privacyPolicy => translate('privacy_policy');
  String get termsOfService => translate('terms_of_service');
  String get help => translate('help');
  String get faq => translate('faq');
  String get support => translate('support');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
