import 'dart:convert';

import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/AttributeModel.dart';
import 'package:bookkart_author/models/CategoryResponse.dart';
import 'package:bookkart_author/models/CustomerResponse.dart';
import 'package:bookkart_author/models/DashboardResponse.dart';
import 'package:bookkart_author/models/DashboardResponseData.dart';
import 'package:bookkart_author/models/DeleteCustomerResponse.dart';
import 'package:bookkart_author/models/DeleteReviewResponse.dart';
import 'package:bookkart_author/models/LoginResponse.dart';
import 'package:bookkart_author/models/OrderNotesResponse.dart';
import 'package:bookkart_author/models/OrderResponse.dart';
import 'package:bookkart_author/models/ProductDetailResponse.dart';
import 'package:bookkart_author/models/ReviewResponse.dart';
import 'package:bookkart_author/models/UpdateReviewResponse.dart';
import 'package:bookkart_author/models/VendorModel.dart';
import 'package:bookkart_author/network/VietJetNetworkUtils.dart';
import 'package:bookkart_author/network/vendor_api.dart';
import 'package:bookkart_author/screens/SignInScreen.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'NetworkUtils.dart';

Future<LoginResponseData> login(request) async {
  return await handleResponse(await VietJetAPICall().postMethodNew('api/login', request)).then((res) async {
    LoginResponseData loginResponse = LoginResponseData.fromJson(res);
    String role = '';
    loginResponse.data!.roles!.forEach((element) {
      role = element.validate();
    });
    if (role == 'Admin') {
      // toast('Admin');
      currentUrl = adminUrl;
      await setValue(USER_ID, loginResponse.data!.userID);
      await setValue(FIRST_NAME, " Admin");
      await setValue(LAST_NAME, " Library");
      await setValue(USER_EMAIL, loginResponse.data!.username);
      await setValue(USERNAME, loginResponse.data!.username);
      await setValue(TOKEN, loginResponse.data!.volToken);
      await setValue(AVATAR, "https://secure.gravatar.com/avatar/4e838b59bfff152199fcc9bc3b4aa02e?s=96&d=mm&r=g");
      await setValue(USER_ROLE, role);
      // if (loginResponse.profileImage != null) {
      //   await setValue(PROFILE_IMAGE, loginResponse.profileImage);
      // }
      // await setValue(USER_DISPLAY_NAME, loginResponse.profileImage);
      if(loginResponse.data!.permissions!.isNotEmpty){
        await setValue(IS_LOGGED_IN, true);
        appStore.setLoggedIn(true);
        }

    }  else {
      
      toast('This app for only the admin');
    }
    
    return loginResponse;
  });
}


Future getVietJetAllBooks() async {
  return await handleResponse(await VietJetAPICall().getMethodNew("api/books?Include=authors"));
}

Future getVietJetAllRequestsPending() async {
  return await handleResponse(await VietJetAPICall().getMethodNew("api/borrow-requests?Status=Pending&Include=requester%2Cbook", requireToken: true));
}

Future getVietJetAllRequestsExtention() async {
  return await handleResponse(await VietJetAPICall().getMethodNew("api/extensions?Status=Pending&Include=Bookborrow.Book", requireToken: true));
}


Future getVietJetAllGenres() async {
  return await handleResponse(await VietJetAPICall().getMethodNew("api/genres/all"));
}

Future updateBook(id, request) async {
  return handleResponse(await VietJetAPICall().putMethodNew('api/books/$id', request, requireToken: true));
}

Future createBook(request) async {
  return handleResponse(await VietJetAPICall().postMethodNew('api/books', request, requireToken: true));
}

Future updateFile(id, request) async {
  return handleResponse(await VietJetAPICall().postMethodNew('api/books/$id/file', request, requireToken: true));
}
Future addVietJetPublisher(request) async {
  return handleResponse(await VietJetAPICall().postMethodNew('api/publishers', request, requireToken: true));
}

Future addVietJetAuthor(request) async {
  return handleResponse(await VietJetAPICall().postMethodNew('api/authors', request, requireToken: true));
}

Future updateVietJetAuthor(id,request) async {
  return handleResponse(await VietJetAPICall().putMethodNew('api/authors/$id', request, requireToken: true));
}

