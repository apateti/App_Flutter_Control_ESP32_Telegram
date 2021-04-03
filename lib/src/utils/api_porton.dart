



import 'dart:convert';

//import 'package:control_porton/src/controller/loging_controller.dart';
import 'package:control_porton/src/controller/user_controller.dart';
import 'package:control_porton/src/models/model_user_account.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

final String _endPointJson = 'cmdoJson';
var resp;
Map<String, dynamic> data;
Map<String, dynamic> bodyJ;
//final ControllerLoging controller = Get.find();
//final UserController controllerUser = Get.find();
final UserController controllerUser = Get.put(UserController());
final box = GetStorage();
UserModelRequest userAcc;

Future<UserModelRequest> apiPorton({String userN, int userI, String comando}) async {
  data = {'userName':userN, 'userID':userI};
  bodyJ = {'cmdo':comando, 'data': data};
  String body = json.encode(bodyJ);
  // if(controllerUser.userAccount.blocked){
  //   print('Usuario Bloqueado');
  //   userAcc = UserModelRequest(
  //     code: -2,
  //     modelUser: null,
  //   );
  //   return (userAcc);
  //}
  String urlDns = box.read('urlServer');
  if(!GetUtils.isURL(urlDns) && !GetUtils.isIPv4(urlDns) && !GetUtils.isIPv6(urlDns)){
    print('URL no valido');
    userAcc = UserModelRequest(
      code: -3,
      modelUser: null,
    );
    return (userAcc);
  }
  //controllerUser.loadHttp = true;
  String urlTx = 'http://' + urlDns + '/' + _endPointJson;
  DateTime inicioTx = DateTime.now();
  try {
    resp = await http.post(
      urlTx,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    DateTime finTx = DateTime.now();
    //int requetstime = finTx.difference(inicioTx).inMilliseconds;
    //controller.timeRequest = requetstime;
    Map<String, dynamic> map = json.decode(resp.body);
    print(resp.body);
    print('Codigo de la Respuesta: ${resp.statusCode}');
    if(resp.statusCode == 200){
      userAcc = UserModelRequest(
        code: map['code'],
        // modelUser: UserModel(
        //   id: map['data']['regID']?? 0,
        //   userName: map['data']['userName']?? '',
        //   userId: map['data']['userId']?? 0,
        //   blocked: map['data']['userBlock']?? false,
        // ),
      );
    }
  } catch (e) {
    print(e);
    userAcc = UserModelRequest(
      code: -1,
      modelUser: null,
    );
  }
  //controller.loadHttp = false;
  return userAcc;
}