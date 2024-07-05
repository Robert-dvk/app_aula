import 'package:app_aula/database/database.dart';
import 'package:app_aula/models/servico.dart';

class ServicoRepository {
  final DatabaseService _databaseService = DatabaseService.instance;

  Future<List<Servico>> readServicos() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db!.query('servicos');

    return List.generate(maps.length, (i) {
      return Servico.fromMap(maps[i]);
    });
  }
}
