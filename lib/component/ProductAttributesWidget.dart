import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/AttributeModel.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/screens/AddAttributeScreen.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppCommon.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductAttributesWidget extends StatefulWidget {
  static String tag = '/ProductAttributesItemWidget';

  final AttributeModel? data;
  final Function(int?)? onDelete;
  final Function? onUpdate;

  ProductAttributesWidget({this.data, this.onDelete, this.onUpdate});

  @override
  ProductAttributesWidgetState createState() => ProductAttributesWidgetState();
}

class ProductAttributesWidgetState extends State<ProductAttributesWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  void deleteAttributes() {
    hideKeyboard(context);

    appStore.setLoading(true);

    deleteAttributesTerm(attributeId: widget.data!.id, isAttribute: true).then((res) {
      toast(language!.deleted);
      widget.onDelete?.call(res.id);
    }).catchError((e) {
      toast(e.toString());
      log(e.toString());
    }).whenComplete(() {
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
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      child: Row(
        children: [
          Text(widget.data!.name!, style: boldTextStyle()).expand(),
          Row(
            children: [
              Row(
                children: [
                  Icon(Icons.edit, size: 14, color: appStore.isDarkModeOn ? white : primaryColor),
                  4.width,
                  Text(
                    language!.edit,
                    style: primaryTextStyle(color: appStore.isDarkModeOn ? white : primaryColor),
                  ),
                ],
              ).onTap(
                () async {
                  if (isVendor) {
                    toast(language!.onlyAdminCanPerformThisAction);
                    return;
                  }
                  bool? res = await AddAttributeScreen(isUpdate: true, data: widget.data).launch(context);
                  if (res ?? false) {
                    setState(() {});
                    widget.onUpdate?.call();
                  }
                },
              ),
              10.width,
              Row(
                children: [
                  Icon(Icons.edit, size: 14, color: Colors.red),
                  4.width,
                  Text(
                    language!.delete,
                    style: primaryTextStyle(color: Colors.red),
                  ),
                ],
              ).onTap(
                () async {
                  showConfirmDialogCustom(
                    context,
                    title: language!.areYouSureWantDeleteProductAttribute,
                    onAccept: (context) {
                      deleteAttributes();
                    },
                    dialogType: DialogType.DELETE,
                    negativeText: language!.cancel,
                    positiveText: language!.delete,
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
