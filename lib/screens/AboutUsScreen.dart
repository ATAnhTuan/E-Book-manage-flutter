import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppImages.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info/package_info.dart';

import '../main.dart';

class AboutUsScreen extends StatefulWidget {
  static String tag = '/AboutUsScreen';

  @override
  AboutUsScreenState createState() => AboutUsScreenState();
}

class AboutUsScreenState extends State<AboutUsScreen> {
  PackageInfo? package;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    package = await PackageInfo.fromPlatform();
  }

  @override
  void dispose() {
    super.dispose();
    if (appStore.isDarkModeOn) {
      setStatusBarColor(
        appBackgroundColorDark,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      );
    } else {
      setStatusBarColor(white, statusBarIconBrightness: Brightness.dark, statusBarBrightness: Brightness.light);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: appBarWidget(language!.aboutUs, showBack: true, color: appStore.isDarkModeOn ? cardDarkColor : Colors.white),
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              children: [
                16.height,
                Container(
                  width: 120,
                  height: 120,
                  padding: EdgeInsets.all(8),
                  decoration: boxDecorationRoundedWithShadow(10),
                  child: Image.asset(app_logo),
                ),
                16.height,
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (_, snap) {
                    if (snap.hasData) {
                      return Column(
                        children: [
                          Text('${snap.data!.appName.validate()}', style: boldTextStyle(color: appStore.isDarkModeOn ? white : primaryColor, size: 18)),
                          Text('${snap.data!.version.validate()}', style: secondaryTextStyle(size: 14))
                        ],
                      );
                    }
                    return SizedBox();
                  },
                ),
                8.height
              ],
            ).center(),
          ),
        ),
      ),
    );
  }
}
