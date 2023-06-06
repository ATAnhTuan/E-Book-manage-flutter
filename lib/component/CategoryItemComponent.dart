import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/CategoryResponse.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/screens/SubCategoriesListScreen.dart';
import 'package:bookkart_author/screens/UpdateCategoryScreen.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppCommon.dart';
import 'package:bookkart_author/utils/AppImages.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryItemComponent extends StatefulWidget {
  final List<CategoryResponse>? categoryList;
  CategoryResponse? data;
  final int? index;
  final Function(int?)? onDelete;

  final Function? onUpdate;

  CategoryItemComponent({this.categoryList, this.data, this.index, this.onDelete, this.onUpdate});

  @override
  _CategoryItemComponentState createState() => _CategoryItemComponentState();
}

class _CategoryItemComponentState extends State<CategoryItemComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  ///delete categories data
  Future<void> deleteCategories() async {
    hideKeyboard(context);

    appStore.setLoading(true);
    await deleteCategory(categoryId: widget.data!.id.validate()).then((res) {
      //  LiveStream().emit(UPDATE_IMAGE);
      toast(language!.successfullyDeleted);
      widget.onDelete?.call(res.id);
    }).catchError((error) {
      log(error.toString());
      toast(error.toString().validate());
    }).whenComplete(() {
      //  setState(() {});
      appStore.setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      width: context.width() * 0.45,
      color: context.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          cachedImage(
            widget.data!.image != null ? widget.data!.image!.src.validate() : ic_placeHolder,
            width: context.width() * 0.45,
            radius: 8,
            height: 140,
            fit: BoxFit.cover,
          ).cornerRadiusWithClipRRect(8).paddingAll(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                parseHtmlString(widget.data!.name.validate()),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: boldTextStyle(),
              ).paddingOnly(left: 10).expand(),
              8.width,
              PopupMenuButton(
                onSelected: (v) async {
                  if (v == 1) {
                    if (isVendor) {
                      toast(language!.onlyAdminCanPerformThisAction);
                      return;
                    }
                    // bool? res = await UpdateCategoryScreen(categoryList: widget.categoryList, categoryData: widget.data).launch(context);
                    CategoryResponse res = await UpdateCategoryScreen(categoryList: widget.categoryList, categoryData: widget.data).launch(context);
                    // log("UpdateData" + res.toJson().toString());

                    if (res.id != null) {
                      widget.onUpdate!.call();
                      setState(() {});
                    }
                  } else {
                    if (isVendor) {
                      toast(language!.onlyAdminCanPerformThisAction);
                      return;
                    }
                    showConfirmDialogCustom(
                      context,
                      title: language!.areYouSureWantDeleteCategory,
                      onAccept: (context) {
                        deleteCategories();
                      },
                      dialogType: DialogType.DELETE,
                      negativeText: language!.cancel,
                      positiveText: language!.delete,
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
      ),
    ).onTap(() {
      if (isVendor) {
        toast(language!.onlyAdminCanPerformThisAction);
        return;
      }
      SubCategoriesListScreen(
        categoryId: widget.data!.id.validate(),
        categoryName: widget.data!.name.validate(),
        mainCategoryList: widget.categoryList,
      ).launch(context);
    });
  }
}
