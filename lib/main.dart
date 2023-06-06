import 'dart:async';

import 'package:bookkart_author/local/AppLocalizations.dart';
import 'package:bookkart_author/local/Languages.dart';
import 'package:bookkart_author/screens/NoInternetScreen.dart';
import 'package:bookkart_author/screens/SplashScreen.dart';
import 'package:bookkart_author/store/AppStore.dart';
import 'package:bookkart_author/store/Download/DownloadStore.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppCommon.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import 'utils/AppTheme.dart';

AppStore appStore = AppStore();
BaseLanguage? language;
bool? isCurrentlyOnNoInternet = false;
List<String> Permission = [];
DownloadStore downloadStore = DownloadStore();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp().then((value) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  });

  await initialize(aLocaleLanguageList: languageList());

  defaultRadius = 16.0;
  defaultLoaderAccentColorGlobal = primaryColor;

  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));
  await appStore.setLanguage(getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: defaultLanguage));

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  void initState() {
    super.initState();

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((e) {
      if (e == ConnectivityResult.none) {
        push(NoInternetScreen());
      } else {
        pop();
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        navigatorKey: navigatorKey,
        navigatorObservers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics())],
        debugShowCheckedModeBanner: false,
        theme: !appStore.isDarkModeOn ? AppThemeData.lightTheme : AppThemeData.darkTheme,
        home: SplashScreen(),
        supportedLocales: LanguageDataModel.languageLocales(),
        localizationsDelegates: [AppLocalizations(), GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
        localeResolutionCallback: (locale, supportedLocales) => locale,
        locale: Locale(appStore.selectedLanguageCode),
        builder: scrollBehaviour(),
      ),
    );
  }
}
