import 'package:control_porton/src/controller/user_controller.dart';
import 'package:control_porton/src/models/model_user_account.dart';
import 'package:control_porton/src/utils/api_login.dart';
//import 'package:control_porton/src/utils/api_porton.dart';
import 'package:control_porton/src/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:control_porton/src/controller/loging_controller.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vibration/vibration.dart';

class LoginPage extends StatelessWidget {
  //const LoginPage({Key key}) : super(key: key);
  final ControllerLoging controller = Get.put(ControllerLoging());
  final UserController controllerUser = Get.put(UserController());
  //final controllerUser = Get.find<UserController>();
  final _formKey = GlobalKey<FormState>();
  final _controllerUserName = TextEditingController();
  final _controllerUserID = TextEditingController();
  final _controllerServer = TextEditingController();
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return GetBuilder<ControllerLoging>(
        init: ControllerLoging(),
        builder: (_) {
          _controllerUserName.text = _.userName;
          _controllerUserID.text = _.userID.toString();
          return Scaffold(
            backgroundColor: Color.fromARGB(224, 255, 255, 224),
            body: Stack(
              children: <Widget>[
                _fondo1(),
                _loginFrom(),
                Positioned(
                  top: 60.0,
                  left: 0.0,
                  child: _setting(),
                ),
                // GetX<ControllerLoging>(
                //   builder: (_) => _.loadHttp ? LoadHttp() : Container(),
                // ),
                Obx(() => UserController.to.loadHttp ?  LoadHttp() : Container()),
              ],
            ),
          );
        });
  }

  Widget _fondo1() {
    final fondoH = Container(
      height: Get.height * 0.5,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color>[
          Color.fromRGBO(63, 63, 156, 1.0),
          Color.fromRGBO(90, 70, 178, 1.0),
        ]),
      ),
    );
    final iconUser = Container(
      padding: EdgeInsets.only(top: Get.height * 0.1),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.account_circle,
            color: Colors.white,
            size: 100,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'Cuenta Usuario',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ],
      ),
    );
    return Stack(
      children: <Widget>[
        fondoH,
        iconUser,
      ],
    );
  }

  Widget _loginFrom() {
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.only(bottom: 40),
      child: Center(
        child: Column(
          children: <Widget>[
            SafeArea(
              child: SizedBox(
                height: Get.height * 0.25,
              ),
              bottom: false,
            ),
            Container(
              //height: 200,
              width: Get.width * 0.85,
              //color: Colors.white,
              decoration: BoxDecoration(
                color: Colors.white,
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
                children: <Widget>[
                  SizedBox(height: 22),
                  Text(
                    'Ingrese',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 22),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _crearUser(),
                        SizedBox(
                          height: 22,
                        ),
                        _crearPassword(),
                        SizedBox(
                          height: 22,
                        ),
                        _crearBoton(),
                      ],
                    ),
                  ),
                  SizedBox(height: 22),
                  // GetX<ControllerLoging>(
                  //   init: ControllerLoging(),
                  //   initState: (_){_controllerUserName.text = controller.userName; _controllerUserID.text = controller.userID.toString();},
                  //   builder: (_) => Text('URL Server: ${_.urlServer}'),
                  // ),
                  Obx(() => Text(controllerUser.urlIPServer)),
                  SizedBox(height: 22),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _crearUser() {
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
          labelText: 'Introduzca el UserName',
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

  Widget _crearPassword() {
    Icon verPass = Icon(
      Icons.visibility,
      color: Colors.deepPurple,
    );
    Icon noVerPass = Icon(
      Icons.visibility_off,
      color: Colors.deepPurple,
    );
    return GetX<ControllerLoging>(
      builder: (_) => Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          controller: _controllerUserID,
          obscureText: _.seePass ?? false,
          decoration: InputDecoration(
            fillColor: Colors.black12,
            filled: true,
            contentPadding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 15.0),
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.deepPurple,
            ),
            suffix: IconButton(
                icon: _.seePass ?? false ? noVerPass : verPass,
                onPressed: () {
                  _.seePass = !_.seePass;
                }),
            // icon: Icon(
            //       Icons.account_box,
            //       color: Colors.deepPurple,
            //     ),
            hintText: "UserID",
            labelText: 'Introduzca su UserID',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
          validator: (passwLogin) {
            if (passwLogin.length < 9 || (int.tryParse(passwLogin) == null)) {
              return 'Debe introducir un UserID Valido';
            }
          },
        ),
      ),
    );
  }

  Widget _crearBoton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        //color: Color(0xff01A0C7),
        color: Color.fromRGBO(63, 63, 156, 0.8),
        child: MaterialButton(
          minWidth: Get.width,
          padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          child: Text('Login',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          onPressed: () {
            Vibration.vibrate(duration: 40);
            controller.seePass = true;
            if (_formKey.currentState.validate()) {
              _introLoging();
              //print('Validado');
            }
          },
        ),
      ),
    );
  }

  Widget _setting() {
    //Size size = MediaQuery.of(context).size;
    return RawMaterialButton(
      elevation: 2.0,
      fillColor: Color.fromRGBO(63, 63, 156, 0.8),
      child: Icon(
        Icons.settings,
        color: Colors.white,
        size: 40,
      ),
      //padding: EdgeInsets.only(left: 45, right: 60, top: 50, bottom: 50),
      shape: CircleBorder(),
      onPressed: () {
        Vibration.vibrate(duration: 40);
        //_requestUrl();
        Get.toNamed('/setup');
      },
    );
  }

  _requestUrl() {
    _controllerServer.text = ControllerLoging.to.urlServer;
    bool _validateUrl = false;
    Get.defaultDialog(
        title: 'Ingrese URL Server',
        //onConfirm: () {print("Ok"); Get.back();},
        //middleText: "Dialog made in 3 lines of code"
        content: TextFormField(
          controller: _controllerServer,
          decoration: InputDecoration(
            fillColor: Colors.black12,
            filled: true,
            contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            hintText: "Introduzca Direccion Web",
            errorText: _validateUrl ? 'URL invalido' : null,
            prefixIcon: Icon(
              Icons.http,
              color: Colors.deepPurple,
            ),
          ),
        ),
        buttonColor: Color.fromRGBO(63, 63, 156, 0.8),
        confirmTextColor: Colors.white,
        onConfirm: () {
          if (GetUtils.isURL(_controllerServer.text) ||
              GetUtils.isIPv4(_controllerServer.text)) {
            _validateUrl = false;
            box.write('urlServer', _controllerServer.text);
            ControllerLoging.to.urlServer = _controllerServer.text;
            //return _controllerServer.text;
            Get.back();
          } else {
            Get.back();
            _snackBar('Error', 'Debe Introducir una URL', Colors.red[700], 5);
          }
        });
  }

  _snackBar(String title, String msg, Color color, int time) {
    Get.snackbar(
      title,
      msg,
      backgroundColor: color,
      colorText: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 50,
      ),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(25),
      //icon: Icon(Icons.check, color: Colors.black45, size: 21),
      mainButton: FlatButton(
          color: Colors.white,
          shape: CircleBorder(),
          onPressed: () => Get.back(),
          child: Text(
            'OK',
            style: TextStyle(color: color),
          )),
      duration: Duration(seconds: time),
    );
  }

  _introLoging() async {
    // Get.dialog(mostrarLoad(),
    //   // Row(
    //   //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   //       children: <Widget>[
    //   //         CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),),
    //   //         Text(
    //   //           'Enviando...',
    //   //           style: TextStyle(fontSize: 20),
    //   //         ),
    //   //       ],
    //   //     )
    // );
    controllerUser.loadHttp = true;
    //await Future.delayed(Duration(seconds: 5));
    await apiLoging(
            userN: _controllerUserName.text,
            userI: int.parse(_controllerUserID.text))
        .then((value) {
      UserModelRequest resp = value;
      if (resp.code == 0) {
        controllerUser.userAccount = UserModel(
          id: resp.modelUser.id,
          userId: resp.modelUser.userId,
          userName: resp.modelUser.userName,
          blocked: resp.modelUser.blocked,
        );
        controllerUser.loadHttp = false;
        print('User Name: ${controllerUser.userAccount.userName}');
        print('User ID: ${controllerUser.userAccount.userId}');
        box.write('userName', controllerUser.userAccount.userName);
        box.write('userID', controllerUser.userAccount.userId);
        //controllerUser.loadHttp = true;
        Get.offAllNamed('/home');
      } else if (resp.code == 401) {
        print('Usuario o Clave Invalido');
        Get.back();
        _snackBar('Error', 'Usuario o Clave Invalida', Colors.red[700], 5);
      } else {
        print('Equipo no Responde');
        Get.back();
        _snackBar('Error', 'Equipo no Responde', Colors.red[700], 5);
      }
    });
    controllerUser.loadHttp = false;
    //Get.back();
  }
}
