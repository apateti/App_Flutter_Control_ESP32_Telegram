


import 'package:control_porton/src/models/model_user_account.dart';
import 'package:get/get.dart';

class EditUserController extends GetxController{
  //final _textUserController = TextEditingController().obs
  static EditUserController get to => Get.find();

  Rx<UserModel> _userEdit = UserModel().obs;
  //UserModel _userEdit;
  UserModel get userEdit => this._userEdit.value;
  set userEdit(UserModel valor) => this._userEdit.value = valor;

  RxBool _userBlocked = true.obs;
  bool get userBlocked => this._userBlocked.value;
  set userBlocked(bool value) => this._userBlocked.value = value;


  // final _userAccount = UserModel().obs;
  // UserModel get userAccount => this._userAccount.value;
  // set userAccount(UserModel value) => this._userAccount.value = value;


  @override
  void onInit() {
    super.onInit();
    print('Argumentos: ${Get.arguments}');
    this._userEdit.value = Get.arguments as UserModel;
    update();
  }
}