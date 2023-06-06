import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppCommon.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class ForgotPasswordComponent extends StatefulWidget {
  static String tag = '/ForgotPasswordComponent';

  @override
  ForgotPasswordComponentState createState() => ForgotPasswordComponentState();
}

class ForgotPasswordComponentState extends State<ForgotPasswordComponent> {
  var emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();

  final formKey1 = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  ///forgot password api call
  Future forgotPwdApi(value) async {
    await isNetworkAvailable().then((bool) async {
      appStore.setLoading(true);
      if (bool) {
        var request = {
          'email': value,
        };
        await forgetPassword(request).then((res) async {
          appStore.setLoading(false);

          toast(res["message"]);
        }).catchError((onError) {
          appStore.setLoading(false);
          log("Error:" + onError.toString());
        });
      } else {
        appStore.setLoading(false);
      }
    });
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(language!.forgotPassword, style: boldTextStyle(size: 22)).paddingOnly(left: 16, right: 16, top: 16),
            16.height,
            Form(
              key: formKey1,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    controller: emailController,
                    focus: emailFocusNode,
                    textFieldType: TextFieldType.EMAIL,
                    decoration: inputDecoration(context, language!.enterYourEmail),
                  ),
                ],
              ).paddingOnly(left: 8, right: 8, bottom: 8),
            ),
            AppButton(
              text: language!.submit,
              textStyle: boldTextStyle(color: Colors.white),
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(30)),
              width: context.width() * 0.7,
              color: primaryColor,
              onTap: () {
                if (formKey1.currentState!.validate()) {
                  hideKeyboard(context);
                  forgotPwdApi(emailController.text);
                } else {
                  appStore.setLoading(false);
                }
              },
            ).paddingAll(16).visible(isVendor),
          ],
        ),
        Observer(
            builder: (_) => SizedBox(
                  child: Loader(),
                  height: 260,
                ).visible(appStore.isLoading))
      ],
    );
  }
}
