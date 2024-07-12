import 'dart:convert';
import 'package:http/http.dart' as http;
import 'abstract_service.dart';
import 'package:app_aula/models/servico.dart';

class ServicosService extends AbstractService {
  Future<List<Servico>> getServicos() async {
    final url = Uri.parse('$apiRest/servicos/listar');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      List<Servico> servicos = data.map((item) {
        if (item is Map<String, dynamic>) {
          return Servico.fromJson(item);
        } else {
          throw Exception('Formato de item inválido');
        }
      }).toList();
      return servicos;
    } else {
      throw Exception('Failed to load servicos');
    }
  }
}
