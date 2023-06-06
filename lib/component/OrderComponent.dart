import 'package:bookkart_author/models/OrderResponse.dart';
import 'package:bookkart_author/screens/OrderDetailScreen.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class OrderComponent extends StatefulWidget {
  OrderResponse? orderResponse = OrderResponse();
  final Function? onUpdate;

  OrderComponent({this.orderResponse, this.onUpdate});

  @override
  _OrderComponentState createState() => _OrderComponentState();
}

class _OrderComponentState extends State<OrderComponent> {
  OrderResponse? data;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    data = widget.orderResponse;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 60,
            decoration: boxDecorationWithRoundedCorners(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              backgroundColor: statusColor(data!.status.validate()).withOpacity(0.1),
            ),
            child: Text(
              "#" + '${data!.id.toString().validate()}',
              style: boldTextStyle(color: statusColor(data!.status.validate()), size: 14),
            ).center(),
          ),
          8.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data!.billing!.email.validate(),
                    style: primaryTextStyle(size: 13),
                  ).expand(),
                  8.width,
                  Text(
                    data!.status.validate().capitalizeFirstLetter(),
                    textAlign: TextAlign.end,
                    style: boldTextStyle(size: 11, color: statusColor(data!.status.validate())),
                  ),
                ],
              ),
              4.height,
              data!.currencySymbol != null
                  ? PriceWidget(price: '${data!.currencySymbol.validate()}${data!.total.validate()}', size: 16)
                  : PriceWidget(price: '${'₹'}${data!.total.validate()}', size: 16),
            ],
          ).expand(),
        ],
      ),
    ).onTap(
      () async {
        bool? res = await OrderDetailScreen(mOrderModel: data).launch(context);
        if (res ?? false) {
          widget.onUpdate?.call();
        }
      },
    );
  }
}
