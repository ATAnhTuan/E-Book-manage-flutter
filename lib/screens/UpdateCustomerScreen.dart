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
class UpdateCustomerScreen extends StatefulWidget {
  static String tag = '/EditCustomerScreen';
  CustomerResponse? customerData;

  UpdateCustomerScreen({this.customerData});

  @override
  UpdateCustomerScreenState createState() => UpdateCustomerScreenState();
}

class UpdateCustomerScreenState extends State<UpdateCustomerScreen> {
  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController usernameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  int index = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(primaryColor, statusBarIconBrightness: Brightness.light, statusBarBrightness: Brightness.light);
    fNameCont.text = widget.customerData!.firstName.validate();
    lNameCont.text = widget.customerData!.lastName.validate();
    emailCont.text = widget.customerData!.email.validate();
    usernameCont.text = widget.customerData!.username.validate();
  }

  Future<void> editCustomers() async {
    appStore.setLoading(true);

    var req = {
      'first_name': fNameCont.text.validate(),
      'last_name': lNameCont.text.validate(),
      'email': emailCont.text.validate(),
    };

    await editCustomer(customerId: widget.customerData!.id.validate(), request: req).then(
      (res) {
        widget.customerData!.firstName = fNameCont.text.validate();
        widget.customerData!.lastName = lNameCont.text.validate();
        widget.customerData!.email = emailCont.text.validate();
        toast(language!.updateSuccessfully);
        finish(context, true);
      },
    ).catchError(
      (error) {
        log(error.toString());
        toast(error.toString().validate());
      },
    ).whenComplete(
      () {
        LiveStream().emit(UPDATE_CUSTOMER, true);
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
        appBar: appBarWidget(language!.updateCustomer, showBack: true, color: primaryColor, textColor: white),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  AppTextField(
                    controller: fNameCont,
                    textFieldType: TextFieldType.NAME,
                    decoration: inputDecoration(context, language!.enterFirstName),
                  ),
                  16.height,
                  AppTextField(
                    controller: lNameCont,
                    textFieldType: TextFieldType.NAME,
                    decoration: inputDecoration(context, language!.enterLastName),
                  ),
                  16.height,
                  AppTextField(
                    controller: emailCont,
                    textFieldType: TextFieldType.EMAIL,
                    decoration: inputDecoration(context, language!.enterYourEmail),
                  ),
                  16.height,
                  AppTextField(
                    controller: usernameCont,
                    textFieldType: TextFieldType.NAME,
                    decoration: inputDecoration(context, language!.enterUserName),
                    enabled: false,
                  ),
                  24.height,
                  AppButton(
                    shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    text: language!.edit,
                    textColor: white,
                    color: primaryColor,
                    width: context.width(),
                    onTap: () {
                      hideKeyboard(context);
                      showConfirmDialogCustom(
                        context,
                        onAccept: (context) {
                          editCustomers();
                        },
                        dialogType: DialogType.UPDATE,
                        negativeText: language!.cancel,
                        positiveText: language!.update,
                      );
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
