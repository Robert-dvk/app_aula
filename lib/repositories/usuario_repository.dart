import 'package:app_aula/database/database.dart';
import 'package:app_aula/models/usuario.dart';

class UsuarioRepository {
  final DatabaseService _databaseService = DatabaseService.instance;

  Future<int> createUser(Usuario user) async {
    final db = await _databaseService.database;
    return await db!.insert('usuarios', user.toMap());
  }

  Future<List<Usuario>> readUsers() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db!.query('usuarios');

    return List.generate(maps.length, (i) {
      return Usuario.fromJson(maps[i]);
    });
  }

  Future<int> updateUser(Usuario user) async {
    final db = await _databaseService.database;
    return await db!.update('usuarios', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> deleteUser(int id) async {
    final db = await _databaseService.database;
    return await db!.delete('usuarios', where: 'id = ?', whereArgs: [id]);
  }

  Future<Usuario?> loginUser(String login, String senha) async {
    final db = await _databaseService.database;
    List<Map<String, dynamic>> results = await db!.query(
      'usuarios',
      where: 'login = ? AND senha = ?',
      whereArgs: [login, senha],
    );

    if (results.isNotEmpty) {
      return Usuario.fromJson(results.first);
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUser(String username, String password) async {
    final db = await _databaseService.database;
    List<Map<String, dynamic>> result = await db!.query(
      'usuarios',
      where: 'login = ? AND senha = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<Usuario?> getUserById(int id) async {
    final db = await _databaseService.database;
    List<Map<String, dynamic>> results = await db!.query(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return Usuario.fromJson(results.first);
    } else {
      return null;
    }
  }
}
