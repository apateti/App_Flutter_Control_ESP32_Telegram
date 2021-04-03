
import 'package:control_porton/src/controller/user_controller.dart';
import 'package:control_porton/src/pages/Configuration/list_user_config.dart';
import 'package:control_porton/src/pages/Configuration/reg_pend_Config.dart';
import 'package:control_porton/src/pages/Configuration/setup_init_page.dart';
import 'package:control_porton/src/pages/configure_page.dart';
import 'package:control_porton/src/pages/home_page.dart';
import 'package:control_porton/src/pages/login_page.dart';
import 'package:control_porton/src/pages/user_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
 
void main() async {
  await GetStorage.init();
  Get.put(UserController());
  runApp(GetMaterialApp(
    initialRoute: '/loging',
    theme: ThemeData(
      primaryColor: Colors.lightBlue[900],
    ),
    darkTheme: ThemeData.dark(),
    getPages: [
      GetPage(name: '/loging', 
        page: () => LoginPage(),
        transition: Transition.zoom),
      GetPage(name: '/home', 
        page: () => HomePage(),
        transition: Transition.zoom),
      GetPage(name: '/user',
        page: () => UserPage(),
        transition: Transition.zoom),
      GetPage(name: '/config',
        page: () => ConfigurePage(),
        transition: Transition.zoom),
      GetPage(name: '/userList',
        page: () => ListUserConfig(),
        transition: Transition.zoom),
      GetPage(name: '/regPend',
        page: () => RegPendConfig(),
        transition: Transition.zoom),
    GetPage(name: '/setup',
        page: () => SetupInitPage(),
        transition: Transition.zoom),
    ],
  ));
}
 
