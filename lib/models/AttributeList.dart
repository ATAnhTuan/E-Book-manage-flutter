import 'package:flutter/material.dart';

class AttributeList {
  TextEditingController? rPriceCont = TextEditingController();
  TextEditingController? sPriceCont = TextEditingController();
  String? selectedStatus;
  String value;
  String name;
  String selectedValue;
  int? selectedId;

  AttributeList({
    required this.value,
    required this.name,
    this.selectedValue = "",
    this.selectedId,
    this.sPriceCont,
    this.rPriceCont,
    this.selectedStatus,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['value'] = this.value;
    data['name'] = this.name;
    data['selectedValue'] = this.selectedValue;
    return data;
  }
}
