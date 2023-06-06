import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/DashboardResponse.dart';
import 'package:bookkart_author/utils/AppCommon.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductTotalWidget extends StatefulWidget {
  final List<ProductsTotal>? productSummaryTotalList;

  ProductTotalWidget({this.productSummaryTotalList});

  @override
  State<ProductTotalWidget> createState() => _ProductTotalWidgetState();
}

class _ProductTotalWidgetState extends State<ProductTotalWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration(context, showShadow: true, radius: defaultRadius),
      padding: EdgeInsets.all(8),
      width: context.width(),
      margin: EdgeInsets.only(top: 16, bottom: 10, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(language!.productTotal, style: boldTextStyle(size: 18)),
          6.height,
          Wrap(
            runSpacing: 8.0,
            children: widget.productSummaryTotalList!.map(
              (e) {
                return e.slug == "simple" ? cardWidget(context, width: context.width() / 2 - 34, orderName: e.name, total: e.total) : SizedBox();
              },
            ).toList(),
          )
        ],
      ),
    );
  }
}
