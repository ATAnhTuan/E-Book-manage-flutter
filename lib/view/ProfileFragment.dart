import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/screens/AboutUsScreen.dart';
import 'package:bookkart_author/screens/AllCustomerListScreen.dart';
import 'package:bookkart_author/screens/CategoryScreen.dart';
import 'package:bookkart_author/screens/ProductAttributeScreen.dart';
import 'package:bookkart_author/screens/SignInScreen.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:bookkart_author/utils/AppImages.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';

import '../screens/LanguagesScreen.dart';
import '../screens/ProductReviewScreen.dart';

class ProfileFragment extends StatefulWidget {
  static String tag = '/ProfileFragment';

  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<bool> deal() async {
    return await Future.delayed(Duration(milliseconds: 500)).then((onValue) => true);
  }

  init() async {
    await Future.delayed(Duration(milliseconds: 2));
    setStatusBarColor(appStore.scaffoldBackground!);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appStore.scaffoldBackground,
        body: SingleChildScrollView(
          child: Observer(
            builder: (_) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appStore.isLoggedIn
                    ? Container(
                        width: context.width(),
                        padding: EdgeInsets.all(16),
                        decoration: boxDecoration(context, radius: 0, showShadow: true),
                        margin: EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            cachedImage(
                              getStringAsync(AVATAR),
                              height: 75,
                              width: 75,
                              fit: BoxFit.cover,
                            ).cornerRadiusWithClipRRect(40),
                            16.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${getStringAsync(FIRST_NAME)} ${getStringAsync(LAST_NAME)}',
                                  style: boldTextStyle(size: 18),
                                ),
                                Text(getStringAsync(USER_EMAIL), style: secondaryTextStyle()),
                              ],
                            )
                          ],
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
                        decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor)),
                        child: Text(language!.login, style: boldTextStyle()),
                      ).onTap(
                        () async {
                          await SignInScreen().launch(context, isNewTask: true);
                          setState(() {});
                        },
                      ).paddingAll(16),
                Column(
                  children: [
                    // SettingItemWidget(
                    //   padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    //   title: language!.category,
                    //   titleTextStyle: primaryTextStyle(size: 18),
                    //   leading: Container(
                    //     decoration: boxDecoration(context, radius: 24, showShadow: true),
                    //     padding: EdgeInsets.all(8),
                    //     height: 35,
                    //     width: 35,
                    //     child: Image.asset(ic_category, color: appStore.iconSecondaryColor),
                    //   ),
                    //   onTap: () async {
                    //     await CategoryScreen().launch(context);
                    //   },
                    // ),
                    SettingItemWidget(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                      title: language!.theme,
                      titleTextStyle: primaryTextStyle(size: 18),
                      onTap: () async {
                        appStore.toggleDarkMode(value: !appStore.isDarkModeOn);
                        if (appStore.isDarkModeOn) {
                          await setStatusBarColor(
                            appBackgroundColorDark,
                            statusBarIconBrightness: Brightness.light,
                            statusBarBrightness: Brightness.light,
                          );
                        } else {
                          await setStatusBarColor(white_color);
                        }
                      },
                      leading: Container(
                        decoration: boxDecoration(context, radius: 24, showShadow: true),
                        height: 35,
                        width: 35,
                        child: Icon(MaterialCommunityIcons.theme_light_dark, color: appStore.iconSecondaryColor),
                      ),
                      trailing: Switch(
                        value: appStore.isDarkModeOn,
                        onChanged: (s) async {
                          appStore.toggleDarkMode(value: s);
                          if (appStore.isDarkModeOn) {
                            await setStatusBarColor(
                              appBackgroundColorDark,
                              statusBarIconBrightness: Brightness.light,
                              statusBarBrightness: Brightness.light,
                            );
                          } else {
                            await setStatusBarColor(white_color);
                          }
                        },
                      ),
                    ),
                    SettingItemWidget(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                      title: language!.aboutUs,
                      titleTextStyle: primaryTextStyle(size: 18),
                      leading: Container(
                          decoration: boxDecoration(context, radius: 24, showShadow: true),
                          height: 35,
                          width: 35,
                          child: Icon(MaterialCommunityIcons.information_outline, color: appStore.iconSecondaryColor)),
                      onTap: () {
                        AboutUsScreen().launch(context);
                      },
                    ),
                    SettingItemWidget(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                      title: language!.logout,
                      titleTextStyle: primaryTextStyle(size: 18),
                      leading: Container(
                          decoration: boxDecoration(context, radius: 24, showShadow: true),
                          padding: EdgeInsets.all(8),
                          height: 35,
                          width: 35,
                          child: Image.asset(ic_login, height: 20, width: 20, color: appStore.iconSecondaryColor)),
                      onTap: () async {
                        showConfirmDialogCustom(
                          context,
                          title: language!.areYouSureWantToLogout,
                          onAccept: (context) {
                            logout(context);
                          },
                          dialogType: DialogType.CONFIRMATION,
                          negativeText: language!.cancel,
                          positiveText: language!.yes,
                        );
                      },
                    ).visible(appStore.isLoggedIn),
                    24.height,
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
