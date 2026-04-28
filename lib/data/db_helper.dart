import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  // Padrão Singleton para termos apenas uma instância do banco rodando
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

    // Abre o banco. Se não existir, chama o _createDB
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Cria uma tabela super simples só para guardar o número atômico
    await db.execute('''
    CREATE TABLE desbloqueados (
      numero INTEGER PRIMARY KEY
    )
    ''');
    await db.execute('''
    CREATE TABLE moleculas_desbloqueadas (
      id_molecula INTEGER PRIMARY KEY
    )
    ''');
    // Já insere o Hidrogênio (1) como padrão para o jogador não começar zerado
    await db.insert('desbloqueados', {
      'numero': 1,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  // --- FUNÇÕES DE SALVAR E LER ---

  Future<void> addDesbloqueado(int numero) async {
    final db = await instance.database;
    // O "ConflictAlgorithm.ignore" evita erro caso tente salvar um elemento que já foi salvo
    await db.insert('desbloqueados', {
      'numero': numero,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<int>> getDesbloqueados() async {
    final db = await instance.database;
    // Pega todos os registros da tabela
    final result = await db.query('desbloqueados');
    // Converte a lista de JSONs para uma lista de números inteiros
    return result.map((json) => json['numero'] as int).toList();
  }
}
// No db_helper.dart, dentro do _createDB:

// Adicione as funções de manipulação:
Future<void> addMolecula(int id) async {
  final db = await instance.database;
  await db.insert('moleculas_desbloqueadas', {
    'id_molecula': id,
  }, conflictAlgorithm: ConflictAlgorithm.ignore);
}

Future<List<int>> getMoleculas() async {
  final db = await instance.database;
  final result = await db.query('moleculas_desbloqueadas');
  return result.map((json) => json['id_molecula'] as int).toList();
}
