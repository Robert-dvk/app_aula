import 'package:app_aula/database/database.dart';
import 'package:app_aula/models/pet.dart';

class PetRepository {
  final DatabaseService _databaseService = DatabaseService.instance;

  Future<int> createPet(Pet pet) async {
  final db = await _databaseService.database;
  return await db!.insert('pets', pet.toMap(withId: false));
}

  Future<List<Pet>> readPets() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db!.query('pets');

    return List.generate(maps.length, (i) {
      return Pet.fromMap(maps[i]);
    });
  }

  Future<int> updatePet(Pet pet) async {
    final db = await _databaseService.database;
    return await db!.update('pets', pet.toMap(), where: 'id = ?', whereArgs: [pet.id]);
  }

  Future<int> deletePet(int id) async {
    final db = await _databaseService.database;
    return await db!.delete('pets', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Pet>> readPetsByUser(int userId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'pets',
      where: 'idusuario = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return Pet.fromMap(maps[i]);
    });
  }
}
