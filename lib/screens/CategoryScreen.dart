import 'package:bookkart_author/component/CategoryItemComponent.dart';
import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/CategoryResponse.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/screens/UpdateCategoryScreen.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppCommon.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryScreen extends StatefulWidget {
  static String tag = '/CategoryScreen';

  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> {
  List<CategoryResponse> categoryList = [];
  CategoryResponse data = CategoryResponse();
  ScrollController scrollController = ScrollController();

  int page = 1;
  bool mIsLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    getAllCategoryList();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  ///get category list api call
  Future<void> getAllCategoryList() async {
    appStore.setLoading(true);
    await getAllCategory(page: page).then(
      (res) {
        categoryList.clear();

        categoryList.addAll(res);
        mIsLastPage = res.length != perPage;

        setState(() {});
      },
    ).catchError(
      (e) {
        if (!mounted) return;
        log(e.toString());
        toast(e.toString());
        setState(() {});
      },
    );

    appStore.setLoading(false);
  }

  @override
  void dispose() {
    super.dispose();
    LiveStream().dispose(ADD_CATEGORY);
    LiveStream().dispose(UPDATE_IMAGE);
    scrollController.dispose();
  }

  @override
  void didUpdateWidget(covariant CategoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(language!.category, showBack: true, color: appStore.isDarkModeOn ? cardDarkColor : Colors.white),
        body: Stack(
          children: [
            categoryList.isNotEmpty
                ? SingleChildScrollView(
                    controller: scrollController,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      alignment: WrapAlignment.start,
                      children: List.generate(
                        categoryList.length,
                        (i) {
                          CategoryResponse data = categoryList[i];

                          return CategoryItemComponent(
                            data: data,
                            index: i,
                            categoryList: categoryList,
                            onDelete: (id) {
                              categoryList.removeWhere((element) => element.id == id);
                              setState(() {});
                            },
                            onUpdate: () async {
                              await getAllCategoryList();
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ).paddingOnly(top: 16, bottom: 80).center(),
                  )
                : NoDataFound(
                    title: language!.noAttributeAvailable,
                    onPressed: () {
                      init();
                    },
                  ).visible(!appStore.isLoading && categoryList.isEmpty),
            Observer(builder: (_) => Loader().visible(appStore.isLoading)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: '1',
          elevation: 5,
          backgroundColor: colorAccent,
          onPressed: () async {
            if (isVendor) {
              toast(language!.onlyAdminCanPerformThisAction);
              return;
            }
            bool? res = await UpdateCategoryScreen(isEdit: false, categoryList: categoryList, categoryData: data).launch(context);
            if (res ?? false) {
              page = 1;
              getAllCategoryList();
            }
          },
          child: Icon(Icons.add, color: Colors.white),
        ).visible(getStringAsync(USER_ROLE) != Seller),
      ),
    );
  }
}
