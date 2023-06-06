import 'package:bookkart_author/component/ProductAttributesWidget.dart';
import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/AttributeModel.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/screens/AddAttributeScreen.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductAttributeScreen extends StatefulWidget {
  static String tag = '/ProductAttributeScreen';

  @override
  ProductAttributeScreenState createState() => ProductAttributeScreenState();
}

class ProductAttributeScreenState extends State<ProductAttributeScreen> {
  int? selectedIndex;
  int page = 1;
  bool mIsLastPage = false;
  List<AttributeModel> attributeList = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    getAllAttributesList();

    LiveStream().on(UPDATE_ATTRIBUTE, (v) {
      setState(() {});
    });

    scrollController.addListener(
      () {
        if ((scrollController.position.pixels - 100) == (scrollController.position.maxScrollExtent - 100)) {
          if (!mIsLastPage) {
            page++;

            getAllAttributesList();
          }
        }
      },
    );
  }

  ///get all attribute list api call
  Future<void> getAllAttributesList() async {
    appStore.setLoading(true);

    await getAllProductAttributes(page: page).then(
      (res) async {
        if (page == 1) attributeList.clear();

        attributeList.addAll(res);
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
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(language!.productAttribute, showBack: true, color: appStore.isDarkModeOn ? cardDarkColor : Colors.white),
        body: Stack(
          children: [
            attributeList.isNotEmpty
                ? ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      height: 0,
                    ),
                    controller: scrollController,
                    itemCount: attributeList.length,
                    itemBuilder: (_, i) {
                      AttributeModel data = attributeList[i];
                      return ProductAttributesWidget(
                        data: data,
                        onDelete: (id) {
                          attributeList.removeWhere((element) => element.id == id);
                          setState(() {});
                        },
                        onUpdate: () {
                          attributeList.sort((a, b) => a.name!.compareTo(b.name!));
                          setState(() {});
                        },
                      );
                    },
                  )
                : NoDataFound(
                    title: language!.noAttributeAvailable,
                    onPressed: () {
                      finish(context);
                    },
                  ).visible(!appStore.isLoading && attributeList.isEmpty),
            Observer(builder: (_) => Loader().visible(appStore.isLoading))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: '1',
          elevation: 5,
          backgroundColor: colorAccent,
          onPressed: () async {
            var res = await AddAttributeScreen().launch(context);

            if (res != null) {
              if (res is bool) {
                if (res) {
                  setState(() {});
                }
              } else if (res is AttributeModel) {
                attributeList.add(res);
                attributeList.sort((a, b) => a.name!.compareTo(b.name!));

                setState(() {});
              }
            }
          },
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
