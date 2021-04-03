//import 'dart:io';


import 'package:control_porton/src/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
//import 'package:residential_access/src/controller/user_controller.dart';
import 'package:vibration/vibration.dart';

class MenuWidget extends StatelessWidget {
  //const MenuWidget({Key key}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;
  //final UserController controllerUser = Get.find();// UserController();
  //final UserController controllerUser = Get.put(UserController());
  MenuWidget({this.scaffoldKey, 
  });

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final UserController controllerUser = Get.find();
    //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    //_token = controllerToken.token.access;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              children: <Widget>[
                Icon(Icons.account_circle,color: Colors.white, size: 70,),
                Obx(()=> Text('${UserController.to.userAccount.userName}', style: TextStyle(color: Colors.white, fontSize: 30.0),)), //Text('${userAccount.firstName?? ''} ${userAccount.lastName?? ''}'), 
                //Obx(()=> UserController.to.userAccount.userId == 0 ? Text('') : Text(UserController.to.userAccount.userId.toString(), style: TextStyle(color: Colors.white),) ), //userAccount.nums.isNotEmpty ? Text('${userAccount.nums[0].number?? ''}') : Container(),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.info,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),

          ),
          Divider(thickness: 2,),
          ListTile(
            leading: Icon(
              Icons.account_circle,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Info Usuario', style: TextStyle(fontSize: 18)),
            onTap: (){
              Vibration.vibrate(duration: 40);

              //Navigator.pushNamed(context, 'user', arguments: userAccount);
              //Navigator.pop(context);
              //Get.back();
              Get.toNamed('/user').then((value) => Get.back());
              //Get.back();
            },
          ),
          Divider(thickness: 2,),
          ListTile(
            leading: Icon(
              Icons.settings,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Configuración', style: TextStyle(fontSize: 18)),
            onTap: (){
              Vibration.vibrate(duration: 40);
              if(controllerUser.userAccount.id == 0){
                Get.toNamed('/config').then((value) => Get.back());
              }else{
                _snackBar('Acceso no permitido', 'No tiene permiso de Administrador', Colors.red[700], 5);
              }
              //Get.back();
            },
          ),
          Divider(thickness: 2,),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Cerrar Sesión', style: TextStyle(fontSize: 18)),
            onTap: (){
              Vibration.vibrate(duration: 40);
              box.write('passw', '');
              //Navigator.pop(context);
              SystemNavigator.pop();
              //exit(0);
            },
          ),
          Divider(thickness: 2,),
          SizedBox(height: 20.0,),
          ListTile(
            leading: Icon(
              Icons.close,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Cerrar Menu', style: TextStyle(fontSize: 18)),
            onTap: (){
              Vibration.vibrate(duration: 40);
              Get.back();
            },
          ),
          Divider(thickness: 2,),
        ],
      ),
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
