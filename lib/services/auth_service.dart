import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_aula/services/abstract_service.dart';

class AuthService extends AbstractService {
  Future<Map<String, dynamic>> login(String login, String senha) async {
    final response = await http.post(
      Uri.parse('$apiRest/usuarios/login'),
      body: jsonEncode({'login': login, 'senha': senha}),
      headers: headers,
    );

    print(Uri.parse('$apiRest/usuarios/login'));

    print(response.statusCode);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return {
        'success': true,
        'usuario': data['usuario'],
        'token': data['token'],
      };
    } else {
      return {
        'success': false,
        'message': 'Falha ao realizar login',
      };
    }
  }
}
