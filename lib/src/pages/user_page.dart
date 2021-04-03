import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:control_porton/src/controller/user_controller.dart';


class UserPage extends StatelessWidget {
  //const UserPage({Key key}) : super(key: key);
  //final UserController controllerUser = Get.put(UserController());
  //final UserController c = Get.find();
  // String _userNameApp = '';
  // int _userIDApp = 0;
  // bool _userLockedApp = false;
  @override
  Widget build(BuildContext context) {
    // _userNameApp = controllerUser.userAccount.userName;
    // _userIDApp = controllerUser.userAccount.userId;
    // _userLockedApp = controllerUser.userAccount.blocked;
    // print('UserName: $_userNameApp');
    // print('UserID: $_userIDApp');
    // print('UserLock: $_userLockedApp');
    return GetBuilder<UserController>(
          builder: (_) => Scaffold(
        backgroundColor: Color.fromARGB(224, 255, 255, 224),
        appBar: AppBar(
          title: Obx(()=> Text("Info de: ${_.userAccount.userName ?? ''}")),
          // GetBuilder<UserController>(
          //   //init: UserController(),
          //   //init: controllerUser,
          //   builder: (_) => Text("Info de: ${_.userAccount.userName ?? ''}"),
          //   //Obx
          // ),
        ),
        // appBar: AppBar(
        //   title: Obx(() => Text('Info de: ${controllerUser.userAccount.userName}')),
        // ),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 30.0),
              width: Get.width * 0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow:  <BoxShadow> [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 5.0),
                    spreadRadius: 3.0,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:  <Widget>[
                  SizedBox(height: 12,),
                  Text(
                    'Datos de su Cuenta',
                    style: TextStyle(fontSize: 30),
                  ),
                  Divider(
                    thickness: 10,
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                  ),
                  SizedBox(height: 12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 20),
                      Icon(
                        Icons.account_circle,
                        color: Theme.of(context).primaryColor,
                        size: 40.0,
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            GetX<UserController>(
                              builder: (_) => (_
                                .userAccount.userName.isNullOrBlank
                                ? Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: SizedBox(
                                        width: double.maxFinite,
                                        child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: Text(
                                              'Nombre no Registrado',
                                              style:
                                                  TextStyle(color: Colors.pink),
                                            )),
                                      ),
                                    )
                                : Obx(() => Text(
                                  '${_.userAccount.userName}',
                                  style: TextStyle(fontSize: 25),
                                ),)
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: Theme.of(context).primaryColor.withOpacity(0.7),
                            ),
                            GetX<UserController>(
                              builder: (_) {
                                print('UserID: ${_.userAccount.id}');
                                return _.userAccount.userId.isNullOrBlank
                                  ? Text('')
                                  : (_.userAccount.id == 0
                                    ? Text(
                                        'Es Administrador',
                                        style: TextStyle(fontSize: 25),
                                      )
                                    : Text(
                                        'Es Usuari@',
                                        style: TextStyle(fontSize: 25),
                                    ));
                              },
                            ),
                            Divider(
                              thickness: 1,
                              color: Theme.of(context).primaryColor.withOpacity(0.7),
                            ),
                            GetX<UserController>(
                              builder: (_) {
                                return _.userAccount.blocked.isNullOrBlank
                                ? Text('')
                                : _.userAccount.blocked
                                  ? Text(
                                        'Esta Bloquead@',
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.pink),
                                      )
                                    : Text(
                                        'Esta Activ@',
                                        style: TextStyle(fontSize: 25),
                                    );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}