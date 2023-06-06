import 'package:bookkart_author/component/AuthorComponent.dart';
import 'package:bookkart_author/component/DepartmentComponent.dart';
import 'package:bookkart_author/component/ExpandChartToLandScapeModeComponent.dart';
import 'package:bookkart_author/component/GenreComponent.dart';
import 'package:bookkart_author/component/HorizontalBarChart.dart';
import 'package:bookkart_author/component/OrderComponent.dart';
import 'package:bookkart_author/component/ProductTotalWidget.dart';
import 'package:bookkart_author/component/PublisherComponent.dart';
import 'package:bookkart_author/component/SaleReportWidget.dart';
import 'package:bookkart_author/component/TotalCustomerWidget.dart';
import 'package:bookkart_author/component/TotalOrderWidget.dart';
import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/CategoryResponse.dart';
import 'package:bookkart_author/models/DashboardResponse.dart';
import 'package:bookkart_author/models/DashboardResponseData.dart';
import 'package:bookkart_author/models/OrderResponse.dart';
import 'package:bookkart_author/models/SummaryResponse.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeFragment extends StatefulWidget {
  static String tag = '/HomeFragment';

  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Authors> listAuthor = [];
  List<Genres> listGenres = [];
  List<Departments> listDepartment = [];
  List<Publisher> listPublisher = [];

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
    init();
  }

  init() async {
    getAllAuthorList();
    getAllDepartmentList();
    getAllPublisherList();
    getAllGenresList();
    log("NewToken:${getStringAsync(TOKEN)}");
    log("UserId:${getIntAsync(USER_ID)}");
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future<void> getAllDepartmentList() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
    });
    await getDepartmentListRestApi().then((res) async {
      DepartmentResponseData response = DepartmentResponseData.fromJson(res);
      listDepartment = response.data!;
      setState(() {});
    }).catchError((e) {
      log(e.toString());
    });

    appStore.setLoading(false);
  }

  Future<void> getAllPublisherList() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
    });
    await getPublisherListRestApi().then((res) async {
      PublisherResponseData response = PublisherResponseData.fromJson(res);
      listPublisher = response.data!;
      setState(() {});
    }).catchError((e) {
      log(e.toString());
    });

    appStore.setLoading(false);
  }

  Future<void> getAllGenresList() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
    });
    await getVietJetAllGenres().then((res) async {
      GenresResponse response = GenresResponse.fromJson(res);
      listGenres = response.genresdetail!;
      setState(() {});
    }).catchError((e) {
      log(e.toString());
    });

    appStore.setLoading(false);
  }

  Future<void> getAllAuthorList() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
    });
    await getAuthorListRestApi().then((res) async {
      AuthorResponseData response = AuthorResponseData.fromJson(res);
        listAuthor = response.data!;
        setState(() { });
    }).catchError((e) {
      log(e.toString());
    });

    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future showDialogAdd(BuildContext context,
      {publisher = false,
      author = false,
      genres = false,
      department = false}) async {
    var name = TextEditingController();
    var description = TextEditingController();
    var code = TextEditingController();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: appStore.scaffoldBackground,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)), //this right here
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
                    hintStyle:
                        secondaryTextStyle(color: appStore.textSecondaryColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: appStore.appBarColor!, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: appStore.appColorPrimaryLightColor!,
                          width: 0.0),
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
                    hintStyle:
                        secondaryTextStyle(color: appStore.textSecondaryColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: appStore.appBarColor!, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: appStore.appColorPrimaryLightColor!,
                          width: 0.0),
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
                    hintStyle:
                        secondaryTextStyle(color: appStore.textSecondaryColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: appStore.appBarColor!, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: appStore.appColorPrimaryLightColor!,
                          width: 0.0),
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
                        side: BorderSide(
                            color: Colors.grey, style: BorderStyle.solid),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      onPressed: () {
                        if (publisher) {
                          var request = {
                            'name': name.text,
                            'description': description.text
                          };
                          addVietJetPublisher(request).then((value) {
                            toast(language!.addSuccessfully);
                          });
                        } else if (author) {
                          var request = {
                            'fullname': name.text,
                            'bio': description.text
                          };
                          addVietJetAuthor(request).then((value) {
                            toast(language!.addSuccessfully);
                          });
                        } else if (genres) {
                          var request = {'name': name.text};
                          addVietJetGenre(request).then((value) {
                            toast(language!.addSuccessfully);
                          });
                        } else {
                          var request = {
                            'code': code.text,
                            'name': name.text,
                            'description': description.text
                          };
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Manage Page",
          style: boldTextStyle(size: 18),
        ),
      ),
      backgroundColor: appStore.scaffoldBackground,
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
          10.height,
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
                      text: 'Author',
                    ),
                    Tab(
                      text: 'Genres',
                    ),
                    Tab(
                      text: 'Publisher',
                    ),
                    Tab(
                      text: 'Department',
                    ),
                  ],
                ),
              )
            ],
          ),
          32.height,
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // first tab bar view widget
                SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        showDialogAdd(context,author: true);
                      },
                      icon: Icon(
                        Icons.add_box_outlined,
                        size: 30.0,
                      ),
                      label: Text('Create',),
                    ).paddingLeft(10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 260,
                      child: listAuthor.isNotEmpty
                          ? ListView.separated(
                              itemBuilder: (context, index) {
                                return AuthorComponent(
                                  authors: listAuthor[index],
                                  onUpdate: () {
                                    setState(() {
                                      getAllAuthorList();
                                    });
                                  },
                                  onDelete: (id, status) {
                                    setState(() {
                                      listAuthor.forEach((element) {
                                        if(element.id == id) {
                                          element.isActive = status;
                                        }
                                      });
                                    });
                                  },
                                );
                              },
                              separatorBuilder: (context, i) => Divider(
                                    height: 0,
                                    thickness: 2,
                                  ),
                              itemCount: listAuthor.length)
                          : Text('Author is Empty',
                                  style: boldTextStyle(size: 18)).visible(appStore.isLoading)
                              .center(heightFactor: 20),
                    ),
                  ],
                )
                ),
                SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        showDialogAdd(context,genres: true);
                      },
                      icon: Icon(
                        Icons.add_box_outlined,
                        size: 30.0,
                      ),
                      label: Text('Create',),
                    ).paddingLeft(10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 260,
                      child: listGenres.isNotEmpty
                          ? ListView.separated(
                              itemBuilder: (context, index) {
                                return GenreComponent(
                                  genres: listGenres[index],
                                  onUpdate: () {
                                    setState(() {
                                      getAllGenresList();
                                    });
                                  },
                                  onDelete: (id) {
                                    setState(() {
                                      listGenres.removeWhere((element) => element.id == id);
                                    });
                                  },
                                );
                              },
                              separatorBuilder: (context, i) => Divider(
                                    height: 0,
                                    thickness: 2,
                                  ),
                              itemCount: listGenres.length)
                          : Text('Genres is empty',
                                  style: boldTextStyle(size: 18)).visible(appStore.isLoading)
                              .center(heightFactor: 20),
                    ),
                  ],
                )
                ),
                SingleChildScrollView(
                child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        showDialogAdd(context,publisher: true);
                      },
                      icon: Icon(
                        Icons.add_box_outlined,
                        size: 30.0,
                      ),
                      label: Text('Create',),
                    ).paddingLeft(10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 260,
                      child: listPublisher.isNotEmpty
                          ? ListView.separated(
                              itemBuilder: (context, index) {
                                return PublisherComponent(
                                  publisher: listPublisher[index],
                                  onUpdate: () {
                                    setState(() {
                                      getAllPublisherList();
                                    });
                                  },
                                  onDelete: (id, status) {
                                    setState(() {
                                      listPublisher.forEach((element) {
                                        if(element.id == id) {
                                          element.isActive = status;
                                        }
                                      });
                                    });
                                  },
                                );
                              },
                              separatorBuilder: (context, i) => Divider(
                                    height: 0,
                                    thickness: 2,
                                  ),
                              itemCount: listPublisher.length)
                          : Text('Publisher is empty',
                                  style: boldTextStyle(size: 18)).visible(appStore.isLoading)
                              .center(heightFactor: 20),
                    ),
                  ],
                )
                ),
                SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        showDialogAdd(context,department: true);
                      },
                      icon: Icon(
                        Icons.add_box_outlined,
                        size: 30.0,
                      ),
                      label: Text('Create',),
                    ).paddingLeft(10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 260,
                      child: listDepartment.isNotEmpty
                          ? ListView.separated(
                              itemBuilder: (context, index) {
                                return DepartmentComponent(
                                  department: listDepartment[index],
                                  onUpdate: () {
                                    setState(() {
                                      getAllDepartmentList();
                                    });
                                  },
                                  onDelete: (id) {
                                    setState(() {
                                      listDepartment.removeWhere((element) => element.id == id
                                      );
                                    });
                                  },
                                );
                              },
                              separatorBuilder: (context, i) => Divider(
                                    height: 0,
                                    thickness: 2,
                                  ),
                              itemCount: listDepartment.length)
                          : Text('Department is empty',
                                  style: boldTextStyle(size: 18)).visible(appStore.isLoading)
                              .center(heightFactor: 20),
                    ),
                  ],
                )
                ),
              ],
            ),
          ),
          Observer(
              builder: (_) => Loader().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
