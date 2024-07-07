import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  DatabaseService._databaseService();

  static final DatabaseService instance = DatabaseService._databaseService();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'petshop.db'),
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_usuario);
    await db.execute(_pet);
    await db.execute(_servicos);
    await db.execute(_agenda);
    await db.execute(_servicosAgenda);
    await _insertInitialServicos(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE pets ADD COLUMN imagem TEXT;');
    }
  }

  String get _usuario => ''' 
    CREATE TABLE usuarios (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      telefone TEXT NOT NULL,
      login TEXT NOT NULL,
      senha TEXT NOT NULL,
      isadmin INTEGER NOT NULL
    ); 
  ''';

  String get _pet => ''' 
    CREATE TABLE pets (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      datanasc TEXT NOT NULL,
      sexo TEXT NOT NULL,
      peso REAL NOT NULL,
      porte TEXT NOT NULL,
      altura REAL NOT NULL,
      idusuario INTEGER NOT NULL,
      imagem TEXT,
      FOREIGN KEY (idusuario) REFERENCES usuarios(id)
    ); 
  ''';

  String get _servicos => ''' 
    CREATE TABLE servicos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      valor REAL NOT NULL
    ); 
  ''';

  String get _agenda => ''' 
    CREATE TABLE agenda (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      data TEXT NOT NULL,
      hora TEXT NOT NULL,
      idusuario INTEGER NOT NULL,
      idpet INTEGER NOT NULL,
      FOREIGN KEY (idusuario) REFERENCES usuarios(id),
      FOREIGN KEY (idpet) REFERENCES pets(id)
    ); 
  ''';

  String get _servicosAgenda => ''' 
    CREATE TABLE servicosagenda (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      idservico INTEGER NOT NULL,
      idagenda INTEGER NOT NULL,
      FOREIGN KEY (idservico) REFERENCES servicos(id),
      FOREIGN KEY (idagenda) REFERENCES agenda(id)
    ); 
  ''';

  Future<void> _insertInitialServicos(Database db) async {
    await db.insert('servicos', {'nome': 'Banho', 'valor': 50.0});
    await db.insert('servicos', {'nome': 'Tosa', 'valor': 30.0});
    await db.insert('servicos', {'nome': 'Consulta Veterinária', 'valor': 100.0});
    await db.insert('servicos', {'nome': 'Vacinação', 'valor': 75.0});
  }
}
