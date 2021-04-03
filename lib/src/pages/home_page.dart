import 'package:control_porton/src/controller/user_controller.dart';
import 'package:control_porton/src/models/model_user_account.dart';
import 'package:control_porton/src/utils/api_porton.dart';
import 'package:control_porton/src/utils/menu_widget.dart';
import 'package:control_porton/src/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

class HomePage extends StatelessWidget {
  //const HomePage({Key key}) : super(key: key);
  //final UserController controllerUser = Get.find<UserController>();
  final controllerUser = Get.find<UserController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String userNameApp = '';
  int userIDApp = 0;
  bool userLockedApp = false;
  @override
  Widget build(BuildContext context) {
    userNameApp = controllerUser.userAccount.userName;
    userIDApp = controllerUser.userAccount.userId;
    userLockedApp = controllerUser.userAccount.blocked;
    print('Stateles de Home Page');
    return Scaffold(
      backgroundColor: Color.fromARGB(224, 255, 255, 224),
      appBar: AppBar(
        title: GetBuilder<UserController>(
          autoRemove: false,
          init: UserController(),
          builder: (_) =>
            Text('Control de Acceso Local'),
          ),
      ),
      drawer: MenuWidget(
        scaffoldKey: _scaffoldKey,
      ),
      body: Stack(
        children: <Widget>[
          _mostrarUser(),
          // GetBuilder<UserController>(
          //     builder: (_) => (_.loadHttp ?? true) ? LoadHttp() : Container()),
          Obx(() => controllerUser.loadHttp ? LoadHttp() : Container()),
        ],
      ),
    );
  }

  Widget _mostrarUser() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 30.0),
              //padding: EdgeInsets.only(left: size.width * 0.075),
              width: Get.width * 0.85,
              //height: size.height * 0.15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 5.0),
                    spreadRadius: 3.0,
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Bienvenido',
                    style: TextStyle(fontSize: 30),
                  ),
                  Divider(
                    thickness: 10,
                    color: Colors.lightBlue[900],
                    // Theme.of(context)
                    //     .primaryColor
                    //     .withOpacity(0.7)),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _iconUser(),
                      // Icon(
                      //   FontAwesomeIcons.userCheck,
                      //   color: Colors.lightBlue[900],
                      // ),
                      GetX<UserController>(
                        //init: UserController(),
                        initState: (value) {
                          controllerUser.loadHttp = false;
                        },
                        builder: (_) => Text(
                          "${_.userAccount.userName ?? ''}",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 14,
          ),
          //_verToken(),
          // SizedBox(height: 14,),
          //_open(),
          // SizedBox(
          //   height: 14,
          // ),
          //_open2(context),
          _comandosBotton(),
          //SizedBox(height: double.infinity,),
        ],
      ),
    );
  }

  Widget _iconUser(){
    
    return GetX<UserController>(
      builder: (_){
        return _.userAccount.blocked ?? true
            ? Icon(
                FontAwesomeIcons.userLock,
                color: Colors.red[900],
              )
            : Icon(
                  FontAwesomeIcons.userCheck,
                  color: Colors.lightBlue[900],
              );
      },
    );
  }

  Widget _comandosBotton(){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              children: [
                _abrirPorton(),
                Text('Abrir Portón', style: TextStyle(fontSize: 22),),
              ],
            ),
            Column(
              children: [
                _cerrarPorton(),
                Text('Cerrar Portón', style: TextStyle(fontSize: 22),),
              ],
            ),
          ],
        ),
        SizedBox(height: 20,),
        Column(
          children: [
            _statusPorton(),
            Text('Estatus del Portón', style: TextStyle(fontSize: 22),),
          ],
        ),
        
      ],
    );
  }

  Widget _statusPorton(){
    return ClipOval(
      child: Material(
        color: Colors.lightBlue[700],
        child: InkWell(
          child: SizedBox(
            width: 100,
            height: 100,
            child: Icon(
                FontAwesomeIcons.question,
                color: Colors.white,
                size: 50,
              ),
          ),
          onTap: (){
            Vibration.vibrate(duration: 40);
            _scanStatusPorton();
          },
        ),
      ),
    );
  }

  Widget _abrirPorton(){
    return ClipOval(
      child: Material(
        color: Colors.lightGreen[700],
        child: InkWell(
          child: SizedBox(
            width: 100,
            height: 100,
            child: Icon(
                Icons.lock_open,
                color: Colors.white,
                size: 50,
              ),
          ),
          onTap: (){
            Vibration.vibrate(duration: 40);
            _openPorton();
          },
        ),
      ),
    );
  }

  Widget _cerrarPorton(){
    return ClipOval(
      child: Material(
        color: Colors.red[500],
        child: InkWell(
          child: SizedBox(
            width: 100,
            height: 100,
            child: Icon(
                Icons.lock,
                color: Colors.white,
                size: 50,
              ),
          ),
          onTap: (){
            Vibration.vibrate(duration: 40);
            _clousePorton();
          },
        ),
      ),
    );
  }

  _openPorton() async {
    //GetX<UserController>(builder: (_) { _.loadHttp = true});
    controllerUser.loadHttp = true;
    userNameApp = UserController.to.userAccount.userName;
    userIDApp = UserController.to.userAccount.userId;
    userLockedApp = UserController.to.userAccount.blocked;
    if(userNameApp.isNullOrBlank || userIDApp.isNullOrBlank){
      _snackBar('Datos de Usuario Nulos', 'Reicicie la App', Colors.red[700], 5);
      controllerUser.loadHttp = false;
      return;
    }
    if(userLockedApp){
       _snackBar('Usuario Bloqueado', 'Dirijase con el Administrador', Colors.red[700], 5);
       controllerUser.loadHttp = false;
       return;
    }
    await apiPorton(userN: userNameApp, userI: userIDApp, comando: 'openP')
      .then((value) {
          controllerUser.loadHttp = false;
          UserModelRequest resp = value;
          if(resp.code == 0){
            _snackBar('Comando Recibido:', 'El Porton se esta Abriendo', Colors.blue[700], 5);
          }else if(resp.code == 550){
            _snackBar('Comando Recibido:', 'El Porton ya esta Abriendo', Colors.blue[700], 5);
          }else if(resp.code == 551 || resp.code == 563){
            _snackBar('Comando Recibido:', 'El Porton se esta Abriendo/Cerrando', Colors.blue[700], 5);
          }else if(resp.code == 501){
            _snackBar('Usuario Bloqueado', 'Dirijase con el Administrador', Colors.red[700], 5);
          }else if(resp.code == -1){
            _snackBar('Error', 'Equipo no Responde', Colors.red[700], 5);
          }
        }
      );
  }

  _clousePorton() async {
    controllerUser.loadHttp = true;
    userNameApp = UserController.to.userAccount.userName;
    userIDApp = UserController.to.userAccount.userId;
    userLockedApp = UserController.to.userAccount.blocked;
    if(userNameApp.isNullOrBlank || userIDApp.isNullOrBlank){
      _snackBar('Datos de Usuario Nulos', 'Reicicie la App', Colors.red[700], 5);
      controllerUser.loadHttp = false;
      return;
    }
    if(userLockedApp){
       _snackBar('Usuario Bloqueado', 'Dirijase con el Administrador', Colors.red[700], 5);
       controllerUser.loadHttp = false;
       return;
    }
    await apiPorton(userN: userNameApp, userI: userIDApp, comando: 'clouseP')
      .then((value) {
          controllerUser.loadHttp = false;
          UserModelRequest resp = value;
          if(resp.code == 0){
            _snackBar('Comando Recibido:', 'El Porton se esta Cerrando', Colors.blue[700], 5);
          }else if(resp.code == 550){
            _snackBar('Comando Recibido:', 'El Porton ya esta Cerrado', Colors.blue[700], 5);
          }else if(resp.code == 551 || resp.code == 563){
            _snackBar('Comando Recibido:', 'El Porton se esta Abriendo/Cerrando', Colors.blue[700], 5);
          }else if(resp.code == 501){
            _snackBar('Usuario Bloqueado', 'Dirijase con el Administrador', Colors.red[700], 5);
          }else if(resp.code == -1){
            _snackBar('Error', 'Equipo no Responde', Colors.red[700], 5);
          }
        }
      );
  }

  _scanStatusPorton() async {
    // String nameUser = controllerUser.userAccount.userName;
    // int idUser = controllerUser.userAccount.userId;
    userNameApp = UserController.to.userAccount.userName;
    userIDApp = UserController.to.userAccount.userId;
    userLockedApp = UserController.to.userAccount.blocked;
    print('Nombre de Usuario: $userNameApp');
    print('ID de Usuario: $userIDApp');
    controllerUser.loadHttp = true;
    if(userNameApp.isNullOrBlank || userIDApp.isNullOrBlank){
      _snackBar('Datos de Usuario Nulos', 'Reicicie la App', Colors.red[700], 5);
      controllerUser.loadHttp = false;
      return;
    }
    if(userLockedApp){
       _snackBar('Usuario Bloqueado', 'Dirijase con el Administrador', Colors.red[700], 5);
       controllerUser.loadHttp = false;
       return;
    }
    await apiPorton(userN: userNameApp, userI: userIDApp, comando: 'statusP')
      .then((value) {
          controllerUser.loadHttp = false;
          UserModelRequest resp = value;
          if(resp.code == 560){
            _snackBar('Estado Porton:', 'Porton Cerrado', Colors.blue[700], 5);
          }else if(resp.code == 561){
            _snackBar('Estado Porton:', 'Porton Abierto', Colors.blue[700], 5);
          }else if(resp.code == 562 || resp.code == 563){
            _snackBar('Estado Porton:', 'Porton Entre Abierto', Colors.blue[700], 5);
          }else if(resp.code == 501){
            _snackBar('Usuario Bloqueado', 'Dirijase con el Administrador', Colors.red[700], 5);
          }else if(resp.code == -1){
            _snackBar('Error', 'Equipo no Responde', Colors.red[700], 5);
          }
        }
      );
  }


  _snackBar(String title, String msg, Color color, int time){
    Get.snackbar(
      title,
      msg,
      backgroundColor: color,
      colorText: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 50,),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(25),
      //icon: Icon(Icons.check, color: Colors.black45, size: 21),
      mainButton: FlatButton(
        color: Colors.white,
        shape: CircleBorder(),
        onPressed: ()=>Get.back(), 
        child: Text('OK', style: TextStyle(color: color),)
      ),
      duration: Duration(seconds: time),
    );
  }


}