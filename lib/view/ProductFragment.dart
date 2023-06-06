import 'dart:convert';

import 'package:bookkart_author/component/ProductItemComponent.dart';
import 'package:bookkart_author/models/DashboardResponseData.dart';
import 'package:bookkart_author/models/MediaModel.dart';
import 'package:bookkart_author/models/ProductDetailResponse.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/utils/AppColors.dart' as color;
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../screens/AddProductScreen.dart';

class ProductFragment extends StatefulWidget {
  static String tag = '/ProductFragment';

  @override
  ProductFragmentState createState() => ProductFragmentState();
}

class ProductFragmentState extends State<ProductFragment> {
  bool switchValue = false;
  bool mIsLastPage = false;
  List<ProductDetailResponse1> mProductModel = [];
  List<DashboardBookInfo> mBookList = [];

  ScrollController scrollController = ScrollController();
  String mErrorMsg = '';
  int page = 1;

  @override
  void initState() {
    super.initState();
    init();
    scrollController.addListener(
      () {
        if ((scrollController.position.pixels - 100) == (scrollController.position.maxScrollExtent - 100)) {
          if (!mIsLastPage) {
            page++;
            fetchProductData();
          }
        }
      },
    );
  }

  Future<void> init() async {
    fetchProductData();
    LiveStream().on(UPDATE_PRODUCT, (v) {
      fetchProductData();
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    LiveStream().dispose(UPDATE_PRODUCT);
  }

  ///fetch product data api call
  Future fetchProductData() async {
    appStore.setLoading(true);
     await getVietJetAllBooks().then((value) {
      DashboardResponseData dashboardResponseData = DashboardResponseData.fromJson(value);
      setState(() {
        mBookList = dashboardResponseData.data!;
      });
     })
    .catchError(
      (error) {
        if (!mounted) return;
        mErrorMsg = error.toString();
        setState(() {
        });
      },
    );
    appStore.setLoading(false);
  }

  


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

    Future showDialogAdd(BuildContext context,{publisher = false,  author = false, genres = false, department = false}) async {
    var name = TextEditingController();
    var description = TextEditingController();
    var code = TextEditingController();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: appStore.scaffoldBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)), //this right here
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Create new Publisher").visible(publisher),
                Text("Create new Author").visible(author),
                Text("Create new Genre").visible(genres),
                Text("Create new Department").visible(department),
                8.height,
                TextFormField(
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(26, 18, 4, 18),
                    hintText: "Code",
                    filled: true,
                    hintStyle: secondaryTextStyle(color: appStore.textSecondaryColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: appStore.appBarColor!, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: appStore.appColorPrimaryLightColor!, width: 0.0),
                    ),
                  ),
                  controller: code,
                  maxLines: 3,
                  minLines: 1,
                ).visible(department),
                8.height,
                TextFormField(
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(26, 18, 4, 18),
                    hintText: "Name",
                    filled: true,
                    hintStyle: secondaryTextStyle(color: appStore.textSecondaryColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: appStore.appBarColor!, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: appStore.appColorPrimaryLightColor!, width: 0.0),
                    ),
                  ),
                  controller: name,
                  maxLines: 3,
                  minLines: 1,
                ),
                16.height,
                TextFormField(
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(26, 18, 4, 18),
                    hintText: (author) ? "Bio" : "Description",
                    filled: true,
                    hintStyle: secondaryTextStyle(color: appStore.textSecondaryColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: appStore.appBarColor!, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: appStore.appColorPrimaryLightColor!, width: 0.0),
                    ),
                  ),
                  controller: description,
                  maxLines: 3,
                  minLines: 2,
                ).visible(!genres),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey, style: BorderStyle.solid),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    20.width,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      ),
                      onPressed: () {
                        if(publisher) {
                          var request = {'name' : name.text, 'description' : description.text};
                          print(jsonEncode(request));
                          addVietJetPublisher(request).then((value) {
                            toast(language!.addSuccessfully);
                          });
                        } else if(author) {
                            var request = {'fullname' : name.text,'bio' : description.text};
                          addVietJetAuthor(request).then((value) {
                            toast(language!.addSuccessfully);
                          });
                        } else if (genres){
                          var request = {'name' : name.text};
                          addVietJetGenre(request).then((value) {
                            toast(language!.addSuccessfully);
                          });
                        } else {
                          var request = {'code' : code.text,'name' : name.text, 'description' : description.text};
                          addVietJetDepartment(request).then((value) {
                          toast(language!.addSuccessfully);
                          });
                        }
                    
                        hideKeyboard(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Submit!",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: appStore.appBarColor,
          title: Text(
            language!.books,
            maxLines: 1,
            style: boldTextStyle(color: appStore.textPrimaryColor, weight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
        //   actions: [
        //     PopupMenuButton<int>(
        //   color: appStore.isDarkModeOn ? cardDarkColor : Colors.white,
        //   itemBuilder: (context) => [
        //     PopupMenuItem(
        //       value: 1,
        //       child: Text("Add Publisher", style: primaryTextStyle()),
        //     ),
        //     PopupMenuItem(
        //       value: 2,
        //       child: Text("Add Author", style: primaryTextStyle()),
        //     ),
        //     PopupMenuItem(
        //       value: 3,
        //       child: Text("Add Genre", style: primaryTextStyle()),
        //     ),
        //     PopupMenuItem(
        //       value: 4,
        //       child: Text("Add Department", style: primaryTextStyle()),
        //     ),
        //   ],
        //   initialValue: 0,
        //   onSelected: (value) async {
        //     if (value == 1) {
        //       showDialogAdd(context,publisher: true);
        //     } else if(value == 2) {
        //       showDialogAdd(context,author: true);
        //     } else if (value == 3) {
        //       showDialogAdd(context,genres: true);
        //     }else {
        //       showDialogAdd(context,department: true);
        //     }
        //   },
        // )],
        ),
        
        body: RefreshIndicator(
          edgeOffset: context.height() / 2 - 135,
          onRefresh: () {
            return fetchProductData();
          },
          child: Stack(
            children: [
              mBookList.isNotEmpty
                  ? ListView.separated(
                      separatorBuilder: (context, i) => Divider(height: 0),
                      padding: EdgeInsets.only(top: 8, bottom: 16),
                      controller: scrollController,
                      itemCount: mBookList.length,
                      itemBuilder: (context, i) {
                        return ProductItemComponent(
                          mbook: mBookList[i],
                          onUpdate: (id) {
                            setState(() {});
                          },
                          onDelete: (id) {
                            mBookList.removeWhere((element) => element.id == id);
                            setState(() {});
                          },
                        );
                      },
                    )
                  : NoDataFound(
                      title: language!.noDataAvailable,
                      onPressed: () {
                        fetchProductData();
                      },
                    ).visible(!appStore.isLoading && mBookList.isEmpty),
              Observer(builder: (_) => Loader().visible(appStore.isLoading)),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: '1',
          elevation: 5,
          backgroundColor: color.colorAccent,
          onPressed: () async {
            var res = await AddProductScreen(isUpdate: false).launch(context);
            if (res != null) {
              mProductModel.clear();
              init();
              setState(() {});
            }
          },
          child: Icon(Icons.add, color: Colors.white),
        ),
      );
    });
  }
}
