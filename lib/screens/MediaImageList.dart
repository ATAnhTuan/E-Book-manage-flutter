import 'package:bookkart_author/models/ProductDetailResponse.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class MediaImageList extends StatefulWidget {
  static String tag = '/MediaImageListWidget';

  @override
  MediaImageListState createState() => MediaImageListState();
}

class MediaImageListState extends State<MediaImageList> {
  List<Images1> mediaImgList = [];
  List<Images1> selectedImageList = [];
  ScrollController scrollController = ScrollController();

  int? selectedIndex;
  int page = 1;

  bool mIsLastPage = false;

  @override
  void initState() {
    super.initState();
    setStatusBarColor(primaryColor, statusBarIconBrightness: Brightness.light, statusBarBrightness: Brightness.light);

    init();
  }

  Future<void> init() async {
    getMediaImages();
    log(selectedImageList.length);

    scrollController.addListener(
      () {
        if ((scrollController.position.pixels - 100) == (scrollController.position.maxScrollExtent - 100)) {
          if (!mIsLastPage) {
            page++;
            appStore.setLoading(true);
            getMediaImages();
            setState(() {});
          }
        }
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  ///get medial image api call
  Future<void> getMediaImages() async {
    appStore.setLoading(true);

    await getMediaImage(page).then(
      (res) async {
        if (page == 1) mediaImgList.clear();

        mediaImgList.addAll(res);
        mIsLastPage = res.length != ImgPerPage;

        log(mediaImgList.length);
        setState(() {});
      },
    ).catchError(
      (e) {
        log(e.toString());
        toast(e.toString());
      },
    );

    appStore.setLoading(false);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
    if (appStore.isDarkModeOn) {
      setStatusBarColor(
        appBackgroundColorDark,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      );
    } else {
      setStatusBarColor(
        Colors.white,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(
          language!.media,
          showBack: true,
          color: primaryColor,
          textColor: white,
          actions: [
            IconButton(
                icon: Icon(Icons.check, color: white),
                onPressed: () {
                  finish(context, selectedImageList);
                }),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              child: Wrap(
                runSpacing: 0,
                spacing: 0,
                children: mediaImgList.map(
                  (e) {
                    return Stack(
                      children: [
                        cachedImage(
                          e.src.validate(),
                          height: 160,
                          width: context.width() * 0.333,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          color: !selectedImageList.contains(e) ? Colors.transparent : black.withOpacity(0.52),
                          height: 160,
                          width: context.width() * 0.333,
                          child: !selectedImageList.contains(e) ? SizedBox() : Icon(Icons.check_circle, size: 35, color: white),
                        ),
                      ],
                    ).onTap(
                      () {
                        if (selectedImageList.contains(e)) {
                          selectedImageList.remove(e);
                        } else {
                          selectedImageList.add(e);
                        }
                        setState(() {});
                        log(selectedImageList.length);
                      },
                    );
                  },
                ).toList(),
              ),
            ),
            Observer(builder: (_) => Loader().center().visible(appStore.isLoading))
          ],
        ),
      ),
    );
  }
}
