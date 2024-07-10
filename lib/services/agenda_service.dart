import 'dart:convert';
import 'package:app_aula/models/agenda.dart';
import 'package:http/http.dart' as http;

import 'abstract_service.dart';

class AgendaService extends AbstractService {
  Future<List<Map<String, dynamic>>> getAgendamentos(int userId, String token) async {
    final url = Uri.parse('$apiRest/agenda/listByUser');

    headers['Authorization'] = 'Bearer $token';

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('data') && data['data'] is List) {
          List<dynamic> agendamentosList = data['data'];
          List<Map<String, dynamic>> agendamentos =
              agendamentosList.map((item) => item as Map<String, dynamic>).toList();
          return agendamentos;
        } else {
          throw Exception('Formato de resposta inválido');
        }
      } else {
        throw Exception('Falha ao carregar agendamentos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro durante a requisição: $e');
    }
  }

  Future<int> createAgenda(Agenda agenda, int idServico, String token) async {
    final url = Uri.parse('$apiRest/agenda/create');

    headers['Authorization'] = 'Bearer $token';

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(agenda.toMap()),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return data['agendaId']; // Supondo que o ID retornado pela API esteja disponível como 'agendaId'
      } else {
        throw Exception('Falha ao criar agenda: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro durante a requisição: $e');
    }
  }

  Future<void> deleteAgenda(int id, String token) async {
    final url = Uri.parse('$apiRest/agenda/delete/$id');

    headers['Authorization'] = 'Bearer $token';

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode != 204) {
        throw Exception('Falha ao excluir agenda: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro durante a requisição: $e');
    }
  }
}