Future updateVietJetGenre(id,request) async {
  return handleResponse(await VietJetAPICall().putMethodNew('api/genres/$id', request, requireToken: true));
}

Future updateVietJetPublisher(id,request) async {
  return handleResponse(await VietJetAPICall().putMethodNew('api/publishers/$id', request, requireToken: true));
}

Future updateVietJetDepartment(id,request) async {
  return handleResponse(await VietJetAPICall().putMethodNew('api/departments/$id', request, requireToken: true));
}

Future updateVietJetAuthorStatus(id,request) async {
  return handleResponse(await VietJetAPICall().putMethodNew('api/authors/$id/status?isActive=${request["isActive"]}', request, requireToken: true));
}

Future updateVietJetPublisherStatus(id,request) async {
  return handleResponse(await VietJetAPICall().putMethodNew('api/publishers/$id/status?isActive=${request["isActive"]}', request, requireToken: true));
}

Future addVietJetGenre(request) async {
  return handleResponse(await VietJetAPICall().postMethodNew('api/genres', request, requireToken: true));
}
Future addVietJetDepartment(request) async {
  return handleResponse(await VietJetAPICall().postMethodNew('api/departments', request, requireToken: true));
}

Future getAuthorListRestApi() async {
  return await handleResponse(await VietJetAPICall().getMethodNew("api/authors/all"));
}

Future getPublisherListRestApi() async {
  return await handleResponse(await VietJetAPICall().getMethodNew("api/publishers/all"));
}

Future getDepartmentListRestApi() async {
  return await handleResponse(await VietJetAPICall().getMethodNew("api/departments/all"));
}

Future getCatListRestApi() async {
  return handleResponse(await VietJetAPICall().getMethodNew("api/genres/all"));
}
Future deleteBook(id) async {
  return handleResponse(await VietJetAPICall().deleteMethod('api/books/$id', requireToken: true));
}


Future deleteGenre(id) async {
  return handleResponse(await VietJetAPICall().deleteMethod('api/genres/$id', requireToken: true));
}

Future approvalRequestStatus(id,request) async {
  return handleResponse(await VietJetAPICall().postMethodNew('api/borrow-requests/$id/approval',request, requireToken: true));
}

Future rejectionRequestStatus(id,request) async {
  return handleResponse(await VietJetAPICall().postMethodNew('api/borrow-requests/$id/rejection',request, requireToken: true));
}

Future approvalStatusExtensionRequest(id,request) async {
  return handleResponse(await VietJetAPICall().postMethodNew('api/extensions/$id/approval',request, requireToken: true));
}
Future rejectionStatusExtensionRequest(id,request) async {
  return handleResponse(await VietJetAPICall().postMethodNew('api/extensions/$id/rejection',request, requireToken: true));
}

Future getBookDetail(int? productId) async {
  return handleResponse(await VietJetAPICall().getMethodNew("api/books/${productId}" ,requireToken : true));
}

Future<VendorModel> getVendorDashboard() async {
  log("NewToken:${getStringAsync(TOKEN)}");
  log("UserId:${getIntAsync(USER_ID)}");
  return VendorModel.fromJson(await handleResponse(await VendorAPI().getAsync('iqonic-api/api/v1/woocommerce/get-vendor-dashboard?$ConsumerSecret&ck=$ConsumerKey', requireToken: true)));
}

// Future<List<OrderResponse>> getOrders(int page) async {
//   Iterable it = await (handleResponse(await VendorAPI().getAsync('$currentUrl/orders?page=$page&per_page=$perPage', requireToken: true)));
//   return it.map((e) => OrderResponse.fromJson(e)).toList();
// }

Future updateOrder(id, request) async {
  return handleResponse(await VendorAPI().putAsync('$currentUrl/orders/$id', data: request, requireToken: true));
}

Future<List<CategoryResponse>> getAllCategory({int? page}) async {
  Iterable mCategory = await (handleResponse(await VendorAPI().getAsync('$adminUrl/products/categories?page=$page&per_page=$perPage', requireToken: true)));
  return mCategory.map((model) => CategoryResponse.fromJson(model)).toList();
}

Future<List<CategoryResponse>> getAllCategory1() async {
  Iterable mCategory = await (handleResponse(await VendorAPI().getAsync('$adminUrl/products/categories', requireToken: true)));
  return mCategory.map((model) => CategoryResponse.fromJson(model)).toList();
}

