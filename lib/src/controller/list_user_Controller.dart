


import 'dart:convert';

import 'package:control_porton/src/controller/user_controller.dart';
import 'package:control_porton/src/models/model_user_account.dart';
import 'package:control_porton/src/pages/Configuration/edit_user_config.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ListUserController extends GetxController {
  final String _endPointJson = 'cmdoJson';
  var resp;
  final box = GetStorage();
  String userAdm = UserController.to.userAccount.userName;
  int userIdAdm = UserController.to.userAccount.userId;
  String _command = "verAllUser";
  Map<String, dynamic> _data;
  Map<String, dynamic> _bodyJ;

  @override
  void onInit() {
    super.onInit();
    print('Ejecutando ListUserController');
    _loadListUser();

  }

  //RxList<UserModel> _listUserReg = List<UserModel>().obs;
  List<UserModel> _listUserReg = List<UserModel>().obs;
  List<UserModel> get listUserReg => this._listUserReg;//.toList();
  set listUserReg( List<UserModel> value) => this._listUserReg = value;


  // showEditUser(UserModel userEdit){
  //   Get.off(EditUserConfig(),
  //     arguments: userEdit,
  //     transition: Transition.zoom,
  //   );

  // }



  Future<void> _loadListUser() async {
    String urlDns = box.read('urlServer');
    String urlTx = 'http://' + urlDns + '/' + _endPointJson;
    _data = {'userName':userAdm, 'userID':userIdAdm};
    _bodyJ = {'cmdo':_command, 'data': _data};
    String _body = json.encode(_bodyJ);
    UserController.to.loadHttp = true;
    try {
      resp = await http.post(
        urlTx,
        headers: {"Content-Type": "application/json"},
        body: _body,
      );
      print('Respuesta de http: ${resp.body}');
      Map<String, dynamic> mapUser = json.decode(resp.body);
      // this._listUserReg = (jsonDecode(resp.body["data"]) as List)
      //   .map((e) => UserModel.fromJson(e))
      //   .toList();
      //jsonResponse.containsKey('city')
      if((mapUser['data'] as List).isNullOrBlank){
        this._listUserReg = [];
        print("Se Rx Lista de Usuarios Registrados vacia");
      }else{
        List listAux = mapUser["data"]
          .map<UserModel>((x) => UserModel.fromJson(x))
          .toList(); 
        print("Name User1: ${listAux[0].userName}");
        print("Longitud de la Lista1: ${listAux.length}");
        this._listUserReg = listAux;
      }
      update();
      // this._listUserReg = mapUser["data"]
      //   .map<UserModel>((e) => UserModel.fromJson(e))
      //   .toList();
      // print("Name User: ${this._listUserReg[0].userName}");
      // print("Longitud de la Lista: ${this._listUserReg.length}");
      // List<NetworkOption> networkOptions = response.data['data']['networks']
      //     .map<NetworkOption>((x) => NetworkOption.fromJson(x))
      //     .toList();
      //Map<String, dynamic> map = json.decode(resp.body)
      //this._listUserReg = listAux.map<UserModel>((e) => UserModel.fromJson(e)).toList();
      //this._listUserReg = listAux.map((e) => UserModel.fromJson(e)).toList();
      // this._listUserReg =(mapUser["data"] as List)
      //   .map((x) => UserModel.fromJson(x)).toList();
     
      
      //print("Name User2: ${this._listUserReg[0].userName}");
      //print("Longitud de la Lista2: ${this._listUserReg.length}");
    } catch (e) {
      print("Error de _loadListUser:");
      print(e);
    }
    UserController.to.loadHttp = false;
  }
}