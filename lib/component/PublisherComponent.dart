import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/CategoryResponse.dart';
import 'package:bookkart_author/models/DashboardResponseData.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/screens/SubCategoriesListScreen.dart';
import 'package:bookkart_author/screens/UpdateCategoryScreen.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppCommon.dart';
import 'package:bookkart_author/utils/AppImages.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';


class PublisherComponent extends StatefulWidget {
  final Publisher? publisher;
  final Function? onDelete;
  final Function? onUpdate;

  PublisherComponent({this.publisher, this.onDelete, this.onUpdate});

  @override
  _PublisherComponentState createState() => _PublisherComponentState();
}

class _PublisherComponentState extends State<PublisherComponent> {
    bool switchValue =  true;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
 
  }

   Future showDialogAdd(BuildContext context,{detail = false}) async {
    var name = TextEditingController();
    var description = TextEditingController();
    var authorID = TextEditingController();
    name.text = widget.publisher!.name.toString();
    authorID.text = widget.publisher!.id.toString();
    description.text = widget.publisher!.description.toString();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: appStore.scaffoldBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)), //this right here
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                (detail) ? 
                Text("Publisher Details")
                : 
                Text("Update Publisher"),
              8.height,
                TextFormField(
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(26, 18, 4, 18),
                    hintText: "ID",
                    filled: true,
                    enabled: !detail,
                    hintStyle: secondaryTextStyle(color: appStore.textSecondaryColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: appStore.appBarColor!, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: appStore.appColorPrimaryLightColor!, width: 0.0),
                    ),
                  ),
                  controller: authorID,
                  maxLines: 3,
                  minLines: 1,
                ).visible(detail),
                8.height,
                TextFormField(
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(26, 18, 4, 18),
                    hintText: "Name",
                    enabled: !detail,
                    filled: true,
                    hintStyle: secondaryTextStyle(color: appStore.textSecondaryColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: appStore.appBarColor!, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: appStore.appColorPrimaryLightColor!, width: 0.0),
                    ),
                  ),
                  controller: name,
                  maxLines: 3,
                  minLines: 1,
                ),
                16.height,
                TextFormField(
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(26, 18, 4, 18),
                    hintText: "Description",
                    enabled: !detail,
                    filled: true,
                    hintStyle: secondaryTextStyle(color: appStore.textSecondaryColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: appStore.appBarColor!, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: appStore.appColorPrimaryLightColor!, width: 0.0),
                    ),
                  ),
                  controller: description,
                  maxLines: 3,
                  minLines: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey, style: BorderStyle.solid),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    20.width,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      ),
                      onPressed: () {
                          var request = {'fullname' : name.text, 'description' : description.text};
                           updateVietJetPublisher(widget.publisher!.id,request).then((value) {
                            toast(language!.updateSuccessfully);
                          });
                        widget.onUpdate!.call();
                        hideKeyboard(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Submit!",
                        style: TextStyle(color: Colors.white),
                      ),
                    ).visible(!detail),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  
  @override
  Widget build(BuildContext context) {
    switchValue = widget.publisher!.isActive!;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      width: context.width() * 0.45,
      color: context.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                parseHtmlString(widget.publisher!.name.validate()),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: boldTextStyle(),
              ).paddingOnly(left: 10).expand(),
                              8.height,
              Row(
            children: [
              switchValue
                  ? Text("Active", style: primaryTextStyle(color: Colors.green))
                  : Text(
                      "Inactive",
                      style: primaryTextStyle(color: Colors.red),
                    ),
              Switch(
                inactiveThumbColor: Colors.red,
                inactiveTrackColor: Colors.redAccent.withOpacity(0.4),
                activeColor: appStore.isDarkModeOn ? Colors.green : primaryColor,
                value: switchValue,
                onChanged: (_value) {
                    switchValue = _value;
                    var request = {'isActive': switchValue};
                    updateVietJetPublisherStatus(widget.publisher!.id, request).then((value){
                      toast(language!.updateSuccessfully);
                     widget.onDelete!.call(widget.publisher!.id,switchValue);
                    });

                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
              8.width,
              PopupMenuButton(
                onSelected: (v) async {
                  if (v == 1) {
                   showDialogAdd(context);
                  }
                  else{
                  showDialogAdd(context,detail: true);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: TextIcon(
                      prefix: Icon(Icons.edit, size: 14, color: appStore.isDarkModeOn ? white : primaryColor),
                      text: language!.edit,
                      textStyle: secondaryTextStyle(color: appStore.isDarkModeOn ? white : primaryColor),
                    ),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: TextIcon(
                      prefix: Icon(Icons.maps_ugc_rounded, size: 14, color: Colors.black),
                      text: "Details",
                      textStyle: secondaryTextStyle(color: Colors.black),
                    ),
                    value: 2,
                  ),
                ],
              ),
            ],
          ),
        ],
      ).paddingAll(5),
    );
  }
}
