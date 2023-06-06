import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/CustomerResponse.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class AddCustomerScreen extends StatefulWidget {
  static String tag = '/EditCustomerScreen';
  CustomerResponse? customerData;
  final bool isAdd;
  final Function? onUpdate;

  AddCustomerScreen({this.customerData, this.isAdd = false, this.onUpdate});

  @override
  AddCustomerScreenState createState() => AddCustomerScreenState();
}

class AddCustomerScreenState extends State<AddCustomerScreen> {
  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController usernameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  String? roleCont = '';

  List<String> roleList = [
    'Disable Vendor',
    'Store Vendor',
    'Vendor',
    'Shop Manager',
    'Customer',
    'Subscriber',
    'Contributor',
    'Author',
    'Editor',
    'Administrator',
    '--No role for this site--',
  ];

  var formKeys = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setStatusBarColor(primaryColor, statusBarIconBrightness: Brightness.light, statusBarBrightness: Brightness.light);

    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> addCustomers() async {
    appStore.setLoading(true);
    var req = {
      'first_name': fNameCont.text.validate(),
      'last_name': lNameCont.text.validate(),
      'email': emailCont.text.validate(),
      'username': usernameCont.text.validate(),
      'password': passwordCont.text.validate(),
    };

    await addCustomer(req).then((value) {
      toast(language!.addSuccessfully);
      finish(context, value);
    }).catchError((e) {
      log(e.toString());
      toast(e.toString());
    }).whenComplete(() {
      LiveStream().emit(ADD_CUSTOMER, true);
      appStore.setLoading(false);
    });
  }

  @override
  void dispose() {
    if (appStore.isDarkModeOn) {
      setStatusBarColor(
        appBackgroundColorDark,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      );
    } else {
      setStatusBarColor(primaryColor, statusBarIconBrightness: Brightness.light, statusBarBrightness: Brightness.light);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(
          widget.isAdd ? language!.addCustomer : language!.updateCustomer,
          showBack: true,
          color: primaryColor,
          textColor: white,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(12),
              child: Form(
                key: formKeys,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    AppTextField(
                      controller: fNameCont,
                      textFieldType: TextFieldType.NAME,
                      decoration: inputDecoration(context, language!.enterFirstName),
                      isValidationRequired: false,
                    ),
                    16.height,
                    AppTextField(
                      controller: lNameCont,
                      textFieldType: TextFieldType.NAME,
                      decoration: inputDecoration(context, language!.enterLastName),
                      isValidationRequired: false,
                    ),
                    16.height,
                    AppTextField(
                      controller: emailCont,
                      textFieldType: TextFieldType.EMAIL,
                      decoration: inputDecoration(context, language!.enterYourEmail),
                      errorInvalidEmail: language!.invalidEmailAddress,
                    ),
                    16.height,
                    AppTextField(
                      controller: usernameCont,
                      textFieldType: TextFieldType.NAME,
                      decoration: inputDecoration(context, language!.enterUserName),
                      enabled: widget.isAdd ? true : false,
                    ),
                    16.height,
                    AppTextField(
                      controller: passwordCont,
                      textFieldType: TextFieldType.PASSWORD,
                      decoration: inputDecoration(context, language!.enterPassword),
                      errorMinimumPasswordLength: language!.maximumSixLength,
                      isValidationRequired: false,
                    ).visible(widget.isAdd),
                    24.height,
                    AppButton(
                      text: language!.lblAdd,
                      textColor: white,
                      color: primaryColor,
                      shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      width: context.width(),
                      onTap: () {
                        hideKeyboard(context);
                        if (formKeys.currentState!.validate()) {
                          formKeys.currentState!.save();
                          showConfirmDialogCustom(context, onAccept: (context) {
                            addCustomers();
                          }, dialogType: DialogType.ADD);
                          if (!accessAllowed) {
                            toast("Sorry");
                            return;
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Observer(builder: (_) => Loader().visible(appStore.isLoading))
          ],
        ),
      ),
    );
  }
}
