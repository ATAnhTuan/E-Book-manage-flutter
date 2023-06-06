import 'package:bookkart_author/models/DashboardResponseData.dart';
import 'package:bookkart_author/models/ProductDetailResponse.dart';
import 'package:bookkart_author/screens/ProductDetailScreen.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppCommon.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class ProductItemComponent extends StatefulWidget {
  static String tag = '/ProductItemWidget';
  final Function(int)? onDelete;
  final Function? onUpdate;
  final DashboardBookInfo? mbook;
  ProductItemComponent(
      { this.onDelete, this.onUpdate, this.mbook});

  @override
  ProductItemComponentState createState() => ProductItemComponentState();
}

class ProductItemComponentState extends State<ProductItemComponent> {
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
    String? img = widget.mbook!.thumbnailUrl.toString() ==
            '/api/storage/DefaultThumbnailUrl_001f4126-c301-4a3d-9657-c2088bbf7518.png'
        ? "https://noobercong.blob.core.windows.net/vol/images.png"
        : widget.mbook!.thumbnailUrl;

    return Row(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            cachedImage(
              img,
              width: context.width() * 0.25,
              height: 125,
              fit: BoxFit.cover,
            ).cornerRadiusWithClipRRect(8),
          ],
        ),
        16.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.mbook!.title!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: boldTextStyle(size: 16)),
            4.height,
            Text(widget.mbook!.authors![0].fullName!,
                style: primaryTextStyle()),
            4.height,
            4.width,
            PriceWidget(
              price: widget.mbook!.publishYear,
              size: 16,
              color: appStore.textPrimaryColor,
            ),
          ],
        ).expand(),
        Container(
          decoration: boxDecorationWithRoundedCorners(
            backgroundColor: appStore.isDarkModeOn ? black : white,
            boxShadow: defaultBoxShadow(),
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          padding: EdgeInsets.all(8),
          child: Icon(Icons.arrow_forward_ios,
              size: 12, color: appStore.iconSecondaryColor),
        ),
      ],
    ).paddingAll(16).onTap(
      () async {
        widget.onUpdate!.call(widget.mbook!.id);
        var res = await ProductDetailScreen(mProId: widget.mbook!.id).launch(context);
        if (res != null) {
          log(res);
          widget.onDelete!(res);
        }
      },
    );
  }
}