Future<List<CategoryResponse>> getSubCategories(parent) async {
  Iterable mCategory = await (handleResponse(await VendorAPI().getAsync('$currentUrl/products/categories?parent=$parent&per_page=$perPage', requireToken: true)));
  return mCategory.map((model) => CategoryResponse.fromJson(model)).toList();
}

Future<CategoryResponse> addCategory(request) async {
  var d = await handleResponse(await VendorAPI().postAsync('$currentUrl/products/categories', request, requireToken: true));
  return CategoryResponse.fromJson(d);
}

Future<void> updateCategory(pId, request) async {
  return handleResponse(await VendorAPI().putAsync('$currentUrl/products/categories/$pId', data: request, requireToken: true));
}

Future<CategoryResponse> deleteCategory({int? categoryId}) async {
  var c = await handleResponse(await VendorAPI().deleteAsync('$currentUrl/products/categories/$categoryId?force=true', requireToken: true));
  String temp1 = jsonEncode(c);
  return CategoryResponse.fromJson(jsonDecode(temp1));
}

Future<List<ReviewResponse>> getAllReview({int? page}) async {
  Iterable review = await (handleResponse(await VendorAPI().getAsync('$currentUrl/products/reviews?page=$page&per_page=$perPage', requireToken: true)));
  return review.map((model) => ReviewResponse.fromJson(model)).toList();
}

Future<UpdateReviewResponse> updateReview({Map? request, int? reviewId}) async {
  var s = await handleResponse(await VendorAPI().putAsync('$currentUrl/products/reviews/$reviewId', data: request, requireToken: true));
  String temp = jsonEncode(s);
  return UpdateReviewResponse.fromJson(jsonDecode(temp));
}

Future<DeleteReviewResponse> deleteReview({int? reviewId}) async {
  var s = await handleResponse(await VendorAPI().deleteAsync('$currentUrl/products/reviews/$reviewId', requireToken: true));
  String temp = jsonEncode(s);
  return DeleteReviewResponse.fromJson(jsonDecode(temp));
}

Future<List<AttributeModel>> getAllProductAttributes({int? page}) async {
  Iterable attributes = await (handleResponse(await VendorAPI().getAsync('$currentUrl/products/attributes?page=$page&per_page=$perPage', requireToken: true)));
  return attributes.map((model) => AttributeModel.fromJson(model)).toList();
}

Future<List<AttributeModel>> getAllAttributesTerms({int? id, int? page}) async {
  Iterable attributes = await (handleResponse(await VendorAPI().getAsync('$currentUrl/products/attributes/$id/terms?page=$page&per_page=$perPage', requireToken: true)));
  return attributes.map((model) => AttributeModel.fromJson(model)).toList();
}

Future<AttributeModel> addAttribute({Map? req, int? attributeId}) async {
  var s = await handleResponse(await VendorAPI().postAsync('$currentUrl/products/attributes', req, requireToken: true));
  return AttributeModel.fromJson(s);
}

Future<AttributeModel> addTerm({Map? req, int? attributeId}) async {
  var s = await handleResponse(await VendorAPI().postAsync('$currentUrl/products/attributes/$attributeId/terms', req, requireToken: true));
  return AttributeModel.fromJson(s);
}

Future<AttributeModel> editAttribute({Map? request, int? attributeId, int? attributeTermId}) async {
  var s = await handleResponse(await VendorAPI().putAsync('$currentUrl/products/attributes/$attributeId', data: request, requireToken: true));
  return AttributeModel.fromJson(s);
}

Future<AttributeModel> editTerms({Map? request, int? attributeId, int? attributeTermId}) async {
  var s = await handleResponse(await VendorAPI().putAsync('$currentUrl/products/attributes/$attributeId/terms/$attributeTermId', data: request, requireToken: true));
  return AttributeModel.fromJson(s);
}

Future<AttributeModel> deleteAttributesTerm({int? attributeId, int? attributeTermId, bool isAttribute = false}) async {
  var s = await handleResponse(await VendorAPI()
      .deleteAsync(isAttribute ? '$currentUrl/products/attributes/$attributeId?force=true' : '$currentUrl/products/attributes/$attributeId/terms/$attributeTermId?force=true', requireToken: true));
  return AttributeModel.fromJson(s);
}

