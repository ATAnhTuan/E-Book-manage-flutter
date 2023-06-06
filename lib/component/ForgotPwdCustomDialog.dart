import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ForgotPwdCustomDialog extends StatefulWidget {
  @override
  State<ForgotPwdCustomDialog> createState() => _ForgotPwdCustomDialogState();
}

class _ForgotPwdCustomDialogState extends State<ForgotPwdCustomDialog> {
  var email = TextEditingController();
  var emailFocus = FocusNode();

  var formKeys = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: context.width(),
        decoration: boxDecoration(context, radius: 10.0),
        child: Form(
          key: formKeys,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Text(
                  language!.forgotPassword,
                  style: boldTextStyle(size: 24),
                ).paddingOnly(left: 16, right: 16, top: 16),
                4.height,
                Divider(),
                20.height,
                Column(
                  children: [
                    CommonTextFormField(
                      labelText: language!.enterYourEmailId,
                      isPassword: false,
                      mController: email,
                      focusNode: emailFocus,
                      validator: (String? s) {
                        if (s!.trim().isEmpty) return language!.emailRequired;
                        return null;
                      },
                    ),
                  ],
                ).paddingOnly(left: 16, right: 16, bottom: spacing_standard.toDouble()),
                AppButton(
                  width: context.width(),
                  color: primaryColor,
                  text: language!.submit,
                  shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  textStyle: primaryTextStyle(letterSpacing: 1, color: Colors.white),
                  onTap: () {
                    if (formKeys.currentState!.validate()) {
                      formKeys.currentState!.save();
                      if (!accessAllowed) {
                        toast("Sorry");
                        return;
                      }
                    }
                  },
                ).paddingAll(16)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
