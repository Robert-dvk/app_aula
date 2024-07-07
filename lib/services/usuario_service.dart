import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_aula/models/usuario.dart';
import 'package:app_aula/services/abstract_service.dart';

class UsuarioService extends AbstractService {
   Future<Usuario?> getData(String token) async {
    final response = await http.get(
      Uri.parse('$apiRest/usuarios/data'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Usuario.fromJson(jsonData['usuario']);
    } else {
      throw Exception('Falha ao carregar dados do usuário');
    }
  }

   Future<Map<String, dynamic>> updateUser(int id, String token, Map<String, dynamic> userData) async {
    final Uri uri = Uri.parse('$apiRest/usuarios/$id');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return {
          'status': 'success',
          'message': 'Usuário atualizado com sucesso',
          'usuario': Usuario.fromJson(jsonData['usuario']),
        };
      } else {
        return {
          'status': 'error',
          'message': 'Erro ao atualizar usuário: ${response.reasonPhrase}',
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Erro ao conectar ao servidor: $e',
      };
    }
  }
}
