import 'package:bookkart_author/main.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductDetailCard extends StatelessWidget {
  ProductDetailCard({this.name, this.productName});

  final String? name;
  final String? productName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name!+": ", style: primaryTextStyle(color: appStore.textSecondaryColor)),
        4.width,
        Text(
          productName!.trim(),
          style: boldTextStyle(),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
