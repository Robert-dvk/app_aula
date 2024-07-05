import 'package:app_aula/database/database.dart';
import 'package:app_aula/models/agenda.dart';

class AgendaRepository {
  final DatabaseService _databaseService = DatabaseService.instance;

  Future<int> createAgenda(Agenda agenda) async {
    final db = await _databaseService.database;
    return await db!.insert('agenda', agenda.toMap());
  }

  Future<List<Agenda>> readAgendas() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db!.query('agenda');

    return List.generate(maps.length, (i) {
      return Agenda.fromMap(maps[i]);
    });
  }

  Future<int> updateAgenda(Agenda agenda) async {
    final db = await _databaseService.database;
    return await db!.update('agenda', agenda.toMap(), where: 'id = ?', whereArgs: [agenda.id]);
  }

  Future<int> deleteAgenda(int id) async {
    final db = await _databaseService.database;
    return await db!.delete('agenda', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Agenda>> readAgendasByUser(int userId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'agenda',
      where: 'idusuario = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return Agenda.fromMap(maps[i]);
    });
  }
}
