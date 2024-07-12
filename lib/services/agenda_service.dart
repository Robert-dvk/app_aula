import 'dart:convert';
import 'package:app_aula/models/agenda.dart';
import 'package:http/http.dart' as http;

import 'abstract_service.dart';

class AgendaService extends AbstractService {
  Future<List<Map<String, dynamic>>> getAgendamentos(
      int userId, String token) async {
    final url = Uri.parse('$apiRest/agenda/listByUser');

    headers['Authorization'] = 'Bearer $token';

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('data') && data['data'] is List) {
          List<dynamic> agendamentosList = data['data'];
          List<Map<String, dynamic>> agendamentos = agendamentosList
              .map((item) => item as Map<String, dynamic>)
              .toList();
          return agendamentos;
        } else {
          throw Exception('Formato de resposta inválido');
        }
      } else {
        throw Exception(
            'Falha ao carregar agendamentos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro durante a requisição: $e');
    }
  }

  Future<int> createAgenda(
    Agenda agenda, int userId, int idpet, String token, int idServico) async {
    final url = Uri.parse('$apiRest/agenda/inserir');

    headers['Authorization'] = 'Bearer $token';
    try {
      final body = {
        'data': agenda.data,
        'hora': agenda.hora,
        'idusuario': userId,
        'idpet': idpet,
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('data')) {
          Map<String, dynamic> agendaData = data['data'];
          if (agendaData.containsKey('idagenda') && agendaData['idagenda'] is int) {
            await servicosAgenda(idServico, agendaData['idagenda']);
            return agendaData['idagenda'];
          } else {
            throw Exception('Resposta inválida do servidor');
          }
        } else {
          throw Exception('Resposta inválida do servidor: campo "data" não encontrado');
        }
      } else {
        throw Exception('Falha ao criar agenda: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro durante a requisição: $e');
    }
  }


  Future<void> servicosAgenda(int idServico, int idAgenda) async {
    final url = Uri.parse('$apiRest/agenda/inserirServicosAgenda');
    
    try {
      final body = {
        'idagenda': idAgenda,
        'idservico': idServico,
      };

      print('Body da requisição: $body');

      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('data')) {
          print("Serviços da agenda salvos com sucesso");
        } else {
          throw Exception(
              'Resposta inválida do servidor: campo "data" não encontrado');
        }
      } else {
        throw Exception('Falha ao criar agenda: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro durante a requisição: $e');
    }
  }

  Future<void> deleteAgenda(int id, String token) async {
    final url = Uri.parse('$apiRest/agenda/$id');

    headers['Authorization'] = 'Bearer $token';

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode != 200) {
        throw Exception('Falha ao excluir agenda: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro durante a requisição: $e');
    }
  }
}
