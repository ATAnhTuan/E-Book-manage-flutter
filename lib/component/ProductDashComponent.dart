import 'package:bookkart_author/models/DashboardResponse.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductDashComponent extends StatefulWidget {
  static String tag = '/ProductDashComponent';

  final List<OrderTotal> list;

  ProductDashComponent(this.list);

  @override
  ProductDashComponentState createState() => ProductDashComponentState();
}

class ProductDashComponentState extends State<ProductDashComponent> {
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.list.map(
          (e) {
            return Container(
              decoration: boxDecorationWithRoundedCorners(backgroundColor: primaryColor, boxShadow: defaultBoxShadow(), borderRadius: radius(8)),
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.name.validate(), style: secondaryTextStyle(size: 14, color: Colors.white), maxLines: 2, overflow: TextOverflow.ellipsis),
                  10.height,
                  Text(e.total.toString().validate(), style: boldTextStyle(size: 20, color: Colors.white)),
                ],
              ),
            ).paddingOnly(right: 16);
          },
        ).toList(),
      ).paddingLeft(16),
    );
  }
}
