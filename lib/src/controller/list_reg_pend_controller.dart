


import 'dart:convert';

import 'package:control_porton/src/controller/user_controller.dart';
import 'package:control_porton/src/models/model_user_account.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ListRegistroPendController extends GetxController{
  final String _endPointJson = 'cmdoJson';
  var resp;
  final box = GetStorage();
  String userAdm = UserController.to.userAccount.userName;
  int userIdAdm = UserController.to.userAccount.userId;
  String _command = "verRegistro";
  Map<String, dynamic> _data;
  Map<String, dynamic> _bodyJ;

  @override
  void onInit() {
    super.onInit();
    print('Ejecutando ListUserController');
    _loadListRegPend();

  }

  //RxList<UserModel> _listUserReg = List<UserModel>().obs;
  List<UserModel> _listUserRegPen = List<UserModel>().obs;
  List<UserModel> get listUserRegPen => this._listUserRegPen;//.toList();
  set listUserRegPen( List<UserModel> value) => this._listUserRegPen = value;

  Future<void> _loadListRegPend() async {
    Map<String, dynamic> mapUser;
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
      mapUser = json.decode(resp.body);
      print('Respuesta de http: ${resp.body}');
      print('Ver Map: $mapUser');
      if((mapUser['data'] as List).isNullOrBlank){
        print('Lista Null');
        this._listUserRegPen = [];
      }else{
        print('Lista con elementos');
        List listAux = mapUser["data"]
          .map<UserModel>((x) => UserModel.fromJson(x))
          .toList(); 
        print("Name User1: ${listAux[0].userName}");
        print("Longitud de la Lista1: ${listAux.length}");
        this._listUserRegPen = listAux;
      }
      update();

    } catch (e) {
      print("Error de _loadListRegPend:");
      print(e);
    }
    UserController.to.loadHttp = false;
  }


}