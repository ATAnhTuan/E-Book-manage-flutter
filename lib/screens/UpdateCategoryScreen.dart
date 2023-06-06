import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/CategoryResponse.dart';
import 'package:bookkart_author/models/ProductDetailResponse.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/screens/MediaImageList.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppCommon.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class UpdateCategoryScreen extends StatefulWidget {
  static String tag = '/EditCategoryScreen';

  final List<CategoryResponse>? categoryList;
  CategoryResponse? categoryData;
  bool isEdit = false;

  UpdateCategoryScreen({this.categoryData, this.categoryList, this.isEdit = true});

  @override
  UpdateCategoryScreenState createState() => UpdateCategoryScreenState();
}

class UpdateCategoryScreenState extends State<UpdateCategoryScreen> {
  TextEditingController categoryNameCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();
  var parentCategoryCont = TextEditingController();

  FocusNode categoryFocus = FocusNode();
  FocusNode parentCategoryFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  FocusNode displayTypeFocus = FocusNode();

  List<CategoryResponse> categoryData = [];
  List<Images1> images = [];
  Map<String, dynamic> selectImg = Map<String, dynamic>();

  String? updateImage = '';

  // bool enableIsCheck = false;

  CategoryResponse? pCategoryCont;

  int? parent = 0;

  //String displayTypeCont;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(primaryColor);
    if (widget.isEdit) {
      if (widget.categoryData!.parent != 0) {
        pCategoryCont = widget.categoryList!.singleWhere((element) => element.id == widget.categoryData!.parent.validate());
      }
      categoryNameCont.text = parseHtmlString(widget.categoryData!.name.validate());
      descriptionCont.text = parseHtmlString(widget.categoryData!.description.validate());
      updateImage = widget.categoryData!.image != null ? widget.categoryData!.image!.src.validate() : "";
      parent = widget.categoryData!.parent.validate();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (appStore.isDarkModeOn) {
      setStatusBarColor(
        appBackgroundColorDark,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      );
    } else {
      setStatusBarColor(primaryColor, statusBarIconBrightness: Brightness.dark, statusBarBrightness: Brightness.light);
    }
  }

  ///update categories api call
  Future<void> updateCategories() async {
    var request2 = {
      'name': categoryNameCont.text,
      'parent': parent,
      'description': descriptionCont.text,
      'image': selectImg.isNotEmpty ? selectImg : widget.categoryData!.image,
    };

    log("My Rew $request2");

    appStore.setLoading(true);
    await updateCategory(widget.categoryData!.id, request2).then(
      (res) {
        //  LiveStream().emit(UPDATE_IMAGE);
        //  LiveStream().emit(ADD_CATEGORY);
        toast(language!.successfullyUpdated);
        log('updateDataCate:${widget.categoryData!.toJson().toString()}');
        finish(context, widget.categoryData);
        //finish(context, true);
      },
    ).catchError(
      (error) {
        log(error.toString());
        toast(error.toString().validate());
      },
    ).whenComplete(
      () {
        appStore.setLoading(false);
      },
    );
  }

