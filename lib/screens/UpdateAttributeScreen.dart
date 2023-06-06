import 'package:bookkart_author/models/AttributeModel.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class UpdateAttributeScreen extends StatefulWidget {
  static String tag = '/EditAttributeScreen';

  final AttributeModel? attributeData;
  final int? attributeId;
  final Function? onUpdate;

  UpdateAttributeScreen({this.attributeData, this.attributeId, this.onUpdate});

  @override
  UpdateAttributeScreenState createState() => UpdateAttributeScreenState();
}

class UpdateAttributeScreenState extends State<UpdateAttributeScreen> {
  TextEditingController attributeNameCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    attributeNameCont.text = widget.attributeData!.name.validate();
  }

  Future<void> updateAttribute() async {
    appStore.setLoading(true);

    var request = {'name': attributeNameCont.text};

    await editAttribute(request: request, attributeId: widget.attributeId).then(
      (res) {
        LiveStream().emit(UPDATE_ATTRIBUTE);
        widget.attributeData!.name = attributeNameCont.text.validate();
        toast(language!.updateSuccessfully);
      },
    ).catchError(
      (e) {
        toast(e.toString().validate());
      },
    ).whenComplete(
      () {
        appStore.setLoading(false);
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            16.height,
            AppTextField(
              controller: attributeNameCont,
              textFieldType: TextFieldType.NAME,
              cursorColor: appStore.isDarkModeOn ? white : black,
              decoration: inputDecoration(context, language!.productAttribute),
              autoFocus: true,
            ),
            16.height,
            AppButton(
              shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              text: language!.edit,
              color: primaryColor,
              textColor: white,
              width: context.width(),
              onTap: () {
                hideKeyboard(context);
                Navigator.pop(context);
                showConfirmDialogCustom(
                  context,
                  onAccept: (context) {
                    updateAttribute();
                  },
                  dialogType: DialogType.UPDATE,
                  negativeText: language!.cancel,
                  positiveText: language!.update,
                );
              },
            ),
          ],
        ),
        Observer(builder: (_) => Loader().visible(appStore.isLoading))
      ],
    );
  }
}
