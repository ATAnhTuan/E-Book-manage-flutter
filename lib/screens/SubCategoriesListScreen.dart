import 'package:async/async.dart';
import 'package:bookkart_author/component/CategoryItemComponent.dart';
import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/CategoryResponse.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class SubCategoriesListScreen extends StatefulWidget {
  static String tag = '/SubCategoriesListScreen';

  final int? categoryId;
  final String? categoryName;
  final List<CategoryResponse>? mainCategoryList;

  SubCategoriesListScreen({this.categoryId, this.categoryName, this.mainCategoryList});

  @override
  SubCategoriesListScreenState createState() => SubCategoriesListScreenState();
}

class SubCategoriesListScreenState extends State<SubCategoriesListScreen> {
  AsyncMemoizer asyncMemoizer = AsyncMemoizer<List<CategoryResponse>>();

  List<CategoryResponse>? categoryList = [];
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
    setStatusBarColor(primaryColor, statusBarIconBrightness: Brightness.light, statusBarBrightness: Brightness.light);
    LiveStream().on(ADD_CATEGORY, (v) {
      getAllSubCategoryList();
    });

    getAllSubCategoryList();

    scrollController.addListener(
      () {
        if ((scrollController.position.pixels - 100) == (scrollController.position.maxScrollExtent - 100)) {
          if (!mIsLastPage) {
            page++;
            getAllSubCategoryList();
          }
        }
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  ///get sub category api call
  Future<void> getAllSubCategoryList() async {
    appStore.setLoading(true);

    await getSubCategories(widget.categoryId).then(
      (res) {
        if (!mounted) return;
        appStore.setLoading(false);

        categoryList!.clear();
        categoryList!.addAll(res);
        mIsLastPage = res.length != perPage;

        setState(() {});
      },
    ).catchError(
      (e) {
        if (!mounted) return;
        appStore.setLoading(false);

        log(e.toString());
        toast(e.toString());
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    LiveStream().dispose(ADD_CATEGORY);
    LiveStream().dispose(UPDATE_IMAGE);
    scrollController.dispose();
    setStatusBarColor(
      primaryColor,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(widget.categoryName.toString(), showBack: true, color: primaryColor, textColor: white),
        body: Stack(
          children: [
            FutureBuilder<List<CategoryResponse>>(
              future: asyncMemoizer.runOnce(() => getSubCategories(widget.categoryId)).then((value) => value as List<CategoryResponse>),
              builder: (_, snap) {
                if (snap.hasData) {
                  if (snap.data!.isNotEmpty) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      alignment: WrapAlignment.start,
                      children: List.generate(snap.data!.length, (i) {
                        data = snap.data![i];
                        categoryList = snap.data;
                        return CategoryItemComponent(
                          data: data,
                          index: i,
                          categoryList: widget.mainCategoryList,
                          onDelete: (id) {
                            categoryList!.removeWhere((element) => element.id == id);
                            setState(() {});
                          },
                          onUpdate: () async {
                            await getAllSubCategoryList();
                            setState(() {});
                          },
                        );
                      }),
                    ).paddingOnly(left: 12, top: 12, bottom: 65, right: 12);
                  } else {
                    return NoDataFound(
                      title: language!.noSubCategoriesAvailable,
                      onPressed: () {
                        finish(context);
                      },
                    );
                  }
                }
                return snapWidgetHelper(
                  snap,
                  errorWidget: Container(
                    child: Text(snap.error.toString().validate(), style: primaryTextStyle()).paddingAll(16).center(),
                    height: context.height(),
                    width: context.width(),
                  ),
                );
              },
            ),
            Observer(builder: (_) => Loader().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
