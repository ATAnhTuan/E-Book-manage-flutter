import 'package:bookkart_author/component/ProductDetailCard.dart';
import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/DashboardResponseData.dart';
import 'package:bookkart_author/models/ProductDetailResponse.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppCommon.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductDetailComponent extends StatefulWidget {
  final DashboardBookInfo? mainProduct;

  ProductDetailComponent({this.mainProduct});

  @override
  ProductDetailComponentState createState() => ProductDetailComponentState();
}

class ProductDetailComponentState extends State<ProductDetailComponent> {
  double discount = 0.0;
  double rating = 0.0;
  bool mIsReadMore = false;

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

  // String getAllAttribute(Attributes attribute) {
  //   String attributes = "";
  //   for (var i = 0; i < attribute.options!.length; i++) {
  //     attributes = attributes + attribute.options![i];
  //     if (i < attribute.options!.length - 1) {
  //       attributes = attributes + ", ";
  //     }
  //   }
  //   return attributes;
  // }

  

  @override
  Widget build(BuildContext context) {
    String? img = widget.mainProduct!.thumbnailUrl.toString() ==
            '/api/storage/DefaultThumbnailUrl_001f4126-c301-4a3d-9657-c2088bbf7518.png'
        ? "https://noobercong.blob.core.windows.net/vol/images.png"
        : widget.mainProduct!.thumbnailUrl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.height,
        Text(widget.mainProduct!.title!,
                style: boldTextStyle(size: 22), maxLines: 2)
            .center(),
        16.height,
        Container(
          decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: cachedImage(
            img,
            width: context.width() * 0.3,
            height: 200,
            fit: BoxFit.cover,
          ).cornerRadiusWithClipRRect(20),
        ).center(),
        16.height,
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                8.height,
                Text(
                    "Author(s):              ${widget.mainProduct!.authors![0].fullName.toString()}.",
                    style: primaryTextStyle(size: 20),
                    maxLines: 2),
                8.height,
                (widget.mainProduct!.language! == "vi")
                    ? Text(
                        "Language:             Vietnamese.",
                        style: primaryTextStyle(size: 20),
                        maxLines: 2)
                    : Text(
                        "Language:             English.",
                        style: primaryTextStyle(size: 20),
                        maxLines: 2),
                8.height,
                Text(
                    "Publication:           ${widget.mainProduct!.publisher!.name!}, ${widget.mainProduct!.publishYear}.",
                    style: primaryTextStyle(size: 20),
                    maxLines: 2),
                    8.height,
                Text(
                    "Genre(s):                ${widget.mainProduct!.genres![0].name}.",
                    style: primaryTextStyle(size: 20),
                    maxLines: 2),
                    8.height,
                Text(
                    "Department(s):    ${widget.mainProduct!.departments}.",
                    style: primaryTextStyle(size: 20),
                    maxLines: 2),
                    8.height,
                Text(
                    "Number of pages : ${widget.mainProduct!.numPages}.",
                    style: primaryTextStyle(size: 20),
                    maxLines: 2),
                    8.height,
                Text(
                    "Borrow times:        ${widget.mainProduct!.borrowCount}.",
                    style: primaryTextStyle(size: 20),
                    maxLines: 2),
                    8.height,
                    Row(
                      children: [
                      Text(
                        "Access Permission:  ",
                        style: primaryTextStyle(size: 20),
                        maxLines: 2),
                        (widget.mainProduct!.isPublic!) ?
                        Text(
                        "Public",
                        style: primaryTextStyle(size: 20,color: Colors.green),
                        maxLines: 2)
                        :
                        Text(
                        "Restricted",
                        style: primaryTextStyle(size: 20,color: Colors.grey),
                        maxLines: 2)
                      ],
                    ),
                    8.height,
                    Text(
                    "Overview:",
                    style: primaryTextStyle(size: 20),
                    maxLines: 2),
                    Text(
                    widget.mainProduct!.description!,
                    style: primaryTextStyle(size: 16),
                    maxLines: 2),
              ],
            ).paddingLeft(10).expand()
          ],
        ),
        16.height,
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Column(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text(language!.description, style: boldTextStyle()),
        //         4.height,
        //         Text(parseHtmlString(widget.mainProduct!.description), style: primaryTextStyle(), maxLines: !mIsReadMore ? 2 : null),
        //         TextButton(
        //           onPressed: () {
        //             mIsReadMore = !mIsReadMore;
        //             setState(() {});
        //           },
        //           child: Text(mIsReadMore ? language!.readLess : language!.readMore, style: secondaryTextStyle()),
        //         )
        //       ],
        //     ).visible(widget.mainProduct!.description!.isNotEmpty),
        //     8.height,
        //     Divider(height: 0.2).visible(widget.mainProduct!.shortDescription!.isNotEmpty),
        //     8.height.visible(widget.mainProduct!.shortDescription!.isNotEmpty),
        //     Column(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text(language!.shortDescription, style: boldTextStyle()),
        //         4.height,
        //         Text(parseHtmlString(widget.mainProduct!.shortDescription), style: primaryTextStyle(), maxLines: !mIsReadMore ? 2 : null),
        //       ],
        //     ).visible(widget.mainProduct!.shortDescription!.isNotEmpty),
        //   ],
        // ).visible(widget.mainProduct!.description!.isNotEmpty && widget.mainProduct!.description!.isNotEmpty),
        // widget.mainProduct!.categories!.length != null
        //     ? Column(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text(language!.category, style: boldTextStyle()),
        //           8.height,
        //           Wrap(
        //             children: List.generate(
        //               widget.mainProduct!.categories!.length,
        //               (index) {
        //                 return Container(
        //                   decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: context.cardColor),
        //                   margin: EdgeInsets.only(right: 8, bottom: 8),
        //                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        //                   child: Text(
        //                     parseHtmlString(widget.mainProduct!.categories![index].name),
        //                     style: primaryTextStyle(color: appStore.textSecondaryColor, size: 14),
        //                     textAlign: TextAlign.justify,
        //                   ),
        //                 );
        //               },
        //             ),
        //           )
        //         ],
        //       ).visible(widget.mainProduct!.categories!.isNotEmpty)
        //     : SizedBox().visible(widget.mainProduct!.categories!.isNotEmpty),
        16.height,
        // widget.mainProduct!.downloads!.length != null
        //     ? Column(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text(language!.files, style: boldTextStyle()),
        //           8.height,
        //           Wrap(
        //             children: List.generate(
        //               widget.mainProduct!.downloads!.length,
        //               (index) {
        //                 return Container(
        //                   decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: context.cardColor),
        //                   margin: EdgeInsets.only(right: 8, bottom: 8),
        //                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        //                   child: Text(
        //                     parseHtmlString(widget.mainProduct!.downloads![index].name),
        //                     style: primaryTextStyle(color: appStore.textSecondaryColor, size: 14),
        //                     textAlign: TextAlign.justify,
        //                   ),
        //                 );
        //               },
        //             ),
        //           )
        //         ],
        //       ).visible(widget.mainProduct!.categories!.isNotEmpty)
        //     : SizedBox().visible(widget.mainProduct!.downloads!.isNotEmpty),
        16.height,
      ],
    ).paddingAll(16);
  }
}
