import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/view/OrderFragment.dart';
import 'package:bookkart_author/view/ProfileFragment.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:bookkart_author/utils/AppImages.dart';
import 'package:bookkart_author/utils/AppLocalizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../view/HomeFragment.dart';
import '../view/ProductFragment.dart';

class DashBoardScreen extends StatefulWidget {
  static String tag = '/DashBoardScreen';

  @override
  DashBoardScreenState createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {
  List<Widget> pages = [
    HomeFragment(),
    OrderFragment(),
    ProductFragment(),
    ProfileFragment(),
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    2.seconds.delay.then(
      (value) {
        if (appStore.isDarkModeOn) {
          setStatusBarColor(
            context.scaffoldBackgroundColor,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
          );
        } else {
          setStatusBarColor(
            context.scaffoldBackgroundColor,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
          );
        }
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            currentIndex = value;
            setState(() {});
          },
          backgroundColor: appStore.appBarColor,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedItemColor: appStore.isDarkModeOn ? white : primaryColor,
          unselectedItemColor: appStore.isDarkModeOn ? Colors.grey : primaryColor,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(ic_home, color: appStore.isDarkModeOn ? Colors.grey : primaryColor, width: 20, height: 20),
              activeIcon: Image.asset(
                ic_fill_home,
                color: appStore.iconColor,
                width: 20,
                height: 20,
              ),
              label: language!.home,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(ic_category, color: appStore.isDarkModeOn ? Colors.grey : primaryColor, width: 20, height: 20),
              activeIcon: Image.asset(
                ic_fill_category,
                color: appStore.iconColor,
                width: 20,
                height: 20,
              ),
              label: "Requests",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(ic_total_order, color: appStore.isDarkModeOn ? Colors.grey : primaryColor, width: 20, height: 20),
              activeIcon: Image.asset(
                ic_fill_total_order,
                color: appStore.iconColor,
                width: 20,
                height: 20,
              ),
              label: language!.books,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(ic_user, color: appStore.isDarkModeOn ? Colors.grey : primaryColor, width: 20, height: 20),
              activeIcon: Image.asset(
                ic_fill_user,
                color: appStore.iconColor,
                width: 20,
                height: 20,
              ),
              label: language!.profile,
            ),
          ],
        ),
        body: IndexedStack(children: pages, index: currentIndex),
      ),
    );
  }
}
