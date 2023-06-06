import 'package:bookkart_author/models/FinalVariationData.dart';
import 'package:flutter/material.dart';

class Variation {
  List<List<VariationAttributeData>> variationList = [];
  TextEditingController price = TextEditingController();
  TextEditingController salePrice = TextEditingController();
  String? selectedStatus = "";
}
