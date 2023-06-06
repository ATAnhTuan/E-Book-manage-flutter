import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/BorrowBookResponse.dart';
import 'package:bookkart_author/models/BorrowRequestResponse.dart';
import 'package:bookkart_author/network/rest_apis.dart';
import 'package:bookkart_author/utils/AppColors.dart';
import 'package:bookkart_author/utils/AppCommon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class RequestComponent extends StatefulWidget {
  static String tag = '/RequestComponent';
  final BorrowRequestData? requestdata;
  final Function? onApprove;
  final Function? onReject;
  final bool extention;
    final bool request;
  RequestComponent(
      {this.requestdata, this.onApprove, this.onReject,this.extention = false,this.request = false});

  @override
  RequestComponentState createState() => RequestComponentState();
}

class RequestComponentState extends State<RequestComponent> {
  @override
  void initState() {
    super.initState();
  }


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(120),
                    topRight: Radius.circular(120)),
              ),
              height: 40,
              width: 80,
            ),
            Container(
              height: 100,
              width: 80,
              decoration: boxDecorationWithRoundedCorners(
              borderRadius: radius(10)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: CachedNetworkImage(
                height: 100,
                width: 80,
                imageUrl: widget.requestdata!.bookInfo!.thumbnailUrl!.toString(),
                fit: BoxFit.fill,
              ),
              margin: EdgeInsets.only(bottom: 16),
            ),
          ],
        ),
        8.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.requestdata!.bookInfo!.title!.validate()}',
                style: primaryTextStyle(size: 16, weight: FontWeight.bold),
                maxLines: 1),
            8.height,
            Text(
              convertDate(widget.requestdata!.createdAt.toString()),
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  height: 1),
            ),
            8.height,
              // Text('${widget.requestdata!.requester!.fullName.toString()}',
              //   style: primaryTextStyle(size: 16, weight: FontWeight.bold),
              //   maxLines: 1).visible(!widget.extention),
              Container(
                width: 80,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(30)),
                child: Text(
                    '${widget.requestdata!.status}',
                        style: primaryTextStyle(color: white,),maxLines: 1
                    ),
              ),
          ],
        ).expand(),
            PopupMenuButton(
                onSelected: (v) async {
                  if (v == 1 && widget.request) {
                    var request = {"note" :"ok"};
                  showConfirmDialogCustom(
                      context,
                      onAccept: (context) {
                        approvalRequestStatus(widget.requestdata!.id!,request).then((value){
                        widget.onApprove!.call(widget.requestdata!.id);
                        toast(language!.successfullyUpdateStatus);
                        });
                      },
                      dialogType: DialogType.ACCEPT,
                      negativeText: language!.cancel,
                      positiveText: language!.update,
                    );
                  }
                  else if (v == 2 && widget.request){
                    var request = {"note" :"ok"};
                    showConfirmDialogCustom(
                      context,
                      onAccept: (context) {
                        rejectionRequestStatus(widget.requestdata!.id,request).then((value){
                        widget.onReject!.call(widget.requestdata!.id);
                        toast(language!.successfullyUpdateStatus);
                        });

                      },
                      dialogType: DialogType.DELETE,
                      negativeText: language!.cancel,
                      positiveText: language!.update,
                    );
                  }
                  else if (v == 1 && widget.extention) {
                  var request = {"note" :"ok"};
                  showConfirmDialogCustom(
                      context,
                      onAccept: (context) {
                        approvalRequestStatus(widget.requestdata!.id!,request).then((value){
                        widget.onApprove!.call(widget.requestdata!.id);
                        toast(language!.successfullyUpdateStatus);
                        });
                      },
                      dialogType: DialogType.ACCEPT,
                      negativeText: language!.cancel,
                      positiveText: language!.update,
                    );
                  }
                  else if (v == 2 && widget.extention) {
                                        var request = {"note" :"ok"};
                    showConfirmDialogCustom(
                      context,
                      onAccept: (context) {
                        rejectionRequestStatus(widget.requestdata!.id,request).then((value){
                        widget.onReject!.call(widget.requestdata!.id);
                        toast(language!.successfullyUpdateStatus);
                        });

                      },
                      dialogType: DialogType.DELETE,
                      negativeText: language!.cancel,
                      positiveText: language!.update,
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: TextIcon(
                      prefix: Icon(Icons.check, size: 14, color: appStore.isDarkModeOn ? white : primaryColor),
                      text: "Approve",
                      textStyle: secondaryTextStyle(color: appStore.isDarkModeOn ? white : primaryColor),
                    ),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: TextIcon(
                      prefix: Icon(Icons.dangerous_outlined, size: 14, color: Colors.red),
                      text: "Reject",
                      textStyle: secondaryTextStyle(color: Colors.red),
                    ),
                    value: 2,
                  )
                ],
              ).paddingRight(20).paddingTop(25),
      ],
    ).paddingLeft(20).paddingTop(10).paddingBottom(5);
  }
}


