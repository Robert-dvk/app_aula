import 'package:flutter/foundation.dart';
import 'package:app_aula/models/usuario.dart';

class UserProvider with ChangeNotifier {
  int _userId = -1;
  String _token = '';

  int get userId => _userId;
  String get token => _token;

  void setUserData(Usuario usuario, String token) {
    _userId = usuario.id ?? -1;
    _token = token;
    notifyListeners();
  }

  void setUserId(int id) {
    _userId = id;
    notifyListeners();
  }
}
