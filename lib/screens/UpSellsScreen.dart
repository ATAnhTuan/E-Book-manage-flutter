import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/ProductDetailResponse.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bookkart_author/utils/AppCommon.dart';

class UpSellsScreen extends StatefulWidget {
  @override
  _UpSellsScreenState createState() => _UpSellsScreenState();
}

class _UpSellsScreenState extends State<UpSellsScreen> {
  TextEditingController search = TextEditingController();
  List<ProductDetailResponse1> productModel = [];
  List<ProductDetailResponse1> searchProductModel = [];
  String mErrorMsg = "";

  int page = 1;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    fetchProductData();
  }

  Future<void> fetchProductData() async {
    appStore.setLoading(true);
    // await getAllProducts(page).then(
    //   (res) {
    //     log(res.length);
    //     productModel.addAll(res);
    //     searchProductModel.addAll(res);

    //     if (res.isEmpty) {
    //       mErrorMsg = ('No Data Found');
    //     } else {
    //       mErrorMsg = '';
    //     }
    //     setState(() {});
    //   },
    // ).catchError(
    //   (error) {
    //     if (!mounted) return;
    //     mErrorMsg = error.toString();
    //     setState(() {});
    //   },
    // );
    // appStore.setLoading(false);
  }

  onSearchTextChanged(String text) async {
    productModel.clear();
    if (text.isEmpty) {
      productModel.addAll(searchProductModel);
      setState(() {});
      return;
    }
    searchProductModel.forEach(
      (product) {
        if (product.name.toLowerCase().contains(text.toLowerCase()) || product.name.toUpperCase().contains(text.toUpperCase())) productModel.add(product);
      },
    );

    setState(() {});
  }

  List<ProductDetailResponse1> getData1() {
    List<ProductDetailResponse1> selected = [];

    productModel.forEach((value) {
      if (value.isCheck == true) {
        selected.add(value);
      }
    });
    setState(() {});
    return selected;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget searchBar = Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey.withOpacity(0.2)),
      child: TextField(
        onChanged: onSearchTextChanged,
        autofocus: false,
        onTap: () {},
        textInputAction: TextInputAction.go,
        controller: search,
        style: primaryTextStyle(),
        decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: white_color,
          hintText: 'Search',
          hintStyle: primaryTextStyle(),
          prefixIcon: Icon(Icons.search, color: appStore.isDarkModeOn ? white : Colors.black, size: 20),
        ),
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        print(getData1().length);
        finish(context, getData1());
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 2,
            backgroundColor: appStore.appBarColor,
            title: Text(
              language!.upsellProduct,
              maxLines: 1,
              style: boldTextStyle(color: appStore.textPrimaryColor, weight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 70),
                child: Column(
                  children: [
                    searchBar,
                    ListView.builder(
                      itemCount: productModel.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          contentPadding: EdgeInsets.only(right: 16, left: 16),
                          value: productModel[index].isCheck,
                          onChanged: (v) {
                            productModel[index].isCheck = !productModel[index].isCheck;
                            setState(() {});
                          },
                          title: Text(
                            productModel[index].name,
                            maxLines: 2,
                            style: primaryTextStyle(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Observer(builder: (_) => Loader().visible(appStore.isLoading)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: colorAccent,
            child: Icon(Icons.check, color: Colors.white),
            onPressed: () {
              print(getData1().length);
              finish(context, getData1());
            },
          ),
        ),
      ),
    );
  }
}