Future<List<CustomerResponse>> getAllCustomer({int? page}) async {
  Iterable e = await (handleResponse(await VendorAPI().getAsync('$currentUrl/customers?page=$page&per_page=$perPage', requireToken: true)));
  return e.map((model) => CustomerResponse.fromJson(model)).toList();
}

Future<CustomerResponse> addCustomer(Map req) async {
  var s = await handleResponse(await VendorAPI().postAsync('$currentUrl/customers', req, requireToken: true));
  return CustomerResponse.fromJson(s);
}

Future<CustomerResponse> editCustomer({int? customerId, Map? request}) async {
  var s = await handleResponse(await VendorAPI().putAsync('$currentUrl/customers/$customerId', data: request, requireToken: true));
  String temp = jsonEncode(s);
  return CustomerResponse.fromJson(jsonDecode(temp));
}

Future<DeleteCustomerResponse> deleteCustomer({int? customerId}) async {
  var s = await handleResponse(await VendorAPI().deleteAsync('$currentUrl/customers/$customerId?force=true', requireToken: true));
  String temp = jsonEncode(s);
  return DeleteCustomerResponse.fromJson(jsonDecode(temp));
}

// Future<List<ProductDetailResponse1>> getAllProducts(int? page) async {
//   Iterable it = await (handleResponse(await VendorAPI().getAsync('$currentUrl/products/?page=$page&per_page=$perPage', requireToken: true)));
//   return it.map((e) => ProductDetailResponse1.fromJson(e)).toList();
// }


Future<List<Images1>> getMediaImage(int page) async {
  Iterable it = await (handleResponse(await VendorAPI().getAsync('wp/v2/media/?page=$page&per_page=$ImgPerPage', requireToken: true)));
  return it.map((e) => Images1.fromJson(e)).toList();
}

Future createProduct(request) async {
  return handleResponse(await VendorAPI().postAsync('$currentUrl/products', request, requireToken: true));
}

Future updateProduct(pId, request) async {
  return handleResponse(await VendorAPI().postAsync('$currentUrl/products/$pId', request, requireToken: true));
}

Future deleteProduct(pId) async {
  return handleResponse(await VendorAPI().deleteAsync('$currentUrl/products/$pId', requireToken: true));
}

Future createVariation(pid, request) async {
  return handleResponse(await VendorAPI().postAsync('$currentUrl/products/$pid/variations/batch', request));
}

Future getAllAttribute() async {
  return handleResponse(await VendorAPI().getAsync('$currentUrl/products/attributes', requireToken: true));
}

Future getAllAttributeTerms(id) async {
  return handleResponse(await VendorAPI().getAsync('$currentUrl/products/attributes/$id/terms', requireToken: true));
}

Future getProductDetail(int? productId) async {
  return handleResponse(await VendorAPI().getAsync('$currentUrl/products/$productId', requireToken: true));
}

Future<List<OrderNotesResponse>> getOrderNotes(int? orderId) async {
  Iterable it = await (handleResponse(await VendorAPI().getAsync('$currentUrl/orders/$orderId/notes/', requireToken: true)));
  return it.map((e) => OrderNotesResponse.fromJson(e)).toList();
}

Future<void> logout(BuildContext context) async {
  await removeKey(TOKEN);
  await removeKey(USER_ID);
  await removeKey(FIRST_NAME);
  await removeKey(LAST_NAME);
  await removeKey(USERNAME);
  await removeKey(USER_DISPLAY_NAME);
  await removeKey(PROFILE_IMAGE);
  await removeKey(IS_LOGGED_IN);

  appStore.setLoggedIn(false);

  5.milliseconds;
  SignInScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
}

// Dashboard API
Future getOrderSummary() async {
  return handleResponse(await VendorAPI().getAsync('$vendorUrl/orders/summary', requireToken: true));
}

Future getProductSummary() async {
  return handleResponse(await VendorAPI().getAsync('$vendorUrl/products/summary', requireToken: true));
}

Future getAllVendorOrder() async {
  return handleResponse(await VendorAPI().getAsync('$vendorUrl/orders', requireToken: true));
}

Future forgetPassword(request) async {
  return handleResponse(await VendorAPI().postAsync('iqonic-api/api/v1/customer/forget-password', request, requireToken: false));
}
