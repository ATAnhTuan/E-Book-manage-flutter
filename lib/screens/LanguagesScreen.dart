import 'package:bookkart_author/main.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class LanguagesScreen extends StatefulWidget {
  @override
  LanguagesScreenState createState() => LanguagesScreenState();
}

class LanguagesScreenState extends State<LanguagesScreen> {
  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  Future<void> init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(language!.languages, elevation: 0.0, color: appStore.isDarkModeOn ? cardDarkColor : Colors.white),
        body: SingleChildScrollView(
          child: Container(
            color: context.cardColor,
            child: LanguageListWidget(
              scrollPhysics: NeverScrollableScrollPhysics(),
              widgetType: WidgetType.LIST,
              onLanguageChange: (v) {
                appStore.setLanguage(v.languageCode!);
                setState(() {});
                finish(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
