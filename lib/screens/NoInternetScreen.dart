import 'package:bookkart_author/main.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class NoInternetScreen extends StatefulWidget {
  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: context.scaffoldBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('images/no_internet_connection.jpg', height: 200, width: 200, fit: BoxFit.cover),
            8.height,
            Text(language!.noIntenernetConnection, style: secondaryTextStyle()),
          ],
        ),
      ),
    );
  }
}
