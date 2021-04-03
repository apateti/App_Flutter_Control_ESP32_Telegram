import 'dart:convert';
import 'package:control_porton/src/controller/loging_controller.dart';
import 'package:control_porton/src/controller/user_controller.dart';
import 'package:control_porton/src/models/model_user_account.dart';
import 'package:control_porton/src/utils/api_porton.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

final String _endPointUser = 'cmdoJson';
var resp;
Map<String, dynamic> data;
Map<String, dynamic> bodyJ;
final ControllerLoging controller = Get.find();
final UserController controllerUser = Get.find();
final box = GetStorage();
UserModelRequest userAcc;

Future apiLoging({String userN, int userI}) async {
  data = {'userName':userN, 'userID':userI};
  bodyJ = {'cmdo':'credenU', 'data': data};
  String body = json.encode(bodyJ);
  String urlDns = controllerUser.urlIPServer;
  if(!GetUtils.isURL(urlDns) && !GetUtils.isIPv4(urlDns) && !GetUtils.isIPv6(urlDns)){
    print('URL no Valida');
    return;
  }
  String urlTx = 'http://' + urlDns + '/' + _endPointUser;
  print('URL a Tx: $urlTx');
  controllerUser.loadHttp = true;
  DateTime inicioTx = DateTime.now();
  try{
    resp = await http.post(
      urlTx,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    DateTime finTx = DateTime.now();
    int requetstime = finTx.difference(inicioTx).inMilliseconds;
    //controller.timeRequest = requetstime;
    Map<String, dynamic> map = json.decode(resp.body);
    print(resp.body);
    print('Codigo de la Respuesta: ${resp.statusCode}');
    if(resp.statusCode == 200){
      if (map['code'] == 0){
        userAcc = UserModelRequest(
          code: map['code'],
          modelUser: UserModel(
            id: map['data']['regID'],
            userName: map['data']['userName'],
            userId: map['data']['userId'],
            blocked: map['data']['userBlock'],
          ),
        );
        box.writeIfNull('userName',  map['userName']);
        box.writeIfNull('userID', map['userId']);
        if(userAcc.modelUser.blocked){
          print('Usuario Bloqueado: ${userAcc.modelUser.blocked}');

        }else{
          print('Usuario No Bloqueado: ${userAcc.modelUser.blocked}');
        }
      }else{
        userAcc = UserModelRequest(
          code: map['code'],
          modelUser: null,
        );
      }

    }

  }catch(e){
    print(e);
    userAcc = UserModelRequest(
      code: -1,
      modelUser: null,
    );
  }
  controllerUser.loadHttp = false;
  return userAcc;
}
