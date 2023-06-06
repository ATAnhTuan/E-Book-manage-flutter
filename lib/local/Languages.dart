import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage)!;

  String get appName;

  String get aboutUs;

  String get successfullyAddedAttribute;

  String get updateSuccessfully;

  String get updateAttribute;

  String get addAttribute;

  String get productAttribute;

  String get slug;

  String get enableArchives;

  String get update;

  String get add;

  String get addSuccessfully;

  String get addCustomer;

  String get updateCustomer;

  String get enterFirstName;

  String get enterLastName;

  String get enterYourEmail;

  String get invalidEmailAddress;

  String get enterUserName;

  String get enterPassword;

  String get maximumSixLength;

  String get lblAdd;

  String get noDataFound;

  String get editProduct;

  String get productAddSuccessfully;

  String get productUpdatedSuccessfully;

  String get productName;

  String get regularPrice;

  String get salePrice;

  String get description;


  String get shortDescription;

  String get downlodable;

  String get fileName;

  String get fileUrl;

  String get chooseFile;

  String get addFile;

  String get bookStatus;

  String get selectStatus;

  String get draft;

  String get pending;

  String get publish;

  String get selectCategory;

  String get selectedCategory;

  String get chooseImage;

  String get attribute;

  String get selectAttribute;

  String get youHaveAlreadySelectAnAttribute;

  String get values;

  String get visibleOnTheProductPage;

  String get removeAttribute;

  String get allCustomer;

  String get successfullyDeleted;

  String get noCustomerAvailable;

  String get category;

  String get noAttributeAvailable;

  String get onlyAdminCanPerformThisAction;

  String get order;

  String get home;

  String get books;

  String get profile;

  String get hello;

  String get totalSale;

  String get topSellerReport;

  String get newOrder;

  String get newComment;

  String get languagesAppSupport;

  String get languages;

  String get media;

  String get bookInformation;

  String get authorBy;

  String get changeStatus;

  String get successfullyUpdateStatus;

  String get orders;

  String get noDataAvailable;

  String get successfullyRemovedProduct;

  String get delete;

  String get cancel;

  String get productReview;

  String get noReviewAvailable;

  String get attributeTerms;

  String get attributeTermsAvailable;

  String get login;

  String get reviews;

  String get theme;

  String get language;

  String get logout;

  String get areYouSureWantToLogout;

  String get yes;

  String get welcomeBack;

  String get userName;

  String get password;

  String get rememberMe;

  String get forgotPassword;

  String get signIn;

  String get filedRequired;

  String get noSubCategoriesAvailable;

  String get selectValue;

  String get edit;

  String get successfullyUpdated;

  String get successFullyAddedYourCategory;

  String get updateCategory;

  String get addCategory;

  String get categoryName;

  String get selectParentCategory;

  String get image;

  String get upsellProduct;

  String get free;

  String get retry;

  String get noInternet;

  String get somethingWentWrongWithProxy;

  String get averageSale;

  String get totalOrders;

  String get totalItems;

  String get orderTotal;

  String get processing;

  String get onHold;

  String get completed;

  String get cancelled;

  String get refunded;

  String get failed;

  String get areYouSureWantDeleteCategory;

  String get areYouSureWantDeleteCustomer;

  String get enterYourEmailId;

  String get emailRequired;

  String get submit;

  String get paymentVia;

  String get deleted;

  String get areYouSureWantDeleteProductAttribute;

  String get status;

  String get inStock;

  String get outOfStock;

  String get readLess;

  String get readMore;

  String get files;

  String get areYouSureWantDeleteProductTerms;

  String get productTotal;

  String get areYouSureDeleteReview;

  String get saleReport;

  String get customerTotal;

  String get variation;

  String get salesPrice;

  String get removeVariation;

  String get productNameIsRequired;

  String get pleaseEnterValueLessThanRegularPrice;

  String get upsell;

  String get upsells;

  String get result;

  String get addBook;

  String get addProducts;

  String get pleaseAddTheData;

  String get noIntenernetConnection;

  String get lblEmail;

  String get save;
}
