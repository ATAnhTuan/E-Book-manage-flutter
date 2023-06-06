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


class GenreComponent extends StatefulWidget {
  final Genres? genres;
  final Function? onDelete;
  final Function? onUpdate;

  GenreComponent({this.genres, this.onDelete, this.onUpdate});

  @override
  _GenreComponentState createState() => _GenreComponentState();
}

class _GenreComponentState extends State<GenreComponent> {
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
    var imageUrl = 'https://secure.gravatar.com/avatar/4e838b59bfff152199fcc9bc3b4aa02e?s=96&d=mm&r=g';
    name.text = widget.genres!.name.toString();
    authorID.text = widget.genres!.id.toString();
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
                Text("Genre Detail")
                : 
                Text("Update Genre"),
              8.height,
                TextFormField(
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(26, 18, 4, 18),
                    hintText: "Genre ID",
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
                          var request = {'name' : name.text};
                          updateVietJetGenre(widget.genres!.id,request).then((value) {
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
    // switchValue = widget.genres!.isActive!;
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
                parseHtmlString(widget.genres!.name.validate()),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: boldTextStyle(),
              ).paddingOnly(left: 10).expand(),
              8.width,
              PopupMenuButton(
                onSelected: (v) async {
                  if (v == 1) {
                   showDialogAdd(context);
                  }
                  else{
                    showConfirmDialogCustom(
                      context,
                      onAccept: (context) {
                        deleteGenre(widget.genres!.id).then((value){
                        widget.onDelete!.call(widget.genres!.id);
                        toast(language!.successfullyDeleted);
                        });

                      },
                      dialogType: DialogType.DELETE,
                      negativeText: language!.cancel,
                      positiveText: language!.update,
                    );
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
                      prefix: Icon(Icons.delete, size: 14, color: Colors.red),
                      text: language!.delete,
                      textStyle: secondaryTextStyle(color: Colors.red),
                    ),
                    value: 2,
                  )
                ],
              ),
            ],
          ),
        ],
      ).paddingAll(5),
    );
  }
}
