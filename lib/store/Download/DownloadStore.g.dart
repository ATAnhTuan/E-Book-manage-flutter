// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DownloadStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DownloadStore on _DownloadStore, Store {
  final _$cartListAtom = Atom(name: '_DownloadStore.cartList');

  @override
  ObservableList<Downloads> get cartList {
    _$cartListAtom.reportRead();
    return super.cartList;
  }

  @override
  set cartList(ObservableList<Downloads> value) {
    _$cartListAtom.reportWrite(value, super.cartList, () {
      super.cartList = value;
    });
  }

  final _$uploadPdfFileListAtom =
      Atom(name: '_DownloadStore.uploadPdfFileList');

  @override
  ObservableList<AddFileModel> get uploadPdfFileList {
    _$uploadPdfFileListAtom.reportRead();
    return super.uploadPdfFileList;
  }

  @override
  set uploadPdfFileList(ObservableList<AddFileModel> value) {
    _$uploadPdfFileListAtom.reportWrite(value, super.uploadPdfFileList, () {
      super.uploadPdfFileList = value;
    });
  }

  final _$cartTotalAmountAtom = Atom(name: '_DownloadStore.cartTotalAmount');

  @override
  double get cartTotalAmount {
    _$cartTotalAmountAtom.reportRead();
    return super.cartTotalAmount;
  }

  @override
  set cartTotalAmount(double value) {
    _$cartTotalAmountAtom.reportWrite(value, super.cartTotalAmount, () {
      super.cartTotalAmount = value;
    });
  }

  final _$cartTotalPayableAmountAtom =
      Atom(name: '_DownloadStore.cartTotalPayableAmount');

  @override
  double get cartTotalPayableAmount {
    _$cartTotalPayableAmountAtom.reportRead();
    return super.cartTotalPayableAmount;
  }

  @override
  set cartTotalPayableAmount(double value) {
    _$cartTotalPayableAmountAtom
        .reportWrite(value, super.cartTotalPayableAmount, () {
      super.cartTotalPayableAmount = value;
    });
  }

  final _$cartSavedAmountAtom = Atom(name: '_DownloadStore.cartSavedAmount');

  @override
  double get cartSavedAmount {
    _$cartSavedAmountAtom.reportRead();
    return super.cartSavedAmount;
  }

  @override
  set cartSavedAmount(double value) {
    _$cartSavedAmountAtom.reportWrite(value, super.cartSavedAmount, () {
      super.cartSavedAmount = value;
    });
  }

  final _$addToCartAsyncAction = AsyncAction('_DownloadStore.addToCart');

  @override
  Future<void> addToCart(Downloads data) {
    return _$addToCartAsyncAction.run(() => super.addToCart(data));
  }

  final _$addToUploadPdfFileListAsyncAction =
      AsyncAction('_DownloadStore.addToUploadPdfFileList');

  @override
  Future<void> addToUploadPdfFileList(AddFileModel data) {
    return _$addToUploadPdfFileListAsyncAction
        .run(() => super.addToUploadPdfFileList(data));
  }

  final _$clearUploadPdfFileListAsyncAction =
      AsyncAction('_DownloadStore.clearUploadPdfFileList');

  @override
  Future<void> clearUploadPdfFileList() {
    return _$clearUploadPdfFileListAsyncAction
        .run(() => super.clearUploadPdfFileList());
  }

  final _$updateCartItemAsyncAction =
      AsyncAction('_DownloadStore.updateCartItem');

  @override
  Future<void> updateCartItem(AddFileModel item) {
    return _$updateCartItemAsyncAction.run(() => super.updateCartItem(item));
  }

  final _$storeCartDataAsyncAction =
      AsyncAction('_DownloadStore.storeCartData');

  @override
  Future<void> storeCartData() {
    return _$storeCartDataAsyncAction.run(() => super.storeCartData());
  }

  final _$clearCartAsyncAction = AsyncAction('_DownloadStore.clearCart');

  @override
  Future<void> clearCart() {
    return _$clearCartAsyncAction.run(() => super.clearCart());
  }

  final _$_DownloadStoreActionController =
      ActionController(name: '_DownloadStore');

  @override
  void addAllCartItem(List<Downloads> productList) {
    final _$actionInfo = _$_DownloadStoreActionController.startAction(
        name: '_DownloadStore.addAllCartItem');
    try {
      return super.addAllCartItem(productList);
    } finally {
      _$_DownloadStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getCartList() {
    final _$actionInfo = _$_DownloadStoreActionController.startAction(
        name: '_DownloadStore.getCartList');
    try {
      return super.getCartList();
    } finally {
      _$_DownloadStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
cartList: ${cartList},
uploadPdfFileList: ${uploadPdfFileList},
cartTotalAmount: ${cartTotalAmount},
cartTotalPayableAmount: ${cartTotalPayableAmount},
cartSavedAmount: ${cartSavedAmount}
    ''';
  }
}
