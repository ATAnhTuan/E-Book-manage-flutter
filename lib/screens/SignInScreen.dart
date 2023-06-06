import 'package:bookkart_author/component/ForgotPasswordComponent.dart';
import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/screens/DashBoardScreen.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:bookkart_author/utils/AppImages.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SignInScreen extends StatefulWidget {
  static String tag = '/SignInScreen';

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  var formKey = GlobalKey<FormState>();

  TextEditingController usernameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  FocusNode usernameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  bool isRemember = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await removeKey(TOKEN);
  }

  Future<void> signInApi(req) async {
    appStore.setLoading(true);
    await login(req).then(
      (res) async {
        if (!mounted || res.data!.roles!.isNotEmpty){
                   setState(() {
          appStore.setLoading(false);
        });

        }

        appStore.setLoading(false);
        if (appStore.isLoggedIn)
          DashBoardScreen().launch(
            context,
            isNewTask: true,
            pageRouteAnimation: PageRouteAnimation.Fade,
          );
      },
    ).catchError(
      (error) {
        appStore.setLoading(false);
        setState(() {});
        log("Error" + error.toString());
        toast(error.toString());
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    setStatusBarColor(Colors.transparent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(app_logo, width: 170, height: 170, fit: BoxFit.cover).center(),
                  16.height,
                  Text(language!.welcomeBack, style: boldTextStyle(size: 22)),
                  32.height,
                  Form(
                    key: formKey,
                    child: Container(
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: defaultBoxShadow(),
                        backgroundColor: appStore.isDarkModeOn ? iconColorPrimaryDark : white,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      child: Column(
                        children: [
                          AppTextField(
                            controller: usernameCont,
                            textFieldType: TextFieldType.USERNAME,
                            focus: usernameFocus,
                            nextFocus: passwordFocus,
                            decoration: inputDecoration(context, language!.lblEmail),
                          ),
                          16.height,
                          AppTextField(
                            controller: passwordCont,
                            textFieldType: TextFieldType.PASSWORD,
                            focus: passwordFocus,
                            decoration: inputDecoration(context, language!.password),
                          ),
                          8.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CustomTheme(
                                    child: Checkbox(
                                      focusColor: primaryColor,
                                      activeColor: primaryColor,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      value: getBoolAsync(REMEMBER_PASSWORD, defaultValue: true),
                                      onChanged: (bool? value) async {
                                        await setValue(REMEMBER_PASSWORD, value);
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  Text(language!.rememberMe, style: secondaryTextStyle()).onTap(() async {
                                    await setValue(REMEMBER_PASSWORD, !getBoolAsync(REMEMBER_PASSWORD));
                                    setState(() {});
                                  }),
                                ],
                              ),
                              // Text(language!.forgotPassword, style: secondaryTextStyle()).onTap(
                              //   () {
                              //     showInDialog(context, builder: (_) => ForgotPasswordComponent(), dialogAnimation: DialogAnimation.SLIDE_BOTTOM_TOP, contentPadding: EdgeInsets.all(0));
                              //   },
                              // ),
                            ],
                          ),
                          40.height,
                          AppButton(
                            width: context.width(),
                            color: primaryColor,
                            textColor: Colors.white,
                            text: language!.signIn,
                            shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            onTap: () {
                              hideKeyboard(context);
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                if (!mounted) return;
                                if (usernameCont.text.toLowerCase().isEmpty)
                                  toast(language!.userName + " " + language!.filedRequired);
                                else if (passwordCont.text.isEmpty)
                                  toast(language!.password + " " + language!.filedRequired);
                                else {
                                  var request = {"username": "${usernameCont.text.toLowerCase()}", "password": "${passwordCont.text}"};
                                  signInApi(request);
                                }
                                if (!accessAllowed) {
                                  toast("Sorry");
                                  return;
                                }
                              }
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  24.height,
                ],
              ).paddingOnly(right: 16, left: 16),
            ),
            Loader().center().visible(appStore.isLoading)
          ],
        ).withHeight(context.height()),
      ),
    );
  }
}
