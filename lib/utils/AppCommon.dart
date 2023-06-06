import 'package:bookkart_author/component/OrderComponent.dart';
import 'package:bookkart_author/main.dart';
import 'package:bookkart_author/models/ProductDetailResponse.dart';
import 'package:bookkart_author/utils/AppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart' as init;
import 'package:nb_utils/nb_utils.dart';

import 'AppConstants.dart';

/*
extension SExt on String {
  String get translate => appLocalizations!.translate(this);
}
*/

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

String convertDate(date) {
  try {
    return date != null ? init.DateFormat(orderDateFormat).format(DateTime.parse(date)) : '';
  } catch (e) {
    print(e);
    return '';
  }
}

bool get isVendor => getStringAsync(USER_ROLE) == "seller";

Widget mSale(ProductDetailResponse1 product) {
  return Positioned(
    left: 0,
    top: 0,
    child: Container(
      decoration: boxDecorationWithRoundedCorners(backgroundColor: Colors.red, borderRadius: radiusOnly(topLeft: 8)),
      child: Text("Sale", style: secondaryTextStyle(color: white, size: 12)),
      padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
    ),
  ).visible(product.onSale == true);
}

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(id: 0, name: 'English', languageCode: 'en', fullLanguageCode: 'en-US', flag: 'images/flags/ic_us.png'),
    LanguageDataModel(id: 1, name: 'Afrikaans', languageCode: 'af', fullLanguageCode: 'hi-IN', flag: 'images/flags/ic_afrikaans.png'),
    LanguageDataModel(id: 2, name: 'Arabic', languageCode: 'ar', fullLanguageCode: 'ar-AR', flag: 'images/flags/ic_ar.png'),
    LanguageDataModel(id: 3, name: 'German', languageCode: 'de', fullLanguageCode: 'gu-GU', flag: 'images/flags/ic_germany.png'),
    LanguageDataModel(id: 4, name: 'Spanish', languageCode: 'es', fullLanguageCode: 'ar-AF', flag: 'images/flags/ic_spanish.png'),
    LanguageDataModel(id: 5, name: 'French', languageCode: 'fr', fullLanguageCode: 'nl-NL', flag: 'images/flags/ic_french.png'),
    LanguageDataModel(id: 6, name: 'Hindi', languageCode: 'hi', fullLanguageCode: 'fr-FR', flag: 'images/flags/ic_india.png'),
    LanguageDataModel(id: 7, name: 'Turkish', languageCode: 'tr', fullLanguageCode: 'de-DE', flag: 'images/flags/ic_turkey.png'),
    LanguageDataModel(id: 8, name: 'Vietnamese', languageCode: 'vi', fullLanguageCode: 'id-ID', flag: 'images/flags/ic_vietnamese.png'),
  ];
}

class QueryString {
  static Map parse(String query) {
    var search = new RegExp('([^&=]+)=?([^&]*)');
    var result = new Map();

    // Get rid off the beginning ? in query strings.
    if (query.startsWith('?')) query = query.substring(1);

    // A custom decoder.
    decode(String s) => Uri.decodeComponent(s.replaceAll('+', ' '));

    // Go through all the matches and build the result map.
    for (Match match in search.allMatches(query)) {
      result[decode(match.group(1)!)] = decode(match.group(2)!);
    }

    return result;
  }
}

Widget cardWidget(BuildContext context, {String? orderName, int? total, double? width}) {
  return Container(
    decoration: boxDecorationDefault(
      color: statusColor(orderName!.toLowerCase()).withOpacity(0.3),
      boxShadow: <BoxShadow>[],
    ),
    padding: EdgeInsets.all(10),
    width: width ?? context.width() / 3 - 22,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(orderName.validate(), style: boldTextStyle(size: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
        10.height,
        Text("$total", style: boldTextStyle(size: 24)),
      ],
    ),
  );
}