  ///add categories api call
  Future<void> addCategories() async {
    var request = {
      'name': categoryNameCont.text,
      'parent': parent,
      'description': descriptionCont.text,
      'image': selectImg,
    };

    appStore.setLoading(true);

    log("Request:$request");

    addCategory(request).then(
      (res) {
        toast(language!.successFullyAddedYourCategory);
        widget.categoryList!.add(res);

        finish(context, true);
      },
    ).catchError(
      (error) {
        log(error.toString());
        toast(error.toString().validate());
      },
    ).whenComplete(
      () {
        LiveStream().emit(ADD_CATEGORY, true);
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
    return Scaffold(
      appBar: appBarWidget(
        widget.isEdit ? language!.updateCategory : language!.addCategory,
        color: primaryColor,
        textColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.height,
                AppTextField(
                  controller: categoryNameCont,
                  textFieldType: TextFieldType.NAME,
                  cursorColor: appStore.isDarkModeOn ? white : black,
                  decoration: inputDecoration(context, language!.categoryName),
                ),
                16.height,
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: appStore.isDarkModeOn ? black : white,
                    boxShadow: defaultBoxShadow(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonFormField<CategoryResponse>(
                    dropdownColor: appStore.scaffoldBackground,
                    decoration: InputDecoration.collapsed(hintText: null),
                    hint: Text(language!.selectParentCategory, style: secondaryTextStyle()),
                    isExpanded: true,
                    value: pCategoryCont,
                    focusNode: parentCategoryFocus,
                    items: widget.categoryList!.map(
                      (CategoryResponse e) {
                        return DropdownMenuItem<CategoryResponse>(
                          value: e,
                          child: parent == e.parent
                              ? Text(parseHtmlString(e.name.validate()), style: primaryTextStyle())
                              : Text(
                                  parseHtmlString(e.name.validate()),
                                  style: primaryTextStyle(),
                                ),
                        );
                      },
                    ).toList(),
                    onChanged: (CategoryResponse? value) async {
                      pCategoryCont = value;
                      widget.categoryList!.forEach(
                        (element) {
                          if (element.name == value!.name) {
                            log('Parent11 :- ${element.name.validate() + element.id.toString()}');
                            parent = element.id;
                            log('Parent22 :- ${parent.toString()}');
                          }
                        },
                      );
                      setState(() {});
                    },
                  ),
                ),
                16.height,
                Container(
                  width: context.width(),
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: appStore.isDarkModeOn ? black : white,
                    boxShadow: defaultBoxShadow(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(language!.image, style: primaryTextStyle(letterSpacing: 1)),
                          Icon(Icons.camera_alt).onTap(() async {
                            List<Images1>? res = await MediaImageList().launch(context);
                            if (res != null) {
                              images.addAll(res);
                            }
                            //   LiveStream().emit(UPDATE_IMAGE);

                            /// Id Means media Image id..
                            images.forEach((element) {
                              selectImg['src'] = element.src;
                            });
                            setState(() {});
                          })
                        ],
                      ),
                      cachedImage(
                        widget.categoryData!.image != null ? widget.categoryData!.image!.src.validate() : "",
                        width: context.width(),
                        height: 300,
                        fit: BoxFit.cover,
                      ).cornerRadiusWithClipRRect(6).paddingOnly(top: 16, bottom: 16).visible(widget.isEdit == true),
                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 16,
                        semanticChildCount: 8,
                        padding: EdgeInsets.only(left: 6, right: 6, top: 12, bottom: 8),
                        children: List.generate(
                          images.length,
                          (index) {
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                cachedImage(images[index].src.validate(), width: 300, height: 300, fit: BoxFit.cover).cornerRadiusWithClipRRect(5),
                                Positioned(
                                  right: -5,
                                  top: -8,
                                  child: Icon(AntDesign.closecircleo, size: 20).onTap(() {
                                    images.remove(images[index]);
                                    setState(() {});
                                  }),
                                )
                              ],
                            );
                          },
                        ),
                      ).visible(images.isNotEmpty),
                    ],
                  ),
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
                /*  16.height,
                CheckboxListTile(
                    contentPadding: EdgeInsets.all(0),
                    value: enableIsCheck,
                    onChanged: (bool? val) {
                      setState(() {
                        enableIsCheck = val!;
                      });
                    },
                    title: Text("Enable", style: boldTextStyle(size: 14)),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.blue),*/
                24.height,
                AppButton(
                  text: widget.isEdit ? language!.edit : language!.add,
                  color: primaryColor,
                  textColor: white,
                  shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  width: context.width(),
                  onTap: () {
                    hideKeyboard(context);
                    if (widget.isEdit) {
                      showConfirmDialogCustom(context, onAccept: (context) {
                        updateCategories();
                      }, dialogType: DialogType.UPDATE);
                    } else {
                      showConfirmDialogCustom(context, onAccept: (context) {
                        addCategories();
                      }, dialogType: DialogType.ADD);
                    }
                  },
                ),
                16.height,
              ],
            ),
          ),
          Observer(builder: (_) => Loader().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
