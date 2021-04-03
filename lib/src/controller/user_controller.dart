// import 'package:connectivity/connectivity.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:residential_access/src/models/model_user_account.dart';
// import 'package:residential_access/src/utils/api_load_user.dart';

import 'package:control_porton/src/models/model_user_account.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController {
  final box = GetStorage();
  @override
  void onInit() {
    super.onInit();
    print('Ejecutando UserController');
    box.writeIfNull('urlServer', '192.168.1.100');
    urlIPServer = box.read('urlServer');
  }

  static UserController get to => Get.find();
  
  final _loadHttp = false.obs;
  bool get loadHttp => this._loadHttp.value;
  set loadHttp(bool value) => this._loadHttp.value = value;

  final _timeRequest = 0.obs;
  int get timeRequest => this._timeRequest.value;
  set timeRequest(int value) => this._timeRequest.value = value;

  final _userAccount = UserModel().obs;
  UserModel get userAccount => this._userAccount.value;
  set userAccount(UserModel value) => this._userAccount.value = value;

  final _urlIPServer = '192.168.1.100'.obs;
  String get urlIPServer => this._urlIPServer.value;
  set urlIPServer(String value) => this._urlIPServer.value = value;
}


// var suscription;
// class UserController extends GetxController {
//   static UserController get to => Get.find();

//   final _loadHttp = false.obs;
//   bool get loadHttp => this._loadHttp.value;
//   set loadHttp(bool value) => this._loadHttp.value = value;

//   final _red = 0.obs;
//   int get red => this._red.value;
//   set red(int value) => this._red.value = value;

//   final _timeRequest = 0.obs;
//   int get timeRequest => this._timeRequest.value;
//   set timeRequest(int value) => this._timeRequest.value = value;

//   final _timeToken = 0.obs;
//   int get timeToken => this._timeToken.value;
//   set timeToken(int value) => this._timeToken.value = value;

//   final _userAccount = ModelUserAccount().obs;
//   ModelUserAccount get userAccount => this._userAccount.value;
//   set userAccount(ModelUserAccount value) => this._userAccount.value = value;

//   @override
//   void onInit() {
//     // TODO: implement onInit
//     loadHttp = true;
//     userAccount = ModelUserAccount(
//       usersdata: Usersdata(
//         locks: false
//       ),
//       nums: []
//     );
//     Connectivity()
//         .checkConnectivity()
//         .then((value) => updateNetworkState(value));
//     suscription =
//         Connectivity().onConnectivityChanged.listen(updateNetworkState);
//     _loadUser();
//     super.onInit();
//   }

//   _loadUser()async{
//     print('Cargando USER');
//     await apiUser().then((value) {
//       loadHttp = false;
//       ModelUserRequest resp = value;
//       if(resp.code == 200){
//         print('Se Rx el User');
//         //userAccount = ModelUserAccount.fromJson(resp.modelUser.value);
//         userAccount = resp.modelUser;
//         print('Numeros de Telefono: ${userAccount.nums.length}');
//         // userAccount = ModelUserAccount(
//         //   id: resp.modelUser.id,
//         //   username: resp.modelUser.username,
//         //   firstName: resp.modelUser.firstName,
//         //   lastName: resp.modelUser.lastName,
//         //   usersdata: resp.modelUser.usersdata,
//         //   //nums: Num().,
//         // );
//         print('Usuarios desde UserController: ${userAccount.usersdata}');
//         //print('Nums de Respuesta: ${userAccount.nums[0].number}');
//       }else if(resp.code == 404){
//         userAccount = ModelUserAccount(
//           id: 0,
//           username: null,
//           firstName: null,
//           lastName: null,
//           usersdata: null,
//           nums: null,
//         );
//       }
//     });
//   }
//   void updateNetworkState(ConnectivityResult result) async {
//     print('Cambio de Red');
//     if (result == ConnectivityResult.mobile) {
//       print('Red Movil');
//       red = 2;

//     } else if (result == ConnectivityResult.wifi) {
//       print('Red Wifi');
//       red = 1;

//     } else {
//       print('Sin Red');
//       red = 0;

//     }
//   }
// }