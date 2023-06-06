import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class AddTermsScreen extends StatefulWidget {
  static String tag = '/AddTermsScreen';

  final int? attributeId;

  AddTermsScreen({this.attributeId});

  @override
  AddTermsScreenState createState() => AddTermsScreenState();
}

class AddTermsScreenState extends State<AddTermsScreen> {
  TextEditingController attributeNameCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();

  FocusNode descriptionFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future<void> addTerms() async {
    var request = {'name': attributeNameCont.text};
    appStore.setLoading(true);

    addTerm(req: request, attributeId: widget.attributeId).then((res) {
      toast(language!.successfullyAddedAttribute);

      finish(context, res);
    }).catchError((e) {
      toast("${e['message']}");
    }).whenComplete(() => appStore.setLoading(false));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language!.addAttribute, showBack: true, color: primaryColor, textColor: white),
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
                  controller: descriptionCont,
                  focus: descriptionFocus,
                  textFieldType: TextFieldType.NAME,
                  cursorColor: appStore.isDarkModeOn ? white : black,
                  decoration: inputDecoration(context, language!.description),
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                ),
                16.height,
                AppButton(
                  text: language!.lblAdd,
                  color: primaryColor,
                  textColor: white,
                  width: context.width(),
                  onTap: () {
                    hideKeyboard(context);
                    addTerms();
                  },
                ),
              ],
            ),
          ),
          Observer(builder: (_) => Loader().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
