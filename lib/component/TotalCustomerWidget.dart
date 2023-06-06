import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/DashboardResponse.dart';
import 'package:bookkart_author/utils/AppCommon.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class TotalCustomerWidget extends StatefulWidget {
  final List<OrderTotal>? customerTotalList;

  TotalCustomerWidget({this.customerTotalList});

  @override
  TotalCustomerWidgetState createState() => TotalCustomerWidgetState();
}

class TotalCustomerWidgetState extends State<TotalCustomerWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration(context, showShadow: true, radius: defaultRadius),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(top: 16, bottom: 10, left: 16, right: 16),
      width: context.width(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(language!.customerTotal, style: boldTextStyle(size: 18)),
          6.height,
          Wrap(
            spacing: 16.0,
            runSpacing: 8.0,
            children: widget.customerTotalList!.map(
              (e) {
                return cardWidget(context, orderName: e.name, total: e.total, width: context.width() / 2 - 34);
              },
            ).toList(),
          )
        ],
      ),
    );
  }
}
