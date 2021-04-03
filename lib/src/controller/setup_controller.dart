


import 'package:get/get.dart';

class SetupController extends GetxController{

  static SetupController get to => Get.find();
  @override
  void onInit() {
    super.onInit();
    print('onInit de SetupController');
    _setupInicial();
  }
  _setupInicial(){
    _msgInicial.value = true;
    _verIpManual.value = false;
  }

  RxBool _msgInicial = false.obs;
  bool get msgInicial => this._msgInicial.value;
  set msgInicial(bool value) => this._msgInicial.value = value;

  RxBool _verIpManual = false.obs;
  bool get verIpManual => this._verIpManual.value;
  set verIpManual(bool value) => this._verIpManual.value = value;


}