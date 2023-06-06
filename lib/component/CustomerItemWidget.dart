import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/CustomerResponse.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/screens/UpdateCustomerScreen.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppCommon.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomerItemWidget extends StatefulWidget {
  static String tag = '/CustomerItemWidget';

  final CustomerResponse? data;
  final Function? onUpdate;
  final Function(int?)? onDelete;

  CustomerItemWidget({this.data, this.onUpdate, this.onDelete});

  @override
  CustomerItemWidgetState createState() => CustomerItemWidgetState();
}

class CustomerItemWidgetState extends State<CustomerItemWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  ///delete customer api call
  Future<void> deleteCustomers() async {
    hideKeyboard(context);
    appStore.setLoading(true);

    await deleteCustomer(customerId: widget.data!.id.validate()).then((res) {
      widget.onDelete?.call(res.id);
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() {
      setState(() {});
      appStore.setLoading(false);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          cachedImage(widget.data!.avatarUrl, height: 60, width: 60).cornerRadiusWithClipRRect(40),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.data?.firstName.validate()} ${widget.data?.lastName.validate()}',
                style: boldTextStyle(size: 14),
              ).visible(widget.data!.firstName!.isNotEmpty),
              widget.data!.email!.isNotEmpty ? Text(widget.data!.email.validate(), style: secondaryTextStyle()) : SizedBox(),
              8.height,
              Row(
                children: [
                  Container(
                    decoration: boxDecorationWithRoundedCorners(
                      boxShadow: defaultBoxShadow(),
                      boxShape: BoxShape.circle,
                      backgroundColor: appStore.isDarkModeOn ? black : white,
                    ),
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.edit, size: 16, color: appStore.isDarkModeOn ? white : primaryColor),
                  ).onTap(
                    () async {
                      if (isVendor) {
                        toast(language!.onlyAdminCanPerformThisAction);
                        return;
                      }
                      bool? res = await UpdateCustomerScreen(customerData: widget.data).launch(context);
                      if (res ?? false) {
                        setState(() {});
                        widget.onUpdate?.call();
                      }
                    },
                  ),
                  16.width,
                  Container(
                    decoration: boxDecorationWithRoundedCorners(
                      boxShadow: defaultBoxShadow(),
                      boxShape: BoxShape.circle,
                      backgroundColor: appStore.isDarkModeOn ? black : white,
                    ),
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.delete, size: 16, color: Colors.red),
                  ).onTap(
                    () async {
                      if (isVendor) {
                        toast(language!.onlyAdminCanPerformThisAction);
                        return;
                      }
                      showConfirmDialogCustom(
                        context,
                        title: language!.areYouSureWantDeleteCustomer,
                        onAccept: (context) {
                          deleteCustomers();
                        },
                        dialogType: DialogType.DELETE,
                        negativeText: language!.cancel,
                        positiveText: language!.delete,
                      );
                    },
                  ),
                ],
              )
            ],
          ).expand(),
        ],
      ),
    );
  }
}
