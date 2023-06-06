import 'package:bookkart_author/local/LanguageAf.dart';
import 'package:bookkart_author/local/LanguageAr.dart';
import 'package:bookkart_author/local/LanguageDe.dart';
import 'package:bookkart_author/local/LanguageEn.dart';
import 'package:bookkart_author/local/LanguageEs.dart';
import 'package:bookkart_author/local/LanguageFr.dart';
import 'package:bookkart_author/local/LanguageHi.dart';
import 'package:bookkart_author/local/LanguageTr.dart';
import 'package:bookkart_author/local/LanguageVi.dart';
import 'package:bookkart_author/local/Languages.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class AppLocalizations extends LocalizationsDelegate<BaseLanguage> {
  const AppLocalizations();

  @override
  Future<BaseLanguage> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'af':
        return LanguageAf();
      case 'ar':
        return LanguageAr();
      case 'de':
        return LanguageDe();
      case 'en':
        return LanguageEn();
      case 'es':
        return LanguageEs();
      case 'fr':
        return LanguageFr();
      case 'hi':
        return LanguageHi();
      case 'tr':
        return LanguageTr();
      case 'vi':
        return LanguageVi();
      default:
        return LanguageEn();
    }
  }

  @override
  bool isSupported(Locale locale) => LanguageDataModel.languages().contains(locale.languageCode);

  @override
  bool shouldReload(LocalizationsDelegate<BaseLanguage> old) => false;
}
