import 'package:app_aula/database/database.dart';
import 'package:app_aula/models/servicos_agenda.dart';

class ServicoAgendaRepository {
  final DatabaseService _databaseService = DatabaseService.instance;

  Future<int> createServicoAgenda(ServicoAgenda servicoAgenda) async {
    final db = await _databaseService.database;
    return await db!.insert('servicosagenda', servicoAgenda.toMap());
  }

  Future<List<ServicoAgenda>> readServicosAgenda() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db!.query('servicosagenda');

    return List.generate(maps.length, (i) {
      return ServicoAgenda.fromMap(maps[i]);
    });
  }

  Future<int> updateServicoAgenda(ServicoAgenda servicoAgenda) async {
    final db = await _databaseService.database;
    return await db!.update('servicosagenda', servicoAgenda.toMap(), where: 'id = ?', whereArgs: [servicoAgenda.id]);
  }

  Future<int> deleteServicoAgenda(int id) async {
    final db = await _databaseService.database;
    return await db!.delete('servicosagenda', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<ServicoAgenda>> readServicosAgendaByAgenda(int agendaId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'servicosagenda',
      where: 'idagenda = ?',
      whereArgs: [agendaId],
    );

    return List.generate(maps.length, (i) {
      return ServicoAgenda.fromMap(maps[i]);
    });
  }

  Future<List<ServicoAgenda>> readServicosAgendaByServico(int servicoId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'servicosagenda',
      where: 'idservico = ?',
      whereArgs: [servicoId],
    );

    return List.generate(maps.length, (i) {
      return ServicoAgenda.fromMap(maps[i]);
    });
  }
}
