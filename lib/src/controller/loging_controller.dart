

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ControllerLoging extends GetxController{
  static ControllerLoging get to => Get.find();
  final box = GetStorage();

  final _seePass = true.obs;
  bool get seePass => this._seePass.value;
  set seePass(bool value) => this._seePass.value = value;

  final _userName = 'user'.obs;
  String get userName => this._userName.value;
  set userName(String value) => this._userName.value = value;

  final _userID = 0.obs;
  int get userID => this._userID.value;
  set userID(int value) => this._userID.value = value;

  final _urlServer = '192.168.1.100'.obs;
  String get urlServer => this._urlServer.value;
  set urlServer(String value) => this._urlServer.value = value;

  final _loadHttp = false.obs;
  bool get loadHttp => this._loadHttp.value;
  set loadHttp(bool value) => this._loadHttp.value = value;

  final _timeRequest = 0.obs;
  int get timeRequest => this._timeRequest.value;
  set timeRequest(int value) => this._timeRequest.value = value;

  @override
  void onInit() {
    box.writeIfNull('userName', '');
    box.writeIfNull('userID', 0);
    //box.writeIfNull('urlServer', '192.168.1.100');

    userName = box.read('userName');
    userID = box.read('userID');
    //urlServer = box.read('urlServer');
    print('User del Loging: $userName');

    print('User: $userName');
    print('User ID: $userID');
    //print('urlServer: $urlServer');
    super.onInit();
  }
}