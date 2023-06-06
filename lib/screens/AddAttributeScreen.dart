import 'package:bookkart_author/models/AttributeModel.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class AddAttributeScreen extends StatefulWidget {
  static String tag = '/AddAttributeScreen';
  bool? isUpdate = false;
  AttributeModel? data;

  AddAttributeScreen({this.isUpdate, this.data});

  @override
  AddAttributeScreenState createState() => AddAttributeScreenState();
}

class AddAttributeScreenState extends State<AddAttributeScreen> {
  TextEditingController attributeNameCont = TextEditingController();
  TextEditingController slugCont = TextEditingController();

  FocusNode descriptionFocus = FocusNode();

  bool mArchives = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(primaryColor, statusBarIconBrightness: Brightness.light, statusBarBrightness: Brightness.light);

    if (widget.isUpdate == true) {
      attributeNameCont.text = widget.data!.name!.toString();
      slugCont.text = widget.data!.slug!.toString();
      mArchives = widget.data!.hasArchives!;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> addAttributes() async {
    var request = {
      "name": attributeNameCont.text,
      "slug": slugCont.text,
      "type": "select",
      "order_by": "menu_order",
      "has_archives": mArchives,
    };
    appStore.setLoading(true);

    await addAttribute(req: request).then(
      (res) {
        toast(language!.successfullyAddedAttribute);
        finish(context, res);
      },
    ).catchError(
      (e) {
        toast("${e['message']}");
      },
    ).whenComplete(() => appStore.setLoading(false));
  }

  Future<void> updateAttribute() async {
    appStore.setLoading(true);

    var request = {
      "name": attributeNameCont.text,
      "slug": slugCont.text,
      "type": "select",
      "order_by": "menu_order",
      "has_archives": mArchives,
    };
    await editAttribute(request: request, attributeId: widget.data!.id).then(
      (res) {
        widget.data!.name = attributeNameCont.text.validate();
        finish(context, true);
        toast(language!.updateSuccessfully);
      },
    ).catchError(
      (e) {
        toast(e.toString().validate());
      },
    ).whenComplete(
      () {
        LiveStream().emit(UPDATE_ATTRIBUTE);
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
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(widget.isUpdate == true ? language!.updateAttribute : language!.addAttribute, showBack: true, color: primaryColor, textColor: white),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  AppTextField(
                    controller: attributeNameCont,
                    textFieldType: TextFieldType.NAME,
                    cursorColor: appStore.isDarkModeOn ? white : black,
                    decoration: inputDecoration(context, language!.productAttribute),
                    nextFocus: descriptionFocus,
                    autoFocus: true,
                  ),
                  16.height,
                  AppTextField(
                    controller: slugCont,
                    focus: descriptionFocus,
                    textFieldType: TextFieldType.NAME,
                    cursorColor: appStore.isDarkModeOn ? white : black,
                    decoration: inputDecoration(context, language!.slug),
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                  ),
                  16.height,
                  CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.all(0),
                      value: mArchives,
                      onChanged: (bool? val) {
                        setState(() {
                          mArchives = val!;
                        });
                      },
                      title: Text(language!.enableArchives, style: primaryTextStyle()),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: primaryColor),
                  16.height,
                  AppButton(
                    text: widget.isUpdate == true ? language!.update : language!.add,
                    shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    color: primaryColor,
                    textColor: white,
                    width: context.width(),
                    onTap: () {
                      hideKeyboard(context);
                      if (widget.isUpdate == true) {
                        updateAttribute();
                      } else {
                        addAttributes();
                      }
                    },
                  ),
                ],
              ),
            ),
            Observer(builder: (_) => Loader().visible(appStore.isLoading))
          ],
        ),
      ),
    );
  }
}
