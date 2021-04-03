import 'package:control_porton/src/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

class ConfigurePage extends StatelessWidget {
  //const ConfigurePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController controllerUser = Get.find();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 224),
      appBar: AppBar(
        title: Text('Configuración'),
      ),
      body: Column(
        // height: Get.height,
        // width: Get.width,
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints:
                    BoxConstraints.expand(height: Get.height - (12.0 * 8)),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  color: Colors.black12,
                  child: Column(
                    children: [
                      //Text('Prueba'),
                      _botonConfig(Icons.people, 'Lista de Usuarios', 20, Colors.blue, '/userList'),
                      SizedBox(height: 20),
                      _botonConfig(Icons.folder_shared, 'Registro Pendientes', 20, Colors.blue, '/regPend'),
                      SizedBox(height: 20),
                      _botonConfig(FontAwesomeIcons.telegramPlane, 'Bot Telegram', 20, Colors.blue, '/userList'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonConfig(
    IconData icono,
    String texto,
    double tamText,
    Color colorIcono,
    String pageConfig,
  ) {
    return RaisedButton(
        shape: StadiumBorder(),
        padding: EdgeInsets.all(12),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            SizedBox(width: 20),
            Icon(
              icono,
              color: colorIcono,
              size: 30,
            ),
            SizedBox(width: 20),
            Text(
              texto,
              style: TextStyle(fontSize: tamText),
            )
          ],
        ),
        onPressed: () {
          Vibration.vibrate(duration: 40);
          Get.toNamed(pageConfig);
          //enviarCodeIr(namTec, 'AC', infoControl, infoControl1, infoControl2,
          //    infoControl3);
        });
  }
}
