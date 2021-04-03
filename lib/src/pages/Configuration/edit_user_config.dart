import 'dart:convert';

import 'package:control_porton/src/controller/edit_user_controller.dart';
import 'package:control_porton/src/controller/user_controller.dart';
import 'package:control_porton/src/pages/Configuration/list_user_config.dart';
import 'package:control_porton/src/pages/configure_page.dart';
import 'package:control_porton/src/utils/api_login.dart';
import 'package:control_porton/src/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vibration/vibration.dart';
import 'package:http/http.dart' as http;

class EditUserConfig extends StatelessWidget {
  //const EditUserConfig({Key key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final _controllerUserName = TextEditingController();
  final _controllerUserID = TextEditingController();
  //final controllerEditUser = Get.find<EditUserController>();
  //final EditUserController controller = Get.put(EditUserController());
  final String _endPointJson = 'cmdoJson';
  final box = GetStorage();
  String userAdm = UserController.to.userAccount.userName;
  int userIdAdm = UserController.to.userAccount.userId;
  //String _command = "blockUser";
  Map<String, dynamic> _data;
  Map<String, dynamic> _bodyJ;
  var resp;
  @override
  Widget build(BuildContext context) {
    print('Pagina EditUserConfig');
    return GetBuilder<EditUserController>(
      init: EditUserController(),
      //initState: (_){_controllerUserName.text = controller.userEdit.userName ; _controllerUserID.text = controller.userEdit.userId.toString();},
      builder: (_) => Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 224),
        appBar: AppBar(
          title: Text('Editar Usuario'),
        ),
        body: Center(
          child: Stack(
            children: [
              _editUser(),
              Obx(() => UserController.to.loadHttp ? LoadHttp() : Container()),
            ],
          ), 
        ),
      ),
    );
  }

  Widget _editUser() {
    return GetBuilder<EditUserController>(builder: (_) {
      _controllerUserName.text = _.userEdit.userName;
      _controllerUserID.text = _.userEdit.userId.toString();
      return Center(
        child: Container(
          width: Get.width * 0.85,
          height: Get.height * 0.6,
          decoration: BoxDecoration(
            //color: Colors.white,
            color: Color.fromARGB(255, 255, 250, 200),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black26,
                blurRadius: 3.0,
                offset: Offset(10.0, 15.0),
                spreadRadius: 3.0,
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(height: 22),
              Text(
                'Editar',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 22),
              //Text('Usuario: ${_.userEdit.userName}'),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _textEditUser(),
                    SizedBox(height: 22),
                    _textEditId(),
                    SizedBox(height: 22),
                    _editBlocked(),
                    SizedBox(height: 22),
                    _editBotton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
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
          hintText: "Usuario",
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

  Widget _editBlocked() {
    //bool userBlocked =
    Icon _iconBlocked = Icon(
      FontAwesomeIcons.lock,
      color: Colors.red[900],
    );
    Icon _iconNoBlocked = Icon(
      FontAwesomeIcons.lockOpen,
      color: Colors.lightBlue[900],
    );
    return GetX<EditUserController>(builder: (_) {
      //bool _userBlocked = _.userBlocked;
      _.userBlocked = _.userEdit.blocked;
      print('userBlocked ${_.userBlocked}');
      return Card(
        margin: EdgeInsets.only(left: 20, right: 20),
        shape: StadiumBorder(),
        //elevation: 8,
        //color: Colors.black12,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(32.0),
            border: Border()
          ),
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Bloqueado: ', style: TextStyle(fontSize: 18),),
              // Obx( ()=>
              //   builder,
              // ),
              //Obx(() => IconButton(icon: EditUserController().userEdit.blocked ? _iconBlocked : _iconNoBlocked, onPressed: null),),
              IconButton(
                icon: _.userBlocked ? _iconBlocked : _iconNoBlocked,
                onPressed: () {
                  _.userBlocked = !_.userBlocked;
                  _.userEdit.blocked = _.userBlocked;
                  print('Valor: ${_.userBlocked}');
                },
              ),
              // Switch(
              //   value: userBlocked,
              //   onChanged: (bool valor){
              //     print('Swintch en: $valor');
              //     _.userEdit.blocked = valor;
              //     //userBlocked = valor;
              //   },
              // ),
            ],
          ),
        ),
      );
    });
  }

  Widget _editBotton(){
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _botton(Icons.edit, 'Enviar', 18, Colors.white, Colors.green[400], _enviarEdit),
              _botton(Icons.cancel, 'Cancelar', 18, Colors.white, Colors.yellow[200], _cancelar),
            ],
          ),
          SizedBox(height: 20),
          _botton(FontAwesomeIcons.userTimes, 'Eliminar Usuario', 18, Colors.white, Colors.red[300], _borrarUser),
        ],
      ),
    );
  }

  Widget _botton(
      IconData icono,
      String texto,
      double tamText,
      Color colorIcono,
      Color colorBotton,
      Function _funcion) {
    return RaisedButton(
        shape: StadiumBorder(),
        padding: EdgeInsets.all(12),
        color: colorBotton,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icono,
              color: colorIcono,
              size: 30,
            ),
            SizedBox(width: 15),
            Text(
              texto,
              style: TextStyle(fontSize: tamText),
            )
          ],
        ),
        onPressed: () {
          Vibration.vibrate(duration: 40);
          _funcion();
        });
  }

  _cancelar(){
    Get.back();
  }
  _enviarEdit(){
    //Get.back();
    //_verDialogo('Edicion', 'Dialogo de Edicion', _cancelar);
    _sendEditUser("blockUser");
  }

  _borrarUser(){
    _dialogoErrase('Eliminar Usuario', 'Esta seguro de querer eliminar al Usuario', _okErraseUser);

  }

  _okErraseUser()async{
    await _sendEditUser("erraseUser").then((value) {
      print('_okErraseUser con valor: $value');
      if(value){
        Get.off(ListUserConfig());
      }
    });
  }

  _exitEditUser(){
    Get.off(ConfigurePage());
  }


  Future<bool> _sendEditUser(String _command) async {
    String _userName = EditUserController.to.userEdit.userName;
    int _userID = EditUserController.to.userEdit.userId;
    int _regID = EditUserController.to.userEdit.id;
    bool _userBocked = EditUserController.to.userBlocked;
    Map<String, dynamic> mapUser;
    String urlDns = box.read('urlServer');
    String urlTx = 'http://' + urlDns + '/' + _endPointJson;
    _data = {'adminName':userAdm, 'adminID':userIdAdm, 'userName': _userName, 'userID' : _userID, 'regID': _regID, 'userBlock' : _userBocked};
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
          if(_command == "blockUser"){
            await _verDialogo('Edicion Exitosa', 'El usuario se Actualizo!', _exitEditUser);
            if(!Get.isDialogOpen){
              return true;
            }
          }else{
            await _verDialogo('Usuario Elimidado', 'El usuario fue eliminado del sistema!', _exitEditUser);
            if(!Get.isDialogOpen){
              print('Dialogo Usuario Eliminado');
              _cancelar();
              return true;
            }
          }
          
          //_cancelar();
        }else{
          if(_command == "blockUser"){
            _verDialogo('Edicion Sin Efecto', 'El usuario No pudo Actializarce!', _cancelar);
            if(!Get.isDialogOpen){
              return false;
            }
          }else{
            await _verDialogo('Usuario no Elimidado', 'El usuario no pudo eliminado del sistema!', _cancelar);
            if(!Get.isDialogOpen){
              return false;
            }
          }
          
        }
      }

    } catch (e) {
      UserController.to.loadHttp = false;
      print("Error de _loadListRegPend:");
      print(e);
      _verDialogo('Error', 'La comunicacion Falló!', _cancelar);
      if(!Get.isDialogOpen){
        return false;
      }
    }
    return false;
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

  _dialogoErrase(String _titulo, String _subTitulo, Function _ok){
    Get.defaultDialog(
      title: _titulo,
      content: Text(_subTitulo),
      onConfirm: (){
        _ok();
        _cancelar();
      },
      onCancel: () {
        //_cancelar();
      },
    );
  }
  
}
