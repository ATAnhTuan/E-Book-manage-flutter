import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ZoomImageScreen extends StatefulWidget {
  final String? mProductImage;

  ZoomImageScreen({this.mProductImage});

  @override
  _ZoomImageScreenState createState() => _ZoomImageScreenState();
}

class _ZoomImageScreenState extends State<ZoomImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('', showBack: true, color: primaryColor, textColor: white),
      body: cachedImage(widget.mProductImage, height: context.height(), width: context.width(), fit: BoxFit.cover),
    );
  }
}
