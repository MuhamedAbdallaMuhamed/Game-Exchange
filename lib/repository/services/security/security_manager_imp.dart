import 'package:GM_Nav/repository/services/security/security_manager.dart';

class ISecurityManager implements SecurityManager {
  @override
  String encrypt(String data) {
    if (data == null) return '';
    String ret = "";
    for (int i = 0; i < data.length; i++) {
      ret += (String.fromCharCode(data[i].codeUnitAt(0) + 3));
    }
    return ret;
  }

  @override
  String decrypt(String data) {
    if (data == null) return '';
    String ret = "";
    for (int i = 0; i < data.length; i++) {
      ret += (String.fromCharCode(data[i].codeUnitAt(0) - 3));
    }
    return ret;
  }
}
