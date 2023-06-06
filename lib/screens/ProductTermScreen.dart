import 'package:bookkart_author/component/ProductTermComponent.dart';
import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/AttributeModel.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/screens/AddTermsScreen.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductTermScreen extends StatefulWidget {
  static String tag = '/ProductAttributeTermScreen';

  final int attributeId;
  final String? attributeName;

  ProductTermScreen({this.attributeId = 0, this.attributeName});

  @override
  ProductTermScreenState createState() => ProductTermScreenState();
}

class ProductTermScreenState extends State<ProductTermScreen> {
  int page = 1;
  bool mIsLastPage = false;
  List<AttributeModel> attributeTermList = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(primaryColor);

    getAllAttributeTermsList();

    scrollController.addListener(
      () {
        if ((scrollController.position.pixels - 100) == (scrollController.position.maxScrollExtent - 100)) {
          if (!mIsLastPage) {
            page++;
            getAllAttributeTermsList();
          }
        }
      },
    );
  }

  ///get attribute terms list api call
  Future<void> getAllAttributeTermsList() async {
    appStore.setLoading(true);

    await getAllAttributesTerms(id: widget.attributeId, page: page).then(
      (res) async {
        if (page == 1) attributeTermList.clear();

        attributeTermList.addAll(res);
        mIsLastPage = res.length != perPage;

        setState(() {});
      },
    ).catchError(
      (e) {
        toast(e.toString());
      },
    );
    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void didUpdateWidget(covariant ProductTermScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        '${widget.attributeName} ' + language!.attributeTerms,
        showBack: true,
        color: primaryColor,
        textColor: white,
      ),
      body: Stack(
        children: [
          attributeTermList.isNotEmpty
              ? ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  controller: scrollController,
                  itemCount: attributeTermList.length,
                  itemBuilder: (_, i) {
                    AttributeModel data = attributeTermList[i];

                    return ProductTermComponent(data: data, attributeId: widget.attributeId);
                  },
                )
              : NoDataFound(
                  title: language!.attributeTermsAvailable,
                  onPressed: () {
                    finish(context);
                  },
                ).visible(!appStore.isLoading && attributeTermList.isEmpty),
          Observer(builder: (_) => Loader().visible(appStore.isLoading))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: '1',
        elevation: 5,
        backgroundColor: colorAccent,
        onPressed: () async {
          var res = await AddTermsScreen(attributeId: widget.attributeId).launch(context);

          if (res != null) {
            if (res is bool) {
              setState(() {});
            } else if (res is AttributeModel) {
              attributeTermList.add(res);
              attributeTermList.sort((a, b) => a.name!.compareTo(b.name!));

              setState(() {});
            }
          }
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
