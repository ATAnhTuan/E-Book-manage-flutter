import 'package:bookkart_author/component/ReviewItemWidget.dart';
import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/ReviewResponse.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductReviewScreen extends StatefulWidget {
  static String tag = '/ProductReviewScreen';

  @override
  ProductReviewScreenState createState() => ProductReviewScreenState();
}

class ProductReviewScreenState extends State<ProductReviewScreen> {
  int page = 1;
  bool mIsLastPage = false;
  List<ReviewResponse> reviewList = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await Future.delayed(Duration(milliseconds: 2));
    setStatusBarColor(primaryColor, statusBarIconBrightness: Brightness.light, statusBarBrightness: Brightness.light);
    getAllProductReviewList();

    scrollController.addListener(
      () {
        if ((scrollController.position.pixels - 100) == (scrollController.position.maxScrollExtent - 100)) {
          if (!mIsLastPage) {
            page++;
            appStore.setLoading(true);
            getAllProductReviewList();
            setState(() {});
          }
        }
      },
    );
  }

  Future<void> getAllProductReviewList() async {
    appStore.setLoading(true);

    await getAllReview(page: page).then(
      (res) async {
        if (page == 1) reviewList.clear();

        reviewList.addAll(res);
        mIsLastPage = res.length != perPage;
        setState(() {});
      },
    ).catchError(
      (e) {
        log(e.toString());
        toast(e.toString());
      },
    ).whenComplete(
      () {
        appStore.setLoading(false);
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
    if (appStore.isDarkModeOn) {
      setStatusBarColor(
        appBackgroundColorDark,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      );
    } else {
      setStatusBarColor(white, statusBarIconBrightness: Brightness.dark, statusBarBrightness: Brightness.light);
    }
    LiveStream().dispose(REMOVE_REVIEW);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(language!.productReview, color: primaryColor, textColor: Colors.white),
        body: Stack(
          children: [
            reviewList.isNotEmpty
                ? ListView.separated(
                    separatorBuilder: (context, index) => Divider(height: 0),
                    controller: scrollController,
                    itemCount: reviewList.length,
                    padding: EdgeInsets.all(0),
                    itemBuilder: (context, i) {
                      ReviewResponse review = reviewList[i];
                      return ReviewItemWidget(
                        data: review,
                        onUpdate: () {
                          setState(() {});
                        },
                        onDelete: (id) {
                          reviewList.removeWhere((element) => element.id == id);
                          setState(() {});
                        },
                      );
                    },
                  )
                : NoDataFound(
                    title: language!.noReviewAvailable,
                    onPressed: () {
                      finish(context);
                    }).visible(appStore.isLoading && reviewList.isEmpty),
            Observer(builder: (_) => Loader().visible(appStore.isLoading))
          ],
        ),
      ),
    );
  }
}
