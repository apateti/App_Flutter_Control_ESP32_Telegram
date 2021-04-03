import 'dart:convert';

import 'package:control_porton/src/controller/list_user_Controller.dart';
import 'package:control_porton/src/controller/user_controller.dart';
import 'package:control_porton/src/models/model_user_account.dart';
import 'package:control_porton/src/pages/Configuration/edit_user_config.dart';
import 'package:control_porton/src/pages/home_page.dart';
import 'package:control_porton/src/utils/api_login.dart';
//import 'package:control_porton/src/utils/api_porton.dart';
import 'package:control_porton/src/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vibration/vibration.dart';
import 'package:http/http.dart' as http;

class ListUserConfig extends StatelessWidget {
  //const ListUserConfig({Key key}) : super(key: key);
  final _controllerUserName = TextEditingController();
  final _controllerUserID = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
    return GetBuilder<ListUserController>(
      init: ListUserController(),
      builder: (_) => Scaffold(
        backgroundColor: Color.fromARGB(224, 255, 255, 224),
        appBar: AppBar(
          title: Text('Lista de Usuarios Registrados'),
        ),
        body: Stack(
          children: [
            _mostrarListUser(),
            Obx(() => UserController.to.loadHttp ? LoadHttp() : Container()),
          ],
        ),
        floatingActionButton: _agregarUsuario(),
      ),
    );
  }

  // Widget _mostrarListUser() {
  //   return GetBuilder<ListUserController>(
  //     builder: (_) {
  //       return (_.listUserReg.length == 0
  //           ? Center(
  //             child: Text('No Hay Usuarios Registrados'),
  //           )
  //           : Obx(
  //             () => ListView.builder(
  //               itemCount: _.listUserReg.length,
  //               itemBuilder: (__, index){
  //                 final String nameUser = _.listUserReg[index].userName;
  //                 final int idUser = _.listUserReg[index].userId;
  //                 final bool blockUser = _.listUserReg[index].blocked;
  //                 return ListTile(
  //                   title: Text(nameUser),
  //                 );
  //               })
  //           )
  //       );
  //     }
  //   );
  // }
  // Widget _mostrarListUser() {
  //   return GetBuilder<ListUserController>(
  //     builder: (_){
  //       print("Dentro de _mostrarListUser ${_.listUserReg.length}");
  //       return
  //       _.listUserReg.length == 0
  //         ? Center(
  //           child: Text('No Hay Usuarios Registrados'),
  //         )
  //         : ListView.builder(
  //           itemCount: _.listUserReg.length,
  //           itemBuilder: (__, index){
  //             final String nameUser = _.listUserReg[index].userName;
  //             return ListTile(
  //               title: Text(nameUser),
  //             );
  //           },
  //         );
  //     }
  //   );
  // }
  Widget _mostrarListUser() {
    return GetX<ListUserController>(
      initState: (state) {
        Get.find<ListUserController>();
      },
      builder: (_) {
        return _.listUserReg.length == 0
            ? Center(
                child: Text('No Hay Usuarios Registrados'),
              )
            : ListView.builder(
                padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                itemCount: _.listUserReg.length,
                itemBuilder: (context, index) {
                  // print("Dentro de _mostrarListUser ${_.listUserReg[index].userName}");
                  // print("Bloqueado ${_.listUserReg[index].blocked}");
                  UserModel _user = _.listUserReg[index];
                  print('_user Nombre: ${_user.userName}');
                  print('_user ID: ${_user.userId}');
                  return Card(
                    shape: StadiumBorder(),
                    elevation: 8,
                    // Container(
                    //   decoration: BoxDecoration(
                    //     border: Border(bottom: BorderSide(style: BorderStyle.solid)),
                    //     shape: BoxShape.rectangle,
                    //     //borderRadius: BorderRadius.,
                    //   ),
                    child: ListTile(
                      title: Text("Usuario: ${_user.userName}"),
                      subtitle: Row(
                        children: [
                          Text("ID: ${_user.userId}"),
                          SizedBox(width: 15.0),
                          Icon(
                            _user.blocked ?? false
                                ? FontAwesomeIcons.lock
                                : FontAwesomeIcons.lockOpen,
                            color: _user.blocked ?? false
                                ? Colors.red[900]
                                : Colors.lightBlue[900],
                            size: 15,
                          ),
                        ],
                      ),
                      onTap: () {
                        _showEditUser(_user);
                      },
                    ),
                  );
                });
      },
    );
  }

  _showEditUser(UserModel userEdit) {
    Get.off(
      EditUserConfig(),
      arguments: userEdit,
      transition: Transition.zoom,
    );
  }

  Widget _agregarUsuario() {
    return FloatingActionButton(
      child: Icon(FontAwesomeIcons.userPlus),
      onPressed: (){
        Vibration.vibrate(duration: 40);
        _dialogoAddUser('Agregar Usuario', _functionAgregar);
      },
    );
  }

  _dialogoAddUser(String _titulo, Function _ok){
    Get.defaultDialog(
      title: _titulo,
      content: _textAgregar(),
      onConfirm: (){
        Vibration.vibrate(duration: 40);
        _ok();
      },
      onCancel: () {
        Vibration.vibrate(duration: 40);
        //_cancelar();
      },
    );
  }

  _functionAgregar(){
    if(_formKey.currentState.validate()){
      _cancelar();
      _sendAgregarUser('registrar');
      //print('Validado');
    }
  }

  _cancelar(){
    Get.back();
  }
  _exitApp(){
    SystemNavigator.pop();
  }
  _exitAll(){
    Get.offAll(HomePage());
  }
  Widget _textAgregar(){
    return Column(
            children: [
              SizedBox(height: 22),
              // Text(
              //   'Agregar ',
              //   style: TextStyle(fontSize: 20),
              // ),
              // SizedBox(height: 22),
              //Text('Usuario: ${_.userEdit.userName}'),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _textEditUser(),
                    SizedBox(height: 22),
                    _textEditId(),
                    SizedBox(height: 22),
                    // _editBlocked(),
                    // SizedBox(height: 22),
                    // _editBotton(),
                  ],
                ),
              ),
            ],
          );
  }

  Widget _textEditUser() {
    //_controllerUserName =
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: _controllerUserName,
        decoration: InputDecoration(
          //contentPadding: EdgeInsets.symmetric(ver),
          prefixIcon: Icon(
            Icons.account_circle,
            color: Colors.deepPurple,
          ),
          fillColor: Colors.black12,
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 28.0),
          // icon: Icon(
          //       Icons.account_box,
          //       color: Colors.deepPurple,
          //     ),
          hintText: "Nombre de Usuario",
          //labelText: 'Introduzca el UserName',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
        validator: (userLogin) {
          if (userLogin.length < 5) {
            return 'Debe introducir el UserName';
          }
        },
      ),
    );
  }

  Widget _textEditId() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: _controllerUserID,
        decoration: InputDecoration(
          //contentPadding: EdgeInsets.symmetric(ver),
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.deepPurple,
          ),
          fillColor: Colors.black12,
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 28.0),
          // icon: Icon(
          //       Icons.account_box,
          //       color: Colors.deepPurple,
          //     ),
          hintText: "ID de Usuario",
          //labelText: 'Introduzca el UserName',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
        validator: (passwLogin) {
          if (passwLogin.length < 9 || (int.tryParse(passwLogin) == null)) {
            return 'Debe introducir un UserID Valido';
          }
        },
      ),
    );
  }

  Future<void> _sendAgregarUser(String _command) async {
    String _userName = _controllerUserName.text;
    int _userID = int.tryParse(_controllerUserID.text);
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
      if((mapUser['code']) == 200){
        print('Sin Data o Null');
        _verDialogo('Error', 'La comunicacion Falló!', _cancelar);
      }else{
        print('Con elementos');
        if(mapUser['code'] == 0){
          //if(mapUser['data']['regID']==0){
            if(mapUser.containsKey('data')){
              if(mapUser['data'].containsKey('regID')){
              print('Administrador grabado con exito...');
              UserController.to.userAccount.userName = mapUser['data']['userName']?? '';
              UserController.to.userAccount.userId = mapUser['data']['userId']?? 0;
              UserController.to.userAccount.blocked = mapUser['data']['userBlock']?? false;
              box.write('userID', mapUser['data']['userId']?? 0);
              box.write('userName', mapUser['data']['userName']?? '');
              await _verDialogo('Usuario Administrador Agregado', 'El usuario fue agregado del sistema! Se Saldra de la App!', _exitApp);
            }
                          
          }else{
            await _verDialogo('Usuario Agregado', 'El usuario fue agregado del sistema!', _exitAll);
          }
          if(!Get.isDialogOpen) {
            print('Se cerro Dialog: Usuario Agregado');
            _cancelar();
          }
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
