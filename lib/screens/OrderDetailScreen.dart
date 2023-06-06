import 'package:bookkart_author/component/PaymentComponent.dart';
import 'package:bookkart_author/models/OrderResponse.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppCommon.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'ProductDetailScreen.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderResponse? mOrderModel;
  static String tag = '/OrderDetailScreen';

  OrderDetailScreen({Key? key, this.mOrderModel}) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  List<String> mStatusList = ['pending', 'processing', 'on-hold', 'completed', 'cancelled', 'refunded ', 'failed'];
  String? mSelectedStatusIndex;
  String mErrorMsg = '';

  @override
  void initState() {
    super.initState();

    init();
  }

  init() async {
    if (appStore.isDarkModeOn) {
      await setStatusBarColor(
        appBackgroundColorDark,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      );
    } else {
      await setStatusBarColor(white, statusBarIconBrightness: Brightness.dark, statusBarBrightness: Brightness.dark);
    }
    setState(() {
      mSelectedStatusIndex = widget.mOrderModel!.status!.toString();
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (appStore.isDarkModeOn) {
      setStatusBarColor(
        appBackgroundColorDark,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      );
    } else {
      setStatusBarColor(white, statusBarIconBrightness: Brightness.dark, statusBarBrightness: Brightness.dark);
    }
  }

  ///update order api call
  void updateOrderAPI(id, status) async {
    appStore.setLoading(true);
    var request = {"status": status};
    await updateOrder(id, request).then(
      (res) async {
        widget.mOrderModel!.status = mSelectedStatusIndex;
        appStore.setLoading(false);
        toast(language!.successfullyUpdateStatus);
        setState(() {});
        finish(context, true);
      },
    ).catchError(
      (error) {
        appStore.setLoading(false);
        mErrorMsg = error.toString();
        print(error.toString());
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appStore.scaffoldBackground,
        appBar: appBarWidget(
          '#${widget.mOrderModel!.id.toString()}',
          showBack: true,
          color: appStore.isDarkModeOn ? cardDarkColor : Colors.white,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PaymentComponent(mOrderModel: widget.mOrderModel),
                  8.height,
                  Divider(),
                  8.height,
                  Text("${language!.bookInformation}: ", style: secondaryTextStyle()),
                  8.height,
                  widget.mOrderModel!.lineItems!.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: widget.mOrderModel!.lineItems!.length,
                          itemBuilder: (context, i) {
                            OrderResponse data = widget.mOrderModel!;
                            return GestureDetector(
                              onTap: () {
                                ProductDetailScreen(mProId: data.lineItems![i].productId).launch(context);
                              },
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${data.lineItems![i].name}', style: boldTextStyle(), maxLines: 2),
                                        data.currencySymbol != null
                                            ? PriceWidget(price: '${data.currencySymbol.validate()} ${data.total.validate()}', size: 16)
                                            : PriceWidget(price: '${'₹'} ${data.total.validate()}', size: 16),
                                      ],
                                    ),
                                    4.height,
                                  ],
                                ).paddingOnly(top: 4),
                              ),
                            );
                          },
                        )
                      : SizedBox().visible(widget.mOrderModel!.lineItems!.isNotEmpty),
                  getStringAsync(USER_ROLE) == Seller
                      ? SizedBox()
                      : Container(
                          margin: EdgeInsets.only(bottom: 16),
                          padding: EdgeInsets.all(10),
                          width: context.width(),
                          decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: appStore.isDarkModeOn ? cardBackgroundBlackDark : white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${language!.authorBy}" + ":", style: secondaryTextStyle()),
                              16.height,
                              if (widget.mOrderModel!.store != null && !widget.mOrderModel!.store!.shopName.isEmptyOrNull)
                                Text(widget.mOrderModel!.store!.shopName.toString(), style: primaryTextStyle())
                            ],
                          )),
                  8.height,
                  Text("${language!.changeStatus}" + ":", style: secondaryTextStyle()).visible(!isVendor),
                  16.height,
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: iconColorSecondary)),
                    child: DropdownButton(
                      isExpanded: true,
                      dropdownColor: appStore.appBarColor,
                      value: mSelectedStatusIndex,
                      style: boldTextStyle(),
                      icon: Icon(Icons.keyboard_arrow_down, color: appStore.iconColor).paddingOnly(right: 8),
                      underline: 0.height,
                      onChanged: (dynamic newValue) {
                        setState(
                          () {
                            mSelectedStatusIndex = newValue;
                            updateOrderAPI(widget.mOrderModel!.id, newValue);
                          },
                        );
                      },
                      items: mStatusList.map((category) {
                        return DropdownMenuItem(
                          child: Text(category, style: primaryTextStyle()).paddingLeft(12),
                          value: category,
                        );
                      }).toList(),
                    ),
                  ).visible(!isVendor),
                ],
              ).paddingAll(16),
            ),
            Observer(
              builder: (_) => Loader().center().visible(appStore.isLoading),
            ),
          ],
        ),
      ),
    );
  }
}
