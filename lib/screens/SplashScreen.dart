import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/screens/DashBoardScreen.dart';
import 'package:bookkart_author/screens/SignInScreen.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppCommon.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:bookkart_author/utils/AppImages.dart';
import 'package:bookkart_author/utils/AppLocalizations.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(appStore.isDarkModeOn ? appBackgroundColorDark : white);
    appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN));
    checkFirstSeen();
  }

  Future<void> checkFirstSeen() async {
    await Future.delayed(Duration(seconds: 2));

    await Future.delayed(Duration(seconds: 2));

    if (appStore.isLoggedIn) {
      currentUrl = isVendor ? vendorUrl : adminUrl;
      if (!getBoolAsync(REMEMBER_PASSWORD, defaultValue: true)) {
        appStore.setLoggedIn(false);
        DashBoardScreen().launch(context, isNewTask: true);
      } else {
        DashBoardScreen().launch(context, isNewTask: true);
      }
    } else {
      SignInScreen().launch(context, isNewTask: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
                Container(
                  width: 120,
                  height: 120,
                  padding: EdgeInsets.all(8),
                  decoration: boxDecorationRoundedWithShadow(10),
                  child: Image.asset(app_logo),
                )          ,
                16.height,
          Text("EBIZ Manage", style: boldTextStyle()),
        ],
      ).center(),
    );
  }
}
