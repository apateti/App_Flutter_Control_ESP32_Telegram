import 'package:control_porton/src/controller/setup_controller.dart';
import 'package:control_porton/src/controller/user_controller.dart';
import 'package:control_porton/src/pages/login_page.dart';
import 'package:control_porton/src/utils/api_porton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vibration/vibration.dart';

class SetupInitPage extends StatelessWidget {
  //const SetupInitPage({Key key}) : super(key: key);
  //final controllerSetup = Get.find<SetupController>();
  final _controllerIpServer = TextEditingController();
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetupController>(
      init: SetupController(),
      builder: (_) => Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 224),
        appBar: AppBar(
          title: Text('Configuración Inicial'),
        ),
        body: SingleChildScrollView(
          child: Container(
            // padding: EdgeInsets.symmetric(
            //   vertical: 12,
            //   horizontal: 30,
            // ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //_inicioConfig(),
                  _.msgInicial ? _verMsgInicial() : Container(),
                  //_.verIpManual ? _ipManual() : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _inicioConfig() {
  //   return GetBuilder<SetupController>(
  //     builder: (_) {
  //       return _.msgInicial ? _verMsgInicial() : Container();
  //     },
  //   );
  // }

  Widget _verMsgInicial() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 30),
          width: Get.width * 0.85, //size.width * 0.85,
          padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
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
              Text(
                'Configuracion del Equipo',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              Text(
                'La Configuración del equipo puede realizarce de dos formas: '
                '\n1.- Manual: El usuario introduce el Nombre del Control y la '
                'Direccion IP de manera Manual '
                '\n2.- Automático: La App de maner Automática puede configurar el '
                'Dispositivo Controlador. Para esto debe colocar el Dispositivo Controlador en modo Configuración. '
                'Esto se realiza manteniendo presionado el pulsador por lo menos 5 Segundos, '
                'cuando vea titilar el Led tres veces en dos segundo es que el Equipo '
                'esta em modo Configuracion, despues precione el Boton *Automatico* para '
                'para iniciar la configuracion Automatica.'
                '\nLuego debe esperar que el Equipo envie las Redes a las que pueda conectarse'
                ' Seleccione la misma que va a tener su movil, luego introduzca el password.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text('Manual'),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      Vibration.vibrate(duration: 40);
                      _getmanual();
                    },
                  ),
                  RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text('Automatico'),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      Vibration.vibrate(duration: 40);
                      //getWifi();
                      //_getHomeIoT();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  _getmanual(){
    // controllerSetup.msgInicial = false;
    // controllerSetup.verIpManual = true;
    _requestUrl();
  }

  _requestUrl(){
    _controllerIpServer.text = box.read('urlServer');
    bool _validateUrl = false;
    Get.defaultDialog(
      title: 'Ingrese URL Server',
      //onConfirm: () {print("Ok"); Get.back();},
      //middleText: "Dialog made in 3 lines of code"
      content: TextFormField(
        controller: _controllerIpServer,
        decoration: InputDecoration(
          fillColor: Colors.black12,
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          hintText: "Introduzca Direccion Web",
          errorText: _validateUrl ? 'URL invalido' : null,
          prefixIcon: Icon(Icons.http,
           color: Colors.deepPurple,),
        ),
      ),
      buttonColor: Color.fromRGBO(63, 63, 156, 0.8),
      confirmTextColor: Colors.white,
      onConfirm: (){
        if(GetUtils.isURL(_controllerIpServer.text) || GetUtils.isIPv4(_controllerIpServer.text)){
          _validateUrl = false;
          box.write('urlServer', _controllerIpServer.text);
          UserController.to.urlIPServer = _controllerIpServer.text;
          //ControllerLoging.to.urlServer = _controllerServer.text;
          //return _controllerServer.text;
          //Get.back();
          Get.offAll(LoginPage());
        }else{
          Get.back();
          _snackBar('Error', 'Debe Introducir una URL', Colors.red[700], 5);
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
