import 'package:bookkart_author/component/ProductDetailComponent.dart';
import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/DashboardResponseData.dart';
import 'package:bookkart_author/models/ProductDetailResponse.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/screens/AddProductScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductDetailScreen extends StatefulWidget {
  final int? mProId;

  ProductDetailScreen({Key? key, this.mProId}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool mIsGroupedProduct = false;
  var currency = '₹';

  String? mSelectedVariation = '';
  double rating = 0.0;
  double discount = 0.0;

  DashboardBookInfo? mProducts;
  DashboardBookInfo? productDetailNew;
  DashboardBookInfo? mainProduct;

  List<ProductDetailResponse1> mProductsList = [];
  List<int> mProductVariationsIds = [];
  List<String?> mProductOptions = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    productDetail();
    afterBuildCreated(() {
      return appStore.setLoading(true);
    });
  }

  ///delete product api call
  Future deleteProductApi() async {
    appStore.setLoading(true);
    setState(() {});
    await deleteBook(widget.mProId)

    .catchError((onError) {
      toast(onError.toString());
    });
    toast(language!.successfullyRemovedProduct);
      //  LiveStream()
      //  successfullyRemovedProduct.emit(UPDATE_PRODUCT);
      // Live stream
    finish(context, widget.mProId);
    appStore.setLoading(false);
  }

  ///product detail api call
  Future productDetail() async {
    // appStore.setLoading(true);
    await getBookDetail(widget.mProId).then(
      (res) {
        if (!mounted) return;
        appStore.setLoading(false);
        mProducts = BookResponse.fromJson(res).bookdetail;
        print(mProducts!.id);
        if (mProducts != null) {
          productDetailNew = mProducts;
          mainProduct = mProducts;
          // rating = double.parse(mainProduct!.averageRating);
          // productDetailNew!.variations!.forEach((element) {
          //   mProductVariationsIds.add(element);
          // });
          // mProductsList.clear();
          // if (mainProduct!.type == "variable") {
          //   mProductOptions.clear();
          //   mProductsList.forEach((product) {
          //     String? option = '';
          //     product.attributes!.forEach(
          //       (attribute) {
          //         if (option!.isNotEmpty) {
          //           option = '$option - ${attribute.options}';
          //         } else {
          //           option = attribute.options as String?;
          //         }
          //       },
          //     );
          //     if (product.onSale!) {
          //       option = '$option [Sale]';
          //     }
          //     mProductOptions.add(option);
          //   });
          //   if (mProductOptions.isNotEmpty) mSelectedVariation = mProductOptions.first;
          //   if (mainProduct!.type == "variable" && mProductsList.isNotEmpty) {
          //     productDetailNew = mProductsList[0];
          //     mProducts = mProducts;
          //   }
          // } else if (mainProduct!.type == 'grouped') {
          //   mIsGroupedProduct = true;
          // }
          // setPriceDetail();
        }
        setState(() {});
      },
    ).catchError(
      (error) {
        log(error);
        appStore.setLoading(false);
        toast(error.toString());
      },
    );
  }

  // ignore: missing_return
  // void setPriceDetail() {
  //   setState(
  //     () {
  //       if (productDetailNew!.onSale!) {
  //         double mrp = double.parse(productDetailNew!.regularPrice!).toDouble();
  //         double discountPrice = double.parse(productDetailNew!.price!).toDouble();
  //         discount = ((mrp - discountPrice) / mrp) * 100;
  //       }
  //     },
  //   );
  // }

  // String getAllAttribute(Attributes attribute) {
  //   String attributes = "";
  //   for (var i = 0; i < attribute.options!.length; i++) {
  //     attributes = attributes + attribute.options![i];
  //     if (i < attribute.options!.length - 1) {
  //       attributes = attributes + ", ";
  //     }
  //   }
  //   return attributes;
  // }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("", showBack: true, actions: [
        PopupMenuButton<int>(
          color: appStore.isDarkModeOn ? cardDarkColor : Colors.white,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Text(language!.update, style: primaryTextStyle()),
            ),
            PopupMenuItem(
              value: 2,
              child: Text(language!.delete, style: primaryTextStyle()),
            ),
          ],
          initialValue: 0,
          onSelected: (value) async {
            if (value == 1) {
              bool? res = await AddProductScreen(mBook: mainProduct, isUpdate: true).launch(context);
              if (res ?? false) {
                init();
                setState(() {
                  productDetail();
                });
              }
            } else {
              showConfirmDialogCustom(
                context,
                onAccept: (context) async {
                  print(widget.mProId);
                  await deleteProductApi();
                },
                dialogType: DialogType.DELETE,
                negativeText: language!.cancel,
                positiveText: language!.delete,
              );
              Navigator.pop(context);
            }
          },
        )
      ]),
      body: Stack(
        children: [
          mainProduct != null ? SingleChildScrollView(child: ProductDetailComponent(mainProduct: mainProduct)) : SizedBox(),
          Observer(builder: (_) => Center(child: Loader()).visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
