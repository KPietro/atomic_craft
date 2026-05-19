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

    // AQUI: Adicionamos a coluna "estrutura" para salvar o JSON da geometria da molécula
    await db.execute('''
    CREATE TABLE moleculas_desbloqueadas (
      formula TEXT PRIMARY KEY,
      descricao TEXT,
      estrutura TEXT
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

  // --- FUNÇÕES DE MOLÉCULAS COM LAYOUT E DESCRIÇÃO ---
  Future<void> addMolecula(String formula, String estrutura) async {
    final db = await instance.database;
    await db.insert('moleculas_desbloqueadas', {
      'formula': formula,
      'descricao': '',
      'estrutura': estrutura, // Salva o esqueleto geométrico
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

  Future<List<Map<String, dynamic>>> getMoleculas() async {
    final db = await instance.database;
    final result = await db.query('moleculas_desbloqueadas');
    return result.map((e) => Map<String, dynamic>.from(e)).toList();
  }
}
