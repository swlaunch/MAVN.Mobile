import 'package:flutter/widgets.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';

const supportedLocalesCodes = ['en', 'de'];
final appSupportedLocales = supportedLocalesCodes.map((code) => Locale(code));

class AppLocalizationsDelegate extends LocalizationsDelegate<LocalizedStrings> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      supportedLocalesCodes.contains(locale.languageCode);

  @override
  Future<LocalizedStrings> load(Locale locale) => LocalizedStrings.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<LocalizedStrings> old) => false;
}
