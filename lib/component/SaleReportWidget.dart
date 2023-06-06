import 'package:bookkart_author/component/ExpandChartToLandScapeModeComponent.dart';
import 'package:bookkart_author/component/HorizontalBarChart.dart';
import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/DashboardResponse.dart';
import 'package:bookkart_author/utils/AppCommon.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SaleReportWidget extends StatefulWidget {
  final List<SaleTotalData>? orderTotalList;

  SaleReportWidget({this.orderTotalList});

  @override
  SaleReportWidgetState createState() => SaleReportWidgetState();
}

class SaleReportWidgetState extends State<SaleReportWidget> {
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
      margin: EdgeInsets.only(top: 8, bottom: 10, left: 16, right: 16),
      width: context.width(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                language!.saleReport,
                style: boldTextStyle(size: 18),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ).expand(),
              IconButton(
                icon: Icon(
                  Icons.crop_rotate_rounded,
                ),
                onPressed: () {
                  ExpandChartToLandScapeModeComponent(widget.orderTotalList!).launch(context);
                },
              )
            ],
          ),
          8.height,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: HorizontalBarChart(widget.orderTotalList!).withSize(
              width: context.width(),
              height: 350,
            ),
          ),
          16.height,
        ],
      ),
    );
  }
}
