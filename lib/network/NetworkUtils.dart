import 'dart:convert';

import 'package:bookkart_author/utils/AppCommon.dart';
import 'package:bookkart_author/utils/AppConstants.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

bool isSuccessful(int code) {
  return code >= 200 && code <= 206;
}

Future buildTokenHeader() async {
  var pref = await getSharedPref();

  var header = {
    "token": "${pref.getString(TOKEN)}",
    "id": "${pref.getInt(USER_ID)}",
    "Content-Type": "application/json",
    //"Accept": "application/json",
  };
  print(jsonEncode(header));
  return header;
}

Future handleResponse(Response response) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }
  if (response.statusCode.isSuccessful()) {
    if(response.body.isEmpty) return;
    return jsonDecode(response.body);
  } else {
    try {
      var body = jsonDecode(response.body);
      throw parseHtmlString(body['message']);
    } on Exception catch (e) {
      log(e);
      throw errorSomethingWentWrong;
    }
  }
}
