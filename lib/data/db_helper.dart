import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._init();
  static Database? _database;

  DbHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('atomc_progresso.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE desbloqueados (
      numero INTEGER PRIMARY KEY
    )
    ''');

    // AQUI: Adicionamos a coluna "descricao"
    await db.execute('''
    CREATE TABLE moleculas_desbloqueadas (
      formula TEXT PRIMARY KEY,
      descricao TEXT
    )
    ''');

    await db.insert('desbloqueados', {
      'numero': 1,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> addDesbloqueado(int numero) async {
    final db = await instance.database;
    await db.insert('desbloqueados', {
      'numero': numero,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<int>> getDesbloqueados() async {
    final db = await instance.database;
    final result = await db.query('desbloqueados');
    return result.map((json) => json['numero'] as int).toList();
  }

  // --- FUNÇÕES DE MOLÉCULAS COM DESCRIÇÃO ---
  Future<void> addMolecula(String formula) async {
    final db = await instance.database;
    await db.insert('moleculas_desbloqueadas', {
      'formula': formula,
      'descricao': '', // Nasce vazia
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> atualizarDescricaoMolecula(
    String formula,
    String descricao,
  ) async {
    final db = await instance.database;
    await db.update(
      'moleculas_desbloqueadas',
      {'descricao': descricao},
      where: 'formula = ?',
      whereArgs: [formula],
    );
  }

  // Agora retorna um Map inteiro (com formula e descricao) em vez de só uma String
  Future<List<Map<String, dynamic>>> getMoleculas() async {
    final db = await instance.database;
    final result = await db.query('moleculas_desbloqueadas');
    // Transforma num formato que podemos editar na memória do app
    return result.map((e) => Map<String, dynamic>.from(e)).toList();
  }
}
