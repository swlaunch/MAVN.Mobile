import 'package:flutter/widgets.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<void> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en'].contains(locale.languageCode);

  @override
  Future<void> load(Locale locale) => LocalizedStrings.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<void> old) => false;
}
