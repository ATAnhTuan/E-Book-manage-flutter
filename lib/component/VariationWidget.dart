import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/Variation.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class VariationWidget extends StatefulWidget {
  final List<Variation>? variationList;
  final int? index;

  VariationWidget({this.variationList, this.index});

  @override
  VariationWidgetState createState() => VariationWidgetState();
}

class VariationWidgetState extends State<VariationWidget> {
  List<String> colorArray = ['#000000', '#ccd5e1'];
  List<String> stockStatus = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: getColorFromHex(colorArray[widget.index! % colorArray.length]).withOpacity(0.1),
        border: Border.all(color: iconColorSecondary, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${language!.variation} ${widget.index! + 1}', style: boldTextStyle()).center(),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            runAlignment: WrapAlignment.start,
            alignment: WrapAlignment.start,
            spacing: 1,
            children: List.generate(
              widget.variationList![widget.index!].variationList.length,
              (i) {
                return DropdownButton(
                  value: widget.variationList![widget.index!].variationList[i][0].selectedValue,
                  underline: SizedBox(),
                  items: widget.variationList![widget.index!].variationList[i].map(
                    (e) {
                      return DropdownMenuItem(
                        child: Text(e.option!),
                        value: e.option,
                      );
                    },
                  ).toList(),
                  onChanged: (dynamic value) {
                    widget.variationList![widget.index!].variationList[i][0].selectedValue = value;
                    setState(() {});
                  },
                ).paddingRight(10);
              },
            ).toList(),
          ),
          16.height,
          AppTextField(
            decoration: InputDecoration(),
            controller: widget.variationList![widget.index!].price,
            textFieldType: TextFieldType.PHONE,
          ),
          16.height,
          CommonTextFormField(
            mController: widget.variationList![widget.index!].salePrice,
            labelText: language!.salesPrice,
          ),
          16.height,
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
              border: Border.all(color: iconColorSecondary, width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButtonFormField<String>(
              value: widget.variationList![widget.index!].selectedStatus,
              decoration: InputDecoration.collapsed(hintText: null),
              hint: Text(
                language!.selectStatus,
                style: primaryTextStyle(),
              ),
              isExpanded: true,
              items: stockStatus.map((e) => DropdownMenuItem<String>(child: Text(e), value: e)).toList(),
              onChanged: (String? value) {
                hideKeyboard(context);
                widget.variationList![widget.index!].selectedStatus = value;
                setState(() {});
              },
            ),
          ),
          16.height,
          Container(
            alignment: Alignment.bottomRight,
            child: Text(language!.removeVariation, style: primaryTextStyle(color: Colors.red, size: 12)).onTap(
              () {
                showConfirmDialogCustom(
                  context,
                  onAccept: (context) {
                    widget.variationList!.remove(widget.variationList![widget.index!]);
                    setState(() {});
                    finish(context);
                  },
                  dialogType: DialogType.DELETE,
                );
                setState(() {});
              },
            ),
          )
        ],
      ),
    );
  }
}
