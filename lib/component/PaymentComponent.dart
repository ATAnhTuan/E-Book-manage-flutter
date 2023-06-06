import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/OrderResponse.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:bookkart_author/utils/AppImages.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class PaymentComponent extends StatefulWidget {
  static String tag = '/PaymentComponent';
  final OrderResponse? mOrderModel;

  PaymentComponent({this.mOrderModel});

  @override
  PaymentComponentState createState() => PaymentComponentState();
}

class PaymentComponentState extends State<PaymentComponent> {
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

  Widget mStatus(OrderResponse mOrderResponse) {
    if (mOrderResponse.status == 'pending') return Text(mOrderResponse.status!.capitalizeFirstLetter(), style: primaryTextStyle(color: pendingColor));
    if (mOrderResponse.status == 'processing') return Text(mOrderResponse.status!.capitalizeFirstLetter(), style: primaryTextStyle(color: processingColor));
    if (mOrderResponse.status == 'on-hold') return Text(mOrderResponse.status!.capitalizeFirstLetter(), style: primaryTextStyle(color: primaryColor));
    if (mOrderResponse.status == 'completed') return Text(mOrderResponse.status!.capitalizeFirstLetter(), style: primaryTextStyle(color: completeColor));
    if (mOrderResponse.status == 'cancelled') return Text(mOrderResponse.status!.capitalizeFirstLetter(), style: primaryTextStyle(color: cancelledColor));
    if (mOrderResponse.status == 'refunded') return Text(mOrderResponse.status!.capitalizeFirstLetter(), style: primaryTextStyle(color: refundedColor));
    if (mOrderResponse.status == 'failed') return Text(mOrderResponse.status!.capitalizeFirstLetter(), style: primaryTextStyle(color: failedColor));
    if (mOrderResponse.status == 'any')
      return Text(mOrderResponse.status!.capitalizeFirstLetter(), style: primaryTextStyle(color: primaryColor));
    else
      return Text(mOrderResponse.status!.capitalizeFirstLetter(), style: primaryTextStyle(color: primaryColor));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cachedImage(ic_shopping, height: 50, width: 50, fit: BoxFit.cover),
        12.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${language!.paymentVia} : " + " " + widget.mOrderModel!.paymentMethodTitle!.validate(), style: boldTextStyle()).visible(widget.mOrderModel!.paymentMethodTitle!.isNotEmpty),
            mStatus(widget.mOrderModel!),
            2.height,
            Text(DateFormat(orderDateFormat).format(DateTime.parse(widget.mOrderModel!.dateCreated!.validate())), style: secondaryTextStyle(), maxLines: 1),
          ],
        ).expand(),
      ],
    );
  }
}
