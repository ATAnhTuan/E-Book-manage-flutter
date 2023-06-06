import 'package:bookkart_author/component/OrderComponent.dart';
import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/OrderResponse.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class OrderListWidgetComponent extends StatefulWidget {
  static String tag = '/OrderListWidgetComponent';
  final List<OrderResponse>? order;

  OrderListWidgetComponent({this.order});

  @override
  OrderListComponentState createState() => OrderListComponentState();
}

class OrderListComponentState extends State<OrderListWidgetComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(language!.newOrder, style: boldTextStyle(size: 18)).paddingSymmetric(horizontal: 16),
          ListView.separated(
            separatorBuilder: (context, i) => Divider(height: 0),
            itemCount: widget.order!.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              OrderResponse data = widget.order![i];
              return OrderComponent(orderResponse: data);
            },
          )
        ],
      ),
    );
  }
}
