class FinalVariationData {
  String? regularPrice;
  String? salePrice;
  String? status;
  List<VariationAttributeData>? attributes = [];

  FinalVariationData({this.regularPrice, this.salePrice, this.status, this.attributes});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['stock_status'] = this.status;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VariationAttributeData {
  String? option;
  int? id;
  String? name;
  String? selectedValue;
  int? selectedId;

  VariationAttributeData({
    this.option,
    this.id,
    this.name,
    this.selectedValue = "",
    this.selectedId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['option'] = this.option;
    return data;
  }
}
