import 'BillingModel.dart';
import 'ShippingModel.dart';

class LoginResponseData {
  LoginData? data;

  LoginResponseData({this.data});

  LoginResponseData.fromJson(Map<String, dynamic> json) {
    data = json['result'] != null ? new LoginData.fromJson(json['result']) : null;

  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.data != null) {
      data['result'] = this.data!.toJson();
    }
    return data;
  }
}

class LoginData {
  String? userID;
  String? username;
  String? userfullName;
  String? sysToken;
  int? sysTokenExpires;
  String? volToken;
  int? volTokenExpires;
  String? refreshToken;
  int? refreshTokenExpires;
  List<String>? roles;
  List<String>? permissions;

  LoginData(
      {
      this.userID,
      this.username,
      this.userfullName,
      this.sysToken,
      this.sysTokenExpires,
      this.volToken,
      this.volTokenExpires,
      this.refreshToken,
      this.refreshTokenExpires,
      this.roles,
      this.permissions
      }
      );

  LoginData.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    username = json['username'];
    userfullName = json['fullName'];
    sysToken = json['sysToken'];
    sysTokenExpires = json['sysTokenExpires'];
    volToken = json['volToken'];
    volTokenExpires = json['volTokenExpires'];
    refreshToken = json['refreshToken'];
    refreshTokenExpires = json['refreshTokenExpires'];
    roles = json['roles'] != null ? new List<String>.from(json['roles']) : null;
    permissions = json['permisssions'] != null ? new List<String>.from(json['permisssions']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['username'] = this.username;
    data['fullName'] = this.userfullName;
    data['sysToken'] = this.sysToken;
    data['volToken'] = this.volToken;
    data['volTokenExpires'] = this.volTokenExpires;
    data['refreshToken'] = this.refreshToken;
    data['refreshTokenExpires'] = this.refreshTokenExpires;
    data['roles'] = this.roles;
    data['permisssions'] = this.permissions;
    return data;
  }
}





class LoginResponse {
    String? avatar;
    Billing? billing;
    String? firstName;
    String? lastName;
    String? profileImage;
    Shipping? shipping;
    String? token;
    String? userDisplayName;
    String? userEmail;
    int? userId;
    String? userNiceName;
    List<String>? userRole;

    LoginResponse({this.avatar, this.billing, this.firstName, this.lastName, this.profileImage, this.shipping, this.token, this.userDisplayName, this.userEmail, this.userId, this.userNiceName, this.userRole});

    factory LoginResponse.fromJson(Map<String, dynamic> json) {
        return LoginResponse(
            avatar: json['avatar'], 
            billing: json['billing'] != null ? Billing.fromJson(json['billing']) : null, 
            firstName: json['first_name'], 
            lastName: json['last_name'], 
            profileImage: json['profile_image'], 
            shipping: json['shipping'] != null ? Shipping.fromJson(json['shipping']) : null, 
            token: json['token'], 
            userDisplayName: json['user_display_name'], 
            userEmail: json['user_email'], 
            userId: json['user_id'], 
            userNiceName: json['user_nicename'], 
            userRole: json['user_role'] != null ? new List<String>.from(json['user_role']) : null, 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['avatar'] = this.avatar;
        data['first_name'] = this.firstName;
        data['last_name'] = this.lastName;
        data['profile_image'] = this.profileImage;
        data['token'] = this.token;
        data['user_display_name'] = this.userDisplayName;
        data['user_email'] = this.userEmail;
        data['user_id'] = this.userId;
        data['user_nicename'] = this.userNiceName;
        if (this.billing != null) {
            data['billing'] = this.billing!.toJson();
        }
        if (this.shipping != null) {
            data['shipping'] = this.shipping!.toJson();
        }
        if (this.userRole != null) {
            data['user_role'] = this.userRole;
        }
        return data;
    }
}


