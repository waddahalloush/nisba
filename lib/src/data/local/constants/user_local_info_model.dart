// To parse this JSON data, do
//
//     final userLocalInfoModel = userLocalInfoModelFromJson(jsonString);

import 'dart:convert';

UserLocalInfoModel userLocalInfoModelFromJson(String str) => UserLocalInfoModel.fromJson(json.decode(str));

String userLocalInfoModelToJson(UserLocalInfoModel data) => json.encode(data.toJson());

class UserLocalInfoModel {
    String? id;
    String? userName;
    String? fullName;
    String? profileImage;
    String? email;
    String? phone;
    String? lat;
    String? long;

    UserLocalInfoModel({
        this.id,
        this.userName,
        this.fullName,
        this.profileImage,
        this.email,
        this.phone,
        this.lat,
        this.long,
    });

    factory UserLocalInfoModel.fromJson(Map<String, dynamic> json) => UserLocalInfoModel(
        id: json["id"],
        userName: json["user_name"],
        fullName: json["full_name"],
        profileImage: json["profile_image"],
        email: json["email"],
        phone: json["phone"],
        lat: json["lat"],
        long: json["long"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": userName,
        "full_name": fullName,
        "profile_image": profileImage,
        "email": email,
        "phone": phone,
        "lat": lat,
        "long": long,
    };
}
