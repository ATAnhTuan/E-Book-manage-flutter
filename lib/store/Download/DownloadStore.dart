import 'dart:convert';

import 'package:bookkart_author/models/AddFileModel.dart';
import 'package:bookkart_author/models/ProductResponse.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

part 'DownloadStore.g.dart';

class DownloadStore = _DownloadStore with _$DownloadStore;

abstract class _DownloadStore with Store {
  @observable
  ObservableList<Downloads> cartList = ObservableList.of([]);

  @observable
  ObservableList<AddFileModel> uploadPdfFileList = ObservableList.of([]);

  @observable
  double cartTotalAmount = 0.0;

  @observable
  double cartTotalPayableAmount = 0.0;

  @observable
  double cartSavedAmount = 0.0;

  @action
  Future<void> addToCart(Downloads data) async {
    if (cartList.any((element) => element.id == data.id)) {
      cartList.remove(data);

        // await removeToCartApi(proId: data.pro_id!).then((value) {
        //   getCartList();
        // }).catchError((error) {
        //   log(error.toString());
        // });
    } else {
      cartList.clear();
      cartList.add(data);

      //
        // await addToCartApi(proId: data.pro_id!).then((value) {
        //   getCartList();
        // }).catchError((error) {
        //   log(error.toString());
        // });
    }
  }

  @action
  Future<void> addToUploadPdfFileList(AddFileModel data) async {
      uploadPdfFileList.add(data);
  }
  @action
  Future<void> clearUploadPdfFileList() async {
    uploadPdfFileList.clear();
    storeCartData();
  }

  @action
  Future<void> updateCartItem(AddFileModel item) async {
    uploadPdfFileList.removeWhere((element) => element.id == item.id);
    uploadPdfFileList.add(item);
    // if (item.quantity.validate().toInt() > 1) {
    //   int itemIndex = cartList.indexOf(item);
    //   cartList[itemIndex] = item;
    //
    //
    //   if (appStore.isLoading) {
    //     updateCartProduct(proId: item.pro_id.toString(), cartId: item.cart_id.validate().toString(), qty: item.quantity.toString()).then((value) {
    //       //
    //     }).catchError((e) {
    //     });
    //   }
    // }
  }

  @action
  void addAllCartItem(List<Downloads> productList) {
    cartList.addAll(productList);
  }


  @action
  Future<void> storeCartData() async {
    if (cartList.isNotEmpty) {
      await setValue(DOWNLOAD_ITEM_LIST, jsonEncode(cartList));
    } else {
      await setValue(DOWNLOAD_ITEM_LIST, '');
    }
  }

  @action
  void getCartList() {
    // getCartListApi().then((value) {
    //   cartList = ObservableList.of(value.data!);
    // }).catchError((error) {
    //   log(error.toString());
    // });
  }

  @action
  Future<void> clearCart() async {
    cartList.clear();
    storeCartData();
  }
}
