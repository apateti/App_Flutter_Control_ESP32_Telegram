import 'dart:convert';

import 'package:control_porton/src/controller/list_reg_pend_controller.dart';
import 'package:control_porton/src/controller/user_controller.dart';
import 'package:control_porton/src/models/model_user_account.dart';
import 'package:control_porton/src/pages/configure_page.dart';
import 'package:control_porton/src/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class RegPendConfig extends StatelessWidget {
  //const ListUserConfig({Key key}) : super(key: key);
  final box = GetStorage();
  final String _endPointJson = 'cmdoJson';
  String userAdm = UserController.to.userAccount.userName;
  int userIdAdm = UserController.to.userAccount.userId;
  //String _command = "blockUser";
  Map<String, dynamic> _data;
  Map<String, dynamic> _bodyJ;
  var resp;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ListRegistroPendController>(
      init: ListRegistroPendController(),
      builder: (_) => Scaffold(
        backgroundColor: Color.fromARGB(224, 255, 255, 224),
        appBar: AppBar(
          title: Text('Registros Pendientes'),
        ),
        body: Stack(
          children: [
            _mostrarListRegPen(),
            Obx(() => UserController.to.loadHttp ? LoadHttp() : Container()),
          ],
        ),
      ),
    );
  }

  Widget _mostrarListRegPen() {
    return GetBuilder<ListRegistroPendController>(
      initState: (state) {
        Get.find<ListRegistroPendController>();
      },
      builder: (_) {
        return _.listUserRegPen.length == 0
            ? Center(
                child: Text('No Hay  Registrados de Usuarios Pendientes'),
              )
            : ListView.builder(
                padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                itemCount: _.listUserRegPen.length,
                itemBuilder: (context, index) {
                  print("Dentro de _mostrarListUser ${_.listUserRegPen[index].userName}");
                  print("Bloqueado ${_.listUserRegPen[index].blocked}");
                  UserModel _user = _.listUserRegPen[index];
                  return Card(
                    shape: StadiumBorder(),
                    elevation: 8,
                    child: ListTile(
                      title:
                          Text("Usuario: ${_.listUserRegPen[index].userName}"),
                      subtitle: Row(
                        children: [
                          Text("ID: ${_.listUserRegPen[index].userId}"),
                          // SizedBox(width: 15.0),
                          // Icon(
                          //   _.listUserRegPen[index].blocked ?? false
                          //       ? FontAwesomeIcons.lock
                          //       : FontAwesomeIcons.lockOpen,
                          //   color: _.listUserRegPen[index].blocked ?? false
                          //       ? Colors.red[900]
                          //       : Colors.lightBlue[900],
                          //   size: 15,
                          // ),
                        ],
                      ),
                      onTap: () {
                        _showRegistUser(_user);
                      },
                    ),
                  );
                });
      },
    );
  }

  _showRegistUser(UserModel userEdit){
    _verDialogoAgregar('Agregar Usuario', userEdit, _sendAgregarUser);//userEdit.userName, userEdit.userId, _cancelar);
  }

  _verDialogoAgregar(String _titulo, UserModel _userEdit, Function _ok){
    Get.defaultDialog(
      title: _titulo,
      content: Column(
        children: [
          Text('Nombre de Usuario: ${_userEdit.userName}'),
          Text('ID Usuario: ${_userEdit.userId}'),
        ],
      ),
      onConfirm: (){
        _ok('registrar', _userEdit);
        _cancelar();
      },
      onCancel: (){

      }
    );
  }
  _cancelar(){
    Get.back();
  }

  _exitRegPend(){
    Get.off(ConfigurePage());
  }


  Future<void> _sendAgregarUser(String _command, UserModel _userEdit) async {
    //Get.back();
    String _userName = _userEdit.userName;
    int _userID = (_userEdit.userId);
    //int _regID = EditUserController.to.userEdit.id;
    //bool _userBocked = EditUserController.to.userBlocked;
    Map<String, dynamic> mapUser;
    String urlDns = box.read('urlServer');
    String urlTx = 'http://' + urlDns + '/' + _endPointJson;
    _data = {'adminName':userAdm, 'adminID':userIdAdm, 'userName': _userName, 'userID' : _userID};
    _bodyJ = {'cmdo':_command, 'data': _data};
    String _body = json.encode(_bodyJ);
    print('Se envia el siguiente String Json: $_body');
    UserController.to.loadHttp = true;
    try {
      resp = await http.post(
        urlTx,
        headers: {"Content-Type": "application/json"},
        body: _body,
      );
      UserController.to.loadHttp = false;
      mapUser = json.decode(resp.body);
      print('Respuesta de http: ${resp.body}');
      print('Ver Map: $mapUser');
      if((mapUser['code'])== 200){
        print('Sin Data o Null');
        _verDialogo('Error', 'La comunicacion Falló!', _cancelar);
      }else{
        print('Con elementos');
        if(mapUser['code'] == 0){
          await _verDialogo('Usuario Agregado', 'El usuario fue agregado del sistema!', _exitRegPend);
          // if(!Get.isDialogOpen) {
          //   print('Se cerro Dialog: Usuario Agregado');
          //   _cancelar();
          // }
          //_cancelar();
        }else{
          await _verDialogo('Usuario no Agregado', 'El usuario no pudo agregado del sistema!', _cancelar);
        }
      }
    } catch (e) {
      UserController.to.loadHttp = false;
      print("Error de _loadListRegPend:");
      print(e);
      _verDialogo('Error', 'La comunicacion Falló!', _cancelar);
    }
    //UserController.to.loadHttp = false;
  }
  _verDialogo(String _titulo, String _subTitulo, Function _ok){
    Get.defaultDialog(
      title: _titulo,
      content: Text(_subTitulo),
      onConfirm: (){
        _ok();
      }

    );
  }
}
