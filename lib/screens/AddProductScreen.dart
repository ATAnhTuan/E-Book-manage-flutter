import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/AddFileModel.dart';
import 'package:bookkart_author/models/AttributeCustomModel.dart';
import 'package:bookkart_author/models/AttributeResponseModel.dart';
import 'package:bookkart_author/models/AttributeTermsResponse.dart';
import 'package:bookkart_author/models/CategoryResponse.dart';
import 'package:bookkart_author/models/DashboardResponseData.dart';
import 'package:bookkart_author/models/MediaModel.dart';
import 'package:bookkart_author/models/ProductDetailResponse.dart';
import 'package:bookkart_author/models/ProductResponse.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/screens/MediaImageList.dart';
import 'package:bookkart_author/utils/AppColors.dart' as color;
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppCommon.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';

import 'AddTermsScreen.dart';
import 'TermScreen.dart';
import 'UpSellsScreen.dart';

// ignore: must_be_immutable
class AddProductScreen extends StatefulWidget {
  static String tag = '/AddProductScreen';
  String title;
  final ProductDetailResponse1? singleProductResponse;
  final DashboardBookInfo? mBook;
  bool?isUpdate = false;

  AddProductScreen({this.title = 'Add Book', this.singleProductResponse,this.mBook,this.isUpdate});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  int index1 = 0;

  bool virtualIsCheck = false;
  bool downloadableIsCheck = false;

  var formKey = GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();

  AttributeResponseModel? attributeResponse;
  CategoryResponse? pCategoryCont;
  Departments? pDepartmentCont;
  List<Departments> listDepartment = [];
  List<Publisher> listPublisher = [];
  DateTime? selectedToDate = DateTime.now();
  DateTime? selectedFromDate = DateTime.now();
  List<Genres> listGenres = [];
  Genres? pGenresCont;
  List<Authors> listAuthor = [];
  Authors? pAuthorCont;
  Publisher? pPublisherCont;
  List<CategoryResponse> categoryData = [];
  List<CategoryResponse> mCategoryModel = [];
  List<PAttributes> selectedAttributes = [];
  List<Categories> category = [];
  List<int> authors = [];
  List<int> genres = [];
  List upSellsId = [];
  List groupProductId = [];
  List<Departments> selectedDepartment = [];
  List<Genres> selectedCategories = [];
  List<Authors> selectedAuthors = [];
  List<ProductDetailResponse1> upSells = [];
  List<ProductDetailResponse1> grpProduct = [];
  List<AttributeResponseModel> mAttributeName = [];
  List<Images1> images = [];
  List<Map<String, dynamic>> selectImg = [];

  String mErrorMsg = '';
  String? pStatusCont;
  String? pLanguageCont;


  bool mAttributeExist = false;
  bool switchValue = true;

  List<Downloads> downloadData = [];
  List<AttributeTermsResponse> mAttributeTermsModel = [];
  List<AttributeResponseModel> mAttributeModel = [];
  List<AttributeSection> attributes = [];
  List<String> colorArray = ['#000000', '#f0f2f5'];

  int page = 1;
  AddFileModel? addFileModel;
  String fileName = "";
  File? file;
  TextEditingController pNameCont = TextEditingController();
  TextEditingController pRPriceCont = TextEditingController();
  TextEditingController pSPriceCont = TextEditingController();
  TextEditingController pDescCont = TextEditingController();
  TextEditingController pShortDescCont = TextEditingController();
  TextEditingController p = TextEditingController();
  TextEditingController pPassword = TextEditingController();
  TextEditingController pCopy = TextEditingController();
  TextEditingController filenameCont = TextEditingController();
  TextEditingController fileUrlCont = TextEditingController();
  TextEditingController attributeNameCont = TextEditingController();
  TextEditingController attributeUrlCont = TextEditingController();

  FocusNode filenameFocus = FocusNode();
  FocusNode fileUrlFocus = FocusNode();
  FocusNode pNameFocus = FocusNode();
  FocusNode pCopyFocus = FocusNode();
  FocusNode pPasswordFocus = FocusNode();
  FocusNode pRPriceFocus = FocusNode();
  FocusNode pSPriceFocus = FocusNode();
  FocusNode pSFromTimeFocus = FocusNode();
  FocusNode pSToTimeFocus = FocusNode();
  FocusNode pDescFocus = FocusNode();
  FocusNode pShortDescFocus = FocusNode();
  FocusNode pStatusFocus = FocusNode();
  FocusNode pTypeFocus = FocusNode();
  FocusNode pExternalUrlFocus = FocusNode();
  FocusNode pButtonTextFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
    if(widget.isUpdate!) {
      widget.title = "Update Book";
    }
  }

  void init() async {
    if (widget.isUpdate!) {
      getAllAuthorList();
      getAllGenresList();
      getAllPublisherList();
      getAllDepartmentList();
      editProductData();
      // fetchAllAttributes();
    } else {
      getAllAuthorList();
      getAllDepartmentList();
      getAllGenresList();
      getAllPublisherList();
      // getAllCategoryList();
      // fetchAllAttributes();
    }
  }



  ///fetch all attributes api call
  Future fetchAllAttributes() async {
    await getAllAttribute().then((res) {
      if (!mounted) return;

      Iterable mAttribute = res;
      mAttributeModel = mAttribute.map((model) => AttributeResponseModel.fromJson(model)).toList();

      if (mAttributeModel.isEmpty) {
        mErrorMsg = (language!.noDataFound);
      } else {
        mErrorMsg = '';
      }

      setState(() {});
    }).catchError((error) {
      if (!mounted) return;

      mErrorMsg = error.toString();
      setState(() {});
    });
  }

  ///edit product data api call
  void editProductData() {
    if (widget.mBook != null) {
      widget.isUpdate = true;
      pNameCont.text = widget.mBook!.title!;
      pDescCont.text = parseHtmlString(widget.mBook!.description!);
      pShortDescCont.text = parseHtmlString(widget.mBook!.description!);
      // downloadableIsCheck = widget.singleProductResponse!.downloadable.validate();
      pCopy.text = widget.mBook!.physicalCopiesCountNotifyThreshold!.toString();
      pSPriceCont.text = widget.mBook!.publishYear!.toString();
      if(widget.mBook!.isPublic!) {
        pStatusCont = "Public";
      }
      else  pStatusCont = "Restricted";


      if(widget.mBook!.language == "vi") {
        pLanguageCont = "Vietnamese";
      }
      else  pLanguageCont = "English";
      
      widget.mBook!.genres!.forEach((element) {
        selectedCategories.add(element);
      });
      
      widget.mBook!.authors!.forEach((element) {
        selectedAuthors.add(element);
      });
      widget.mBook!.departments!.forEach((element) {
        selectedDepartment.add(element);
      });
      // if (widget.singleProductResponse!.attributes!.isNotEmpty) {
      //   attributeNameCont.text = widget.singleProductResponse!.attributes![0].name.toString().validate();
      //   attributeUrlCont.text = widget.singleProductResponse!.attributes![0].options![0].toString().validate();
      // }

      // downloadStore.uploadPdfFileList.clear();
      // widget.singleProductResponse!.downloads!.forEachIndexed(
      //   (element, index) {
      //     AddFileModel mData = AddFileModel();
      //     mData.id = element.id.toString();
      //     mData.fileNameCont = TextEditingController(text: element.name);
      //     mData.fileUrlCont = TextEditingController(text: element.file);

      //     downloadStore.addToUploadPdfFileList(mData);
      //     downloadData.add(Downloads(id: element.id.toString(), name: element.name, file: element.file));
      //     print(downloadData);
      //     downloadData.forEach((element) {
      //       element.id.toString();
      //     });
      //   },
      // );

      // widget.singleProductResponse!.images!.forEach((element) {
      //   var selectedImage = Images1();
      //   selectedImage.name = element.name;
      //   selectedImage.alt = element.alt;
      //   selectedImage.src = element.src;
      //   selectedImage.position = element.position;
      //   return images.add(selectedImage);
      // });

      // images.forEach((element) {
      //   selectImg.add({'id': element.id});
      // });

      // widget.singleProductResponse!.categories!.forEach((element) {
      //   selectedCategories.add(element.name);
      // });

      //upSells = widget.singleProductResponse.upsellId.cast<ProductDetailResponse1>();
      // widget.singleProductResponse!.attributes!.forEach((element) {
      //   List<AttributeTermsResponse> mAttributeTerms = [];
      //   element.options!.forEach((e) {
      //     mAttributeTerms.add(AttributeTermsResponse(name: e));
      //   });
      //   return attributes.add(AttributeSection(id: element.id, name: element.name, option: mAttributeTerms, variation: element.variation, visible: element.visible));
      // });
    }
  }



  

  Future<void> getAllPublisherList() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
    });
    await getPublisherListRestApi().then((res) async {
      PublisherResponseData response = PublisherResponseData.fromJson(res);
       listPublisher =  response.data!;
      setState(() {});
    }).catchError((e) {
      log(e.toString());
    });

    appStore.setLoading(false);
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
                          addVietJetPublisher(request).then((value) {
                            getAllPublisherList();
                            toast(language!.addSuccessfully);
                          });
                        } else if(author) {
                            var request = {'fullname' : name.text,'bio' : description.text};
                          addVietJetAuthor(request).then((value) {
                            getAllAuthorList();
                            toast(language!.addSuccessfully);
                          });
                        } else if (genres){
                          var request = {'name' : name.text};
                          addVietJetGenre(request).then((value) {
                            getAllGenresList();
                            toast(language!.addSuccessfully);
                          });
                        } else {
                          var request = {'code' : code.text,'name' : name.text, 'description' : description.text};
                          addVietJetDepartment(request).then((value) {
                            getAllDepartmentList();
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

  Future<void> getAllDepartmentList() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
    });
    await getDepartmentListRestApi().then((res) async {
      DepartmentResponseData response = DepartmentResponseData.fromJson(res);
       listDepartment =  response.data!;
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
       listGenres =  response.genresdetail!;
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
       listAuthor =  response.data!;
      setState(() {});
    }).catchError((e) {
      log(e.toString());
    });

    appStore.setLoading(false);
  }

  void addNewProduct() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      createProductApi();
    }
    setState(() {});
  }

  ///fetch all attribute terms api call
  Future fetchAllAttributesTerms(id) async {
    await getAllAttributeTerms(id).then((res) {
      if (!mounted) return;

      setState(() {
        Iterable mAttributeTerms = res;
        mAttributeTermsModel = mAttributeTerms.map((model) => AttributeTermsResponse.fromJson(model)).toList();
        if (mAttributeModel.isEmpty) {
          mErrorMsg = (language!.noDataFound);
        } else {
          mErrorMsg = '';
        }
      });
    }).catchError((error) {
      if (!mounted) return;
      setState(() {
        mErrorMsg = error.toString();
      });
    });
  }

  ///create product api call
  Future<void> createProductApi() async {

    hideKeyboard(context);

    List<int> authorIDs =[];
    selectedCategories.forEach((element) {
      authorIDs.add(element.id!);
    });
    List<int> genreIDs =[];
    selectedAuthors.forEach((element) {
      genreIDs.add(element.id!);
    });
    List<int> departmentIDs =[];
    selectedDepartment.forEach((element) {
      genreIDs.add(element.id!);
    });
    
    Map request = {
      'title': pNameCont.text,
      'description': pDescCont.text,
      'publishYear': pSPriceCont.text,
      'language': (pLanguageCont == "English") ? "en" : "vi",
      'isPublic': (pStatusCont == "Public") ? true : false,
      'publisherID': 4,
      'physicalCopiesCountNotifyThreshold': pCopy.text,
      'authorIDs': authorIDs,
      'genreIDs': genreIDs,
      'departmentIDs': departmentIDs,
    };
    await getData();
    appStore.setLoading(true);

    await createBook(request).then((value) {
      toast(language!.productAddSuccessfully);
      finish(context, value);
    }).catchError((onError) {
      log(onError.toString());
      toast(onError.toString());
    });
    appStore.setLoading(false);

  if(fileName.isNotEmpty) {
    var filedata = file;
    await updateFile(widget.mBook!.id, filedata).then((value) {
      log(value);
      appStore.setLoading(false);
      toast(language!.productUpdatedSuccessfully);
      finish(context, true);
      LiveStream().emit(UPDATE_PRODUCT);
    }).catchError((onError) {
      appStore.setLoading(false);
      log(onError.toString());
      toast(onError.toString());
    });
  }



  }

  void updateExistingProduct() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      updateProductApi();
    }

    setState(() {});
  }

  ///update product api call
  Future<void> updateProductApi() async {
    hideKeyboard(context);

    List<int> authorIDs =[];
    selectedCategories.forEach((element) {
      authorIDs.add(element.id!);
    });
    List<int> genreIDs =[];
    selectedAuthors.forEach((element) {
      genreIDs.add(element.id!);
    });
    List<int> departmentIDs =[];
    selectedDepartment.forEach((element) {
      genreIDs.add(element.id!);
    });
    Map request = {
      'title': pNameCont.text,
      'description': pDescCont.text,
      'publishYear': pSPriceCont.text,
      'language': (pLanguageCont == "English") ? "en" : "vi",
      'isPublic': (pStatusCont == "Public") ? true : false,
      'publisherID': 4,
      'physicalCopiesCountNotifyThreshold': pCopy.text,
      'authorIDs': authorIDs,
      'genreIDs': genreIDs,
      'departmentIDs': departmentIDs,
    };
    appStore.setLoading(true);
    
    await updateBook(widget.mBook!.id, request).then((value) {
      log(value);
      appStore.setLoading(false);
      toast(language!.productUpdatedSuccessfully);
      finish(context, true);
      LiveStream().emit(UPDATE_PRODUCT);
    }).catchError((onError) {
      appStore.setLoading(false);
      log(onError.toString());
      toast(onError.toString());
    });


  //   if(fileName.isNotEmpty) {
  //   var filedata = file;
  //   await updateFile(widget.mBook!.id, filedata).then((value) {
  //     log(value);
  //     appStore.setLoading(false);
  //     toast(language!.productUpdatedSuccessfully);
  //     finish(context, true);
  //     LiveStream().emit(UPDATE_PRODUCT);
  //   }).catchError((onError) {
  //     appStore.setLoading(false);
  //     log(onError.toString());
  //     toast(onError.toString());
  //   });
  // }

  }

  Future getData() async {
    getCategory();
    getAttribute();
    getUpSellsId();
  }

  void getAttribute() {
    selectedAttributes.clear();
    attributes.forEach((element) {
      var selectedAttribute = PAttributes();
      List<String?> selectedOption = [];

      selectedAttribute.id = element.id;
      selectedAttribute.name = element.name;
      selectedAttribute.position = 0;
      selectedAttribute.visible = element.visible;
      selectedAttribute.variation = element.variation;
      selectedAttribute.attributeResponse = element.option;
      element.option!.forEach((element) {
        selectedOption.add(element.name);
      });

      selectedAttribute.options = selectedOption;
      selectedAttributes.add(selectedAttribute);
    });
  }


  void getCategory() {
    selectedCategories.clear();
  }

  void getUpSellsId() {
    upSells.forEach((element) {
      upSellsId.add(element.id);
    });
  }

  ///fetch category data api call
  Future fetchCategoryData() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
    });

    await getAllCategory1().then((res) {
      log(res);

      if (!mounted) return;
      Iterable mCategory = res;
      mCategoryModel = mCategory.map((model) => CategoryResponse.fromJson(model)).toList();
      if (mCategoryModel.isEmpty) {
        mErrorMsg = language!.noDataFound;
      } else {
        mErrorMsg = '';
      }

      setState(() {});
    }).catchError((error) {
      if (!mounted) return;
      mErrorMsg = error.toString();
      setState(() {});
    });

    appStore.setLoading(false);
  }

  Future<File> getImageFileFromAsset(String path) async {
    final file = File(path);
    return file;
  }

  ///get all category list api call
  Future<void> getAllCategoryList() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
    });
    await getAllCategory(page: 1).then((res) async {
      if (page == 1) categoryData.clear();

      categoryData.addAll(res);

      setState(() {});
    }).catchError((e) {
      log(e.toString());
    });

    appStore.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    Widget mProductInfo() {
      return Column(
        children: [
          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextFormField(
                    labelText: language!.productName,
                    focusNode: pNameFocus,
                    mController: pNameCont,
                    validator: (String? s) {
                      if (s!.trim().isEmpty) return language!.productNameIsRequired;
                      return null;
                    }),
                // 16.height,
                // CommonTextFormField(
                //   labelText: language!.regularPrice,
                //   textInputType: TextInputType.numberWithOptions(),
                //   focusNode: pRPriceFocus,
                //   mController: pRPriceCont,
                // ),
                // 16.height,
                // CommonTextFormField(
                //   labelText: language!.salePrice,
                //   textInputType: TextInputType.numberWithOptions(),
                //   focusNode: pSPriceFocus,
                //   mController: pSPriceCont,
                //   validator: (String? s) {
                //     if (s!.trim().isNotEmpty && int.parse(pRPriceCont.text.trim()) <= int.parse(s.trim())) return language!.pleaseEnterValueLessThanRegularPrice;
                //     return null;
                //   },
                // ),
                16.height,
                CommonTextFormField(
                  labelText: language!.description,
                  maxLine: 5,
                  minLine: 5,
                  textInputType: TextInputType.multiline,
                  mController: pDescCont,
                ),
                16.height,
                CommonTextFormField(
                  labelText: "Publish Year *",
                  textInputType: TextInputType.numberWithOptions(),
                  focusNode: pSPriceFocus,
                  mController: pSPriceCont,
                  validator: (String? s) {
                    if (s!.trim().isEmpty) return "Publish Year is Required";
                    return null;
                  },
                ),
                16.height,
                  Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: iconColorSecondary)),
                  child: DropdownButtonFormField<Publisher>(
                    dropdownColor: appStore.scaffoldBackground,
                    decoration: InputDecoration.collapsed(hintText: null),
                    hint: Text("Select Publisher", style: primaryTextStyle()),
                    isExpanded: true,
                    value: pPublisherCont,
                    items: listPublisher.map((Publisher e) {
                      return DropdownMenuItem<Publisher>(
                        value: e,
                        child: Text(parseHtmlString(e.name.validate()), style: primaryTextStyle()),
                      );
                    }).toList(),
                    onChanged: (Publisher? value) async {
                      pPublisherCont = value;
                      toast(pPublisherCont!.name!);
                    },
                  ),
                ),
                 16.height,
                 Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: iconColorSecondary)),
                  child: DropdownButtonFormField<String>(
                    dropdownColor: appStore.scaffoldBackground,
                    decoration: InputDecoration.collapsed(hintText: null),
                    hint: Text("Select Language", style: primaryTextStyle()),
                    value: pLanguageCont,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(child: Text("Vietnamese", style: primaryTextStyle()), value: 'Vietnamese'),
                      DropdownMenuItem(child: Text("English", style: primaryTextStyle()), value: 'English'),
                    ],
                    onChanged: (String? value) {
                      pLanguageCont = value;
                        toast(pLanguageCont);
                      setState(() {});
                    },
                  ),
                ),
                // 16.height,
                // CommonTextFormField(
                //   labelText: "Password",
                //   textInputType: TextInputType.numberWithOptions(),
                //   focusNode: pPasswordFocus,
                //   mController: pPassword,
                // ),
                // CommonTextFormField(labelText: language!.shortDescription, maxLine: 5, minLine: 5, textInputType: TextInputType.multiline, focusNode: pShortDescFocus, mController: pShortDescCont),
                16.height,
                CommonTextFormField(
                  labelText: "Copies Threshold:",
                  textInputType: TextInputType.numberWithOptions(),
                  focusNode: pCopyFocus,
                  mController: pCopy,
                ),
                
                16.height,
                CheckboxListTile(
                    contentPadding: EdgeInsets.all(0),
                    value: downloadableIsCheck,
                    dense: true,
                    onChanged: (bool? val) {
                      setState(() {
                        downloadableIsCheck = val!;
                      });
                    },
                    title: Text("Downloadable", style: boldTextStyle()),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: primaryColor),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                              AppButton(
                                    elevation: 0,
                                    color: appStore.isDarkModeOn ? primaryColor : white,
                                    shapeBorder: RoundedRectangleBorder(
                                      borderRadius: radius(16),
                                      side: BorderSide(color: iconColorSecondary),
                                    ),
                                    padding: EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10),
                                    text: language!.chooseFile,
                                    textStyle: primaryTextStyle(size: 14),
                                    onTap: () async {
                                      final result = await FilePicker.platform.pickFiles(allowedExtensions: ['pdf'], type: FileType.custom);
                                      if(result != null) {
                                        setState(() {
                                        File file = File(result.files.single.path ?? " ");
                                        fileName = file.path.split('/').last;
                                        String filePath = file.path;
                                        });
                                      }
                                    },
                              ),
                              Text(fileName).visible(fileName.isNotEmpty),
                  ],
                ).visible(downloadableIsCheck),
                16.height,
                Text("Access Permission *", style: boldTextStyle()),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: iconColorSecondary)),
                  child: DropdownButtonFormField<String>(
                    value: pStatusCont,
                    dropdownColor: appStore.scaffoldBackground,
                    decoration: InputDecoration.collapsed(hintText: null),
                    hint: Text(language!.selectStatus, style: primaryTextStyle()),
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(child: Text("Public", style: primaryTextStyle()), value: 'Public'),
                      DropdownMenuItem(child: Text("Restricted", style: primaryTextStyle()), value: 'Restricted'),
                    ],
                    onChanged: (String? value) {
                      pStatusCont = value;
                      toast(pStatusCont);
                      setState(() {});
                    },
                  ),
                ),
                16.height,
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: iconColorSecondary)),
                  child: DropdownButtonFormField<Authors>(
                    dropdownColor: appStore.scaffoldBackground,
                    decoration: InputDecoration.collapsed(hintText: null),
                    hint: Text("Select Author", style: primaryTextStyle()),
                    isExpanded: true,
                    value: pAuthorCont,
                    items: listAuthor.map((Authors e) {
                      return DropdownMenuItem<Authors>(
                        value: e,
                        child: Text(parseHtmlString(e.fullName!.validate()), style: primaryTextStyle()),
                      );
                    }).toList(),
                    onChanged: (Authors? value) async {
                      pAuthorCont = value;
                      setState(() {
                        selectedAuthors.add(pAuthorCont!);
                      });
                    },
                  ),
                ),
                Container(
                  width: context.width(),
                  decoration: BoxDecoration(
                    border: Border.all(color: iconColorSecondary, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Selected Author", style: boldTextStyle()).paddingOnly(left: 10, top: 8, bottom: 0).center(),
                      Divider(color: Colors.black),
                      Wrap(
                        children: selectedAuthors.map(
                          (e) {
                            return InkWell(
                              child: Container(
                                width: context.width() * 0.4,
                                child: UL(children: [
                                  Text(e.fullName!, style: primaryTextStyle(size: 14))]),
                              ),
                              onTap: () {
                                setState(() {
                                  selectedAuthors.remove(e);
                              });
                              },
                            );
                          },
                        ).toList(),
                      ).paddingLeft(8).paddingBottom(8)
                    ],
                  ),
                ).visible(selectedAuthors.isNotEmpty).paddingTop(8),
                16.height,
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: iconColorSecondary)),
                  child: DropdownButtonFormField<Genres>(
                    dropdownColor: appStore.scaffoldBackground,
                    decoration: InputDecoration.collapsed(hintText: null),
                    hint: Text(language!.selectCategory, style: primaryTextStyle()),
                    isExpanded: true,
                    value: pGenresCont,
                    items: listGenres.map((Genres e) {
                      return DropdownMenuItem<Genres>(
                        value: e,
                        child: Text(parseHtmlString(e.name.validate()), style: primaryTextStyle()),
                      );
                    }).toList(),
                    onChanged: (Genres? value) async {
                      pGenresCont = value;
                      setState(() {
                        selectedCategories.add(pGenresCont!);
                      });
                      // listGenres!.removeWhere((element) => element.name! == pGenresCont!.name!);
                    },
                  ),
                ),
                Container(
                  width: context.width(),
                  decoration: BoxDecoration(
                    border: Border.all(color: iconColorSecondary, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(language!.selectedCategory, style: boldTextStyle()).paddingOnly(left: 10, top: 8, bottom: 0).center(),
                      Divider(color: Colors.black),
                      Wrap(
                        children: selectedCategories.map(
                          (e) {
                            return InkWell(
                              child: Container(
                                width: context.width() * 0.4,
                                child: UL(children: [
                                  Text(e.name!, style: primaryTextStyle(size: 14))]),
                              ),
                              onTap:  () => {
                              setState(() {
                                  selectedCategories.remove(e);
                              })
                              },
                            );
                          },
                        ).toList(),
                      ).paddingLeft(8).paddingBottom(8)
                    ],
                  ),
                ).visible(selectedCategories.isNotEmpty).paddingTop(8),
                16.height,
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: iconColorSecondary)),
                  child: DropdownButtonFormField<Departments>(
                    dropdownColor: appStore.scaffoldBackground,
                    decoration: InputDecoration.collapsed(hintText: null),
                    hint: Text("Select Department", style: primaryTextStyle()),
                    isExpanded: true,
                    value: pDepartmentCont,
                    items: listDepartment.map((Departments e) {
                      return DropdownMenuItem<Departments>(
                        value: e,
                        child: Text(parseHtmlString(e.name!.validate()), style: primaryTextStyle()),
                      );
                    }).toList(),
                    onChanged: (Departments? value) async {
                      pDepartmentCont = value;
                      setState(() {
                        selectedDepartment.add(pDepartmentCont!);
                      });
                    },
                  ),
                ),
                Container(
                  width: context.width(),
                  decoration: BoxDecoration(
                    border: Border.all(color: iconColorSecondary, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Selected Department", style: boldTextStyle()).paddingOnly(left: 10, top: 8, bottom: 0).center(),
                      Divider(color: Colors.black),
                      Wrap(
                        children: selectedDepartment.map(
                          (e) {
                            return InkWell(
                              child: Container(
                                width: context.width() * 0.4,
                                child: UL(
                                  children: [
                                  Text(e.name!, style: primaryTextStyle(size: 14))
                                  ]
                                  )
                              ),
                              onTap: () => {
                                setState(() {
                                  selectedDepartment.remove(e);
                              })
                              },
                            );
                          },
                        ).toList(),
                      ).paddingLeft(8).paddingBottom(8)
                    ],
                  ),
                ).visible(selectedDepartment.isNotEmpty).paddingTop(8),
                // Container(
                //   padding: EdgeInsets.all(10),
                //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: iconColorSecondary)),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(language!.chooseImage, style: primaryTextStyle(letterSpacing: 1)),
                //           Icon(Icons.camera_alt).onTap(() async {
                //             List<Images1>? res = await MediaImageList().launch(context);
                //             if (res != null) {
                //               log(res.length);
                //               images.addAll(res);
                //             }

                //             /// Id Means media Image id..
                //             images.forEach((element) {
                //               selectImg.add({'id': element.id});
                //             });
                //             setState(() {});
                //           })
                //         ],
                //       ),
                      // GridView.count(
                      //   crossAxisCount: 3,
                      //   shrinkWrap: true,
                      //   crossAxisSpacing: 8,
                      //   mainAxisSpacing: 16,
                      //   semanticChildCount: 8,
                      //   padding: EdgeInsets.only(left: 6, right: 6, top: 12, bottom: 8),
                      //   children: List.generate(
                      //     images.length,
                      //     (index) {
                      //       return Stack(
                      //         clipBehavior: Clip.none,
                      //         children: [
                      //           cachedImage(images[index].src.validate(), width: 300, height: 300, fit: BoxFit.cover).cornerRadiusWithClipRRect(5),
                      //           Positioned(
                      //             right: -5,
                      //             top: -8,
                      //             child: Icon(AntDesign.closecircleo, size: 20).onTap(() {
                      //               images.remove(images[index]);
                      //               setState(() {});
                      //             }),
                      //           )
                      //         ],
                      //       );
                      //     },
                      //   ),
                      // ).visible(images.isNotEmpty),
                //     ],
                //   ),
                // ),
                16.height,
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(language!.attribute, style: boldTextStyle()).paddingLeft(4),
                //     5.height,
                //     Container(
                //       padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                //       decoration: BoxDecoration(border: Border.all(color: iconColorSecondary, width: 1), borderRadius: BorderRadius.circular(5)),
                //       child: DropdownButtonFormField<AttributeResponseModel>(
                //         focusNode: pTypeFocus,
                //         dropdownColor: appStore.scaffoldBackground,
                //         value: attributeResponse,
                //         decoration: InputDecoration.collapsed(hintText: null),
                //         hint: Text(language!.selectAttribute, style: primaryTextStyle()),
                //         isExpanded: true,
                //         items: mAttributeModel.map((AttributeResponseModel e) {
                //           return DropdownMenuItem<AttributeResponseModel>(
                //             value: e,
                //             child: Text(e.name.validate(), style: primaryTextStyle()),
                //           );
                //         }).toList(),
                //         onChanged: (AttributeResponseModel? value) async {
                //           attributeResponse = value;
                //           await fetchAllAttributesTerms(value?.id.validate());
                //           if (attributes.isEmpty) {
                //             mAttributeName.add(value!);
                //             attributes.insert(0, AttributeSection(id: value.id, name: value.name, option: mAttributeTermsModel));
                //             value.isSelected = true;
                //           } else {
                //             mAttributeName.forEach((element) {
                //               if (element.isSelected == value!.isSelected) {
                //                 toast(language!.youHaveAlreadySelectAnAttribute);
                //               } else {
                //                 value.isSelected = true;
                //                 mAttributeName.add(value);
                //                 attributes.insert(0, AttributeSection(id: value.id, name: value.name, option: mAttributeTermsModel));
                //               }
                //             });
                //           }
                //           setState(() {});
                //         },
                //       ),
                //     ),
                //     16.height,
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         ListView.separated(
                //           shrinkWrap: true,
                //           separatorBuilder: (context, index) {
                //             return 10.height;
                //           },
                //           physics: BouncingScrollPhysics(),
                //           itemCount: attributes.length,
                //           itemBuilder: (context, index) {
                //             return Container(
                //               padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                //               decoration: BoxDecoration(
                //                 color: getColorFromHex(colorArray[index % colorArray.length]).withOpacity(0.05),
                //                 border: Border.all(color: iconColorSecondary, width: 1),
                //                 borderRadius: BorderRadius.circular(5),
                //               ),
                //               child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 mainAxisAlignment: MainAxisAlignment.start,
                //                 children: [
                //                   Text(attributes[index].name.validate(), style: boldTextStyle(size: 18, color: color.primaryColor)),
                //                   16.height,
                //                   Text('${language!.values} :', style: boldTextStyle(size: 14)).paddingLeft(6),
                //                   4.height,
                //                   Container(
                //                     padding: EdgeInsets.fromLTRB(6, 8, 6, 8),
                //                     width: context.width(),
                //                     decoration: boxDecorationWithRoundedCorners(
                //                       borderRadius: BorderRadius.circular(5),
                //                       border: Border.all(color: iconColorSecondary, width: 1),
                //                       backgroundColor: Colors.transparent,
                //                     ),
                //                     child: Wrap(
                //                       crossAxisAlignment: WrapCrossAlignment.start,
                //                       runSpacing: 10,
                //                       spacing: 10,
                //                       runAlignment: WrapAlignment.start,
                //                       direction: Axis.horizontal,
                //                       children: List.generate(
                //                         attributes[index].option!.isEmpty ? 0 : attributes[index].option!.length,
                //                         (i) => Chip(
                //                           backgroundColor: color.colorAccent.withOpacity(0.09),
                //                           padding: EdgeInsets.all(0),
                //                           onDeleted: () {
                //                             attributes[index].option!.remove(attributes[index].option![i]);
                //                             setState(() {});
                //                           },
                //                           deleteIconColor: Colors.red,
                //                           deleteIcon: Icon(Icons.cancel, color: Colors.black),
                //                           label: Text(attributes[index].option![i].name.validate(), style: primaryTextStyle(color: color.colorAccent)),
                //                         ),
                //                       ),
                //                     ),
                //                   ).onTap(() async {
                //                     if (!isVendor) {
                //                       List<AttributeTermsResponse> result = await TermScreen(attributes[index].id, attributes[index].option!).launch(context);
                //                       attributes[index].option = result;
                //                       setState(() {});
                //                     } else {
                //                       toast(language!.onlyAdminCanPerformThisAction);
                //                     }
                //                   }),
                //                   4.height,
                //                   CheckboxListTile(
                //                     dense: true,
                //                     contentPadding: EdgeInsets.all(0),
                //                     value: attributes[index].visible,
                //                     title: Text(language!.visibleOnTheProductPage, style: primaryTextStyle()),
                //                     onChanged: (v) {
                //                       attributes[index].visible = !attributes[index].visible!;
                //                       setState(() {});
                //                     },
                //                     controlAffinity: ListTileControlAffinity.leading,
                //                   ),
                //                   Container(
                //                     width: context.width(),
                //                     child: Row(
                //                       mainAxisAlignment: MainAxisAlignment.end,
                //                       crossAxisAlignment: CrossAxisAlignment.end,
                //                       children: [
                //                         TextButton(
                //                             onPressed: () {
                //                               showConfirmDialogCustom(context, onAccept: (context) {
                //                                 attributes.remove(attributes[index]);
                //                                 setState(() {});
                //                               });
                //                               setState(() {});
                //                             },
                //                             child: Text(language!.removeAttribute, style: primaryTextStyle(color: Colors.red, size: 14))),
                //                         AppButton(
                //                           elevation: 0,
                //                           color: appStore.isDarkModeOn ? primaryColor : Colors.transparent,
                //                           shapeBorder: RoundedRectangleBorder(
                //                             borderRadius: radius(16),
                //                             side: BorderSide(color: color.iconColorSecondary),
                //                           ),
                //                           padding: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
                //                           text: language!.lblAdd,
                //                           textStyle: primaryTextStyle(size: 14),
                //                           onTap: () {
                //                             AddTermsScreen(
                //                               attributeId: attributes[index].id,
                //                             ).launch(context);
                //                           },
                //                         )
                //                       ],
                //                     ),
                //                   )
                //                 ],
                //               ),
                //             );
                //           },
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
                8.height.visible(widget.isUpdate!),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(language!.upsell, style: boldTextStyle()).paddingLeft(4),
                //     5.height,
                //     Container(
                //       padding: EdgeInsets.all(10),
                //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: iconColorSecondary)),
                //       child: Column(
                //         children: [
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             mainAxisSize: MainAxisSize.max,
                //             children: [
                //               Text(
                //                 language!.upsells,
                //                 style: primaryTextStyle(),
                //               ),
                //               InkWell(
                //                 onTap: () async {
                //                   List<ProductDetailResponse1> result = await UpSellsScreen().launch(context);
                //                   upSells = result;
                //                   setState(() {});
                //                   log("Result ${result.length}");
                //                 },
                //                 child: Text(
                //                   '${language!.addBook} ?',
                //                   style: secondaryTextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                //                 ),
                //               )
                //             ],
                //           ),
                //           Wrap(
                //             crossAxisAlignment: WrapCrossAlignment.start,
                //             runSpacing: 8,
                //             spacing: 8,
                //             runAlignment: WrapAlignment.start,
                //             direction: Axis.horizontal,
                //             children: List.generate(
                //               upSells.length == null ? 0 : upSells.length,
                //               (index) => Chip(
                //                 backgroundColor: color.primaryColor.withOpacity(0.07),
                //                 onDeleted: () {
                //                   upSells[index].isCheck = !upSells[index].isCheck;
                //                   upSells.remove(upSells[index]);
                //                   setState(() {});
                //                 },
                //                 deleteIconColor: Colors.red,
                //                 deleteIcon: Icon(Icons.cancel, color: Colors.blue),
                //                 label: Text(upSells[index].name, maxLines: 1),
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      key: globalKey,
      backgroundColor: appStore.scaffoldBackground,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: appStore.appBarColor,
        title: Text(
          widget.title,
          maxLines: 1,
          style: boldTextStyle(color: appStore.textPrimaryColor, weight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Row(
            children: [
              switchValue
                  ? Text(language!.inStock, style: primaryTextStyle(color: Colors.green))
                  : Text(
                      language!.outOfStock,
                      style: primaryTextStyle(color: Colors.red),
                    ),
              Switch(
                inactiveThumbColor: Colors.red,
                inactiveTrackColor: Colors.redAccent.withOpacity(0.4),
                activeColor: appStore.isDarkModeOn ? color.greenColor : primaryColor,
                value: switchValue,
                onChanged: (_value) {
                  switchValue = _value;
                  setState(() {});
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: mProductInfo(),
              ).expand(),
              Container(
                height: 55,
                color: color.primaryColor,
                child: Text(widget.isUpdate! ? language!.save : language!.save, style: boldTextStyle(size: 20, color: Colors.white)).center(),
              ).onTap(
                () {
                  setState(() {});
                  if (widget.isUpdate == false) {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      showConfirmDialogCustom(context, onAccept: (context) {
                        addNewProduct();
                      }, dialogType: DialogType.ADD);
                    } else {
                      toast(language!.pleaseAddTheData);
                    }
                  } else {
                    showConfirmDialogCustom(
                      context,
                      onAccept: (context) {
                        updateExistingProduct();
                      },
                      dialogType: DialogType.UPDATE,
                      negativeText: language!.cancel,
                      positiveText: language!.update,
                    );
                  }
                },
              ),
            ],
          ),
          Observer(builder: (_) => Loader().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
