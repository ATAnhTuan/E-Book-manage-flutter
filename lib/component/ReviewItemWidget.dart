import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/ReviewResponse.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/screens/UpdateReviewScreen.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppCommon.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:bookkart_author/utils/AppImages.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class ReviewItemWidget extends StatefulWidget {
  final ReviewResponse? data;
  final Function? onUpdate;
  final Function(int?)? onDelete;

  ReviewItemWidget({this.data, this.onUpdate, this.onDelete});

  @override
  _ReviewItemWidgetState createState() => _ReviewItemWidgetState();
}

class _ReviewItemWidgetState extends State<ReviewItemWidget> {
  Future<void> deleteReviews() async {
    hideKeyboard(context);

    appStore.setLoading(true);

    await deleteReview(reviewId: widget.data!.id.validate()).then((res) {
      if (res.status == 'trash') toast(language!.successfullyDeleted);
      widget.onDelete?.call(res.id);
    }).catchError((error) {
      log(error.toString());
    }).whenComplete(() {
      LiveStream().emit(REMOVE_REVIEW, true);
      appStore.setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              cachedImage(
                widget.data!.reviewerAvatarUrls != null ? widget.data!.reviewerAvatarUrls!.ninetySix : ic_profile_img,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ).cornerRadiusWithClipRRect(40).paddingOnly(top: 6),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  4.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        parseHtmlString(widget.data!.reviewer.validate()),
                        style: boldTextStyle(size: 15),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ).expand(),
                      Text(DateFormat.yMMMEd().format(DateTime.parse(widget.data!.dateCreated.validate())), style: secondaryTextStyle(size: 11)),
                    ],
                  ),
                  4.height,
                  Text(parseHtmlString(widget.data!.review.validate()), style: secondaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                  6.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: boxDecorationWithRoundedCorners(
                              boxShadow: defaultBoxShadow(),
                              boxShape: BoxShape.circle,
                              backgroundColor: appStore.isDarkModeOn ? black : white,
                            ),
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.edit, size: 16, color: appStore.isDarkModeOn ? white : primaryColor),
                          ).onTap(
                            () async {
                              bool? res = await showInDialog(
                                context,
                                backgroundColor: appStore.isDarkModeOn ? cardBackgroundBlackDark : white,
                                builder: (BuildContext context) => UpdateReviewScreen(data: widget.data),
                              );

                              if (res ?? false) {
                                setState(() {});
                                widget.onUpdate?.call();
                              }
                            },
                          ),
                          16.width,
                          Container(
                            decoration: boxDecorationWithRoundedCorners(
                              boxShadow: defaultBoxShadow(),
                              boxShape: BoxShape.circle,
                              backgroundColor: appStore.isDarkModeOn ? black : white,
                            ),
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.delete, size: 16, color: Colors.red),
                          ).onTap(
                            () async {
                              showConfirmDialogCustom(
                                context,
                                title: language!.areYouSureDeleteReview,
                                onAccept: (context) {
                                  deleteReviews();
                                },
                                dialogType: DialogType.DELETE,
                                negativeText: language!.cancel,
                                positiveText: language!.delete,
                              );
                            },
                          ),
                        ],
                      ),
                      RatingBarWidget(
                        spacing: 1,
                        itemCount: 5,
                        size: 16,
                        activeColor: Colors.amber,
                        rating: widget.data!.rating!.toDouble(),
                        onRatingChanged: (rating) {
                          setState(() {});
                        },
                      ).paddingTop(8),
                    ],
                  )
                ],
              ).expand(),
            ],
          ),
        ],
      ),
    );
  }
}
