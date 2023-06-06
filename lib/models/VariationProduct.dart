class VariationProduct {
  double? price;
  double? salesPrice;
  String? status;
  int? selectedId;
  List<String>? stockStatus;
  List<String>? attribute;
  String? selectedStockStatus;
  String? selectedAttribute;

  VariationProduct({
    this.price,
    this.salesPrice,
    this.status,
    this.attribute,
    this.selectedId,
    this.stockStatus,
    this.selectedStockStatus,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['price'] = this.price;
    data['salesPrice'] = this.salesPrice;
    data['status'] = this.status;
    data['slectedid'] = this.selectedId;
    data['selectedAttribute'] = this.selectedAttribute;
    return data;
  }
}
