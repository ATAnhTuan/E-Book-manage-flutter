import 'package:bookkart_author/models/AttributeTermsResponse.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class TermScreen extends StatefulWidget {
  static String tag = '/TermScreen';
  int? id;
  List<AttributeTermsResponse>? option = [];

  TermScreen(this.id, this.option);

  @override
  TermScreenState createState() => TermScreenState();
}

class TermScreenState extends State<TermScreen> {
  List<AttributeTermsResponse> mAttributeTermsModel = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
    fetchAllAttributesTerms(widget.id);
  }

  ///fetch all attribute terms api call
  Future fetchAllAttributesTerms(id) async {
    afterBuildCreated(() {
      appStore.setLoading(true);
    });
    await getAllAttributeTerms(id).then((res) {
      appStore.setLoading(false);
      setState(() {
        Iterable mAttributeTerms = res;
        mAttributeTermsModel = mAttributeTerms.map((model) => AttributeTermsResponse.fromJson(model)).toList();
      });
    }).catchError((error) {
      if (!mounted) return;
      appStore.setLoading(false);
    });
  }

  List<AttributeTermsResponse> getData1() {
    List<AttributeTermsResponse> selected = [];

    mAttributeTermsModel.forEach((value) {
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
              language!.selectValue,
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
                    mAttributeTermsModel.length != null
                        ? ListView.builder(
                            itemCount: mAttributeTermsModel.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                value: mAttributeTermsModel[index].isCheck,
                                onChanged: (v) {
                                  mAttributeTermsModel[index].isCheck = !mAttributeTermsModel[index].isCheck;
                                  setState(() {});
                                },
                                title: Text(
                                  mAttributeTermsModel[index].name!.validate(),
                                  maxLines: 2,
                                  style: primaryTextStyle(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                          )
                        : SizedBox(),
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
