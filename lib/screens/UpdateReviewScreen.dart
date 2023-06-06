import 'package:bookkart_author/models/ReviewResponse.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppCommon.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class UpdateReviewScreen extends StatefulWidget {
  static String tag = '/UpdateReviewScreen';
  final ReviewResponse? data;

  UpdateReviewScreen({this.data});

  @override
  UpdateReviewScreenState createState() => UpdateReviewScreenState();
}

class UpdateReviewScreenState extends State<UpdateReviewScreen> {
  TextEditingController reviewCont = TextEditingController();

  int totalStar = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    reviewCont.text = parseHtmlString(widget.data!.review.validate());
    totalStar = widget.data!.rating.validate();
  }

  Future<void> updateReviews() async {
    Map req = {"rating": totalStar, "review": reviewCont.text.validate()};

    appStore.setLoading(true);

    await updateReview(reviewId: widget.data!.id.validate(), request: req).then(
      (res) {
        widget.data!.rating = totalStar;
        widget.data!.review = reviewCont.text.validate();
        toast(language!.updateSuccessfully);

        finish(context, true);
      },
    ).catchError(
      (error) {
        log(error.toString());
        toast(error.toString().validate());
      },
    ).whenComplete(
      () {
        appStore.setLoading(false);
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: reviewCont,
                textFieldType: TextFieldType.OTHER,
                cursorColor: appStore.isDarkModeOn ? white : black,
                decoration: inputDecoration(context, language!.productReview),
                maxLines: 5,
              ),
              16.height,
              RatingBarWidget(
                spacing: 4,
                itemCount: 5,
                size: 36,
                activeColor: Colors.amber,
                rating: totalStar.toDouble(),
                onRatingChanged: (rating) {
                  log(rating);
                  totalStar = rating.toInt();
                  setState(() {});
                },
              ),
              16.height,
              AppButton(
                shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                text: language!.edit,
                color: primaryColor,
                textColor: white,
                width: context.width(),
                onTap: () {
                  hideKeyboard(context);
                  updateReviews();
                },
              ),
            ],
          ),
          Observer(builder: (_) => Loader().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
