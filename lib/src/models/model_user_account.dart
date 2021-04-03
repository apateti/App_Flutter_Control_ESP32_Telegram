//fuente para este models:
//  https://app.quicktype.io/?share=4Ik8Upww0mN33e2CBVmq

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());


class UserModelRequest {
  UserModelRequest({
    this.code,
    this.modelUser,
  });
  int code;
  UserModel modelUser;
}

class UserModel {
    UserModel({
        this.id,
        this.userId,
        this.userName,
        this.blocked,
    });

    int id;
    int userId;
    String userName;
    bool blocked;

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["regID"],
        userId: json["userId"],
        userName: json["userName"],
        blocked: json["userBlock"],
    );

    Map<String, dynamic> toJson() => {
        "regID": id,
        "userId": userId,
        "userName": userName,
        "userBlock": blocked,
    };
}