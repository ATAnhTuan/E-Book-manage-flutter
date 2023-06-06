import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/AttributeModel.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/screens/UpdateTermScreen.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class ProductTermComponent extends StatefulWidget {
  static String tag = '/ProductAttributeTermWidget';

  AttributeModel? data;
  final int? attributeId;
  final Function(int?)? onDelete;
  final Function? onUpdate;

  ProductTermComponent({this.data, this.attributeId, this.onDelete, this.onUpdate});

  @override
  _ProductTermComponentState createState() => _ProductTermComponentState();
}

class _ProductTermComponentState extends State<ProductTermComponent> {
  bool isLoading = false;

  ///delete attribute term api call
  void deleteAttributesTerms() {
    hideKeyboard(context);

    appStore.setLoading(true);

    deleteAttributesTerm(attributeId: widget.attributeId, attributeTermId: widget.data!.id).then((res) {
      toast(language!.successfullyDeleted);

      widget.onDelete?.call(res.id);
    }).catchError((e) {
      log(e.toString());
    }).whenComplete(() {
      LiveStream().emit(REMOVE_ATTRIBUTE_TERMS, true);
      appStore.setLoading(false);
    });
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
              Text(language!.edit, style: primaryTextStyle(color: Colors.blue)).onTap(() async {
                bool? res = await UpdateTermScreen(termsData: widget.data, attributeId: widget.attributeId).launch(context);

                if (res ?? false) {
                  setState(() {});
                  widget.onUpdate?.call();
                }
              }),
              16.width,
              Text(language!.delete, style: primaryTextStyle(color: Colors.red)).onTap(() async {
                showConfirmDialogCustom(
                  context,
                  title: language!.areYouSureWantDeleteProductTerms,
                  onAccept: (context) {
                    deleteAttributesTerms();
                  },
                  dialogType: DialogType.DELETE,
                );
              }),
              8.width,
            ],
          ),
        ],
      ),
    );
  }
}
