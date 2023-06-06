import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/DashboardResponse.dart';
import 'package:bookkart_author/utils/AppCommon.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class TotalOrderWidget extends StatefulWidget {
  final List<OrderTotal>? orderSummaryTotalList;

  TotalOrderWidget({this.orderSummaryTotalList});

  @override
  TotalOrderWidgetState createState() => TotalOrderWidgetState();
}

class TotalOrderWidgetState extends State<TotalOrderWidget> {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            language!.orderTotal,
            style: boldTextStyle(size: 18),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Divider(),
          4.height,
          Wrap(
            spacing: 16.0,
            runSpacing: 8.0,
            children: widget.orderSummaryTotalList!.map(
              (e) {
                return cardWidget(
                  context,
                  orderName: e.name,
                  total: e.total,
                  width: context.width() * 0.3 - 16,
                );
              },
            ).toList(),
          )
        ],
      ),
    );
  }
}
