import 'package:bookkart_author/component/OrderComponent.dart';
import 'package:bookkart_author/component/RequestComponent.dart';
import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/BorrowRequestResponse.dart';
import 'package:bookkart_author/models/OrderResponse.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class OrderFragment extends StatefulWidget {
  static String tag = '/OrderFragment';

  @override
  _OrderFragmentState createState() => _OrderFragmentState();
}

class _OrderFragmentState extends State<OrderFragment> with SingleTickerProviderStateMixin {
  bool mIsLastPage = false;
  int page = 1;
  ScrollController scrollController = ScrollController();
  List<BorrowRequestData>? listRequest = [];
  List<Extensions>? listExtention = [];
  List<BorrowRequestData> listRequestEx = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    init();
    _tabController = TabController(length: 2, vsync: this);
  }

  init() async {
    getRequestBorrow();
    getRequestBorrowExtention();
  }

  ///get order api call
  Future<void> getRequestBorrow() async {
    appStore.setLoading(true);
    await getVietJetAllRequestsPending().then(
      (res) {
            BorrowRequestResponse response = BorrowRequestResponse.fromJson(res);
            listRequest = response.data!;
            print(listRequest![0].bookInfo!.title);
        setState(() {});
      },
    ).catchError(
      (e) {
        log(e.toString());
      },
    );
    appStore.setLoading(false);
  }

  Future<void> getRequestBorrowExtention() async {
    appStore.setLoading(true);
    await getVietJetAllRequestsExtention().then(
      (res) {
            ExtensionsResponse response = ExtensionsResponse.fromJson(res);
            listExtention = response.data!;
                listRequestEx.clear();
          var count = 0;
          listExtention!.forEach((element)  {
          listRequestEx.add(element.request!);
          listRequestEx[count].createdAt = element.createdAt;
          listRequestEx[count].id = element.id;
          listRequestEx[count].status = element.status;
          count++;
    });
        setState(() {});
      },
    ).catchError(
      (e) {
        log(e.toString());
      },
    );
    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Requests", style: boldTextStyle()),
          backgroundColor: appStore.appBarColor,
          centerTitle: true,
        ),
        body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.height,
            Text(
            "${language!.hello}" +
                ", " +
                getStringAsync(FIRST_NAME) +
                getStringAsync(LAST_NAME),
            style: boldTextStyle(size: 18),
          ).paddingLeft(16),
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  // give the indicator a decoration (color and border radius)
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                    color: Colors.green,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Tab(
                      text: 'Request Borrow Books',
                    ),
                    Tab(
                      text: 'Request Extend Books',
                    ),
                  ],
                ),
              ).paddingAll(10)
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 260,
                      child: listRequest!.isNotEmpty
                          ? ListView.separated(
                              itemBuilder: (context, index) {
                                return RequestComponent(
                                  requestdata: listRequest![index],
                                  onApprove: (id) {
                                    setState(() {
                                      listRequest!.removeWhere((element) => element.id == id);
                                    });
                                  },
                                  onReject: (id) {
                                    setState(() {
                                      listRequest!.removeWhere((element) => element.id == id);
                                    });
                                  },
                                  request: true,
                                );
                              },
                              separatorBuilder: (context, i) => Divider(
                                    height: 0,
                                    thickness: 2,
                                  ),
                              itemCount: listRequest!.length)
                          :  NoDataFound(
                    title: language!.noDataAvailable,
                    onPressed: () {
                      getRequestBorrow();
                    },
                  ).visible(!appStore.isLoading && listRequest!.isEmpty),
                    ),
                  ],
                )
                ),
                SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 260,
                      child: listRequestEx!.isNotEmpty
                          ? ListView.separated(
                              itemBuilder: (context, index) {
                                return RequestComponent(
                                  requestdata: listRequestEx[index],
                                  onApprove: (id) {
                                    setState(() {
                                    listRequestEx.removeWhere((element) => element.id == id);
                                    });
                                  },
                                  onReject: (id, status) {
                                    setState(() {
                                    listRequestEx.removeWhere((element) => element.id == id);
                                    });
                                  },
                                  extention: true,
                                );
                              },
                              separatorBuilder: (context, i) => Divider(
                                    height: 0,
                                    thickness: 2,
                                  ),
                              itemCount: listRequestEx!.length)
                          :  NoDataFound(
                    title: language!.noDataAvailable,
                    onPressed: () {
                      getRequestBorrow();
                      getRequestBorrowExtention();
                    },
                  ).visible(!appStore.isLoading && listRequest!.isEmpty),
                    ),
                  ],
                )
                ),
          ]
          )
          ),
            6.height,
            Observer(builder: (_) => Loader().visible(appStore.isLoading))
          ],
        )
      );
  }
}
