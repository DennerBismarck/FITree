import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'fitree.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabela de usuários
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        senha TEXT NOT NULL
      )
    ''');

    // Tabela de alimentos
    await db.execute('''
      CREATE TABLE alimentos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        calorias REAL NOT NULL,
        carboidratos REAL NOT NULL,
        proteinas REAL NOT NULL,
        gorduras REAL NOT NULL,
        fonte TEXT NOT NULL,
        fdc_id TEXT,
        created_at TEXT NOT NULL,
        usuario_id INTEGER,
        FOREIGN KEY (usuario_id) REFERENCES usuarios (id)
      )
    ''');

    // Tabela de exercícios
    await db.execute('''
      CREATE TABLE exercicios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        tipo TEXT NOT NULL,
        musculo TEXT NOT NULL,
        equipamento TEXT,
        dificuldade TEXT NOT NULL,
        instrucoes TEXT NOT NULL,
        fonte TEXT NOT NULL,
        created_at TEXT NOT NULL,
        usuario_id INTEGER,
        FOREIGN KEY (usuario_id) REFERENCES usuarios (id)
      )
    ''');

    // Tabela de refeições do usuário
    await db.execute('''
      CREATE TABLE refeicoes_usuario (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        refeicao TEXT NOT NULL,
        data TEXT NOT NULL,
        completo INTEGER NOT NULL DEFAULT 0,
        calorias_totais REAL NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        usuario_id INTEGER,
        FOREIGN KEY (usuario_id) REFERENCES usuarios (id)
      )
    ''');

    // Tabela de alimentos nas refeições
    await db.execute('''
      CREATE TABLE alimentos_refeicao (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        refeicao_id INTEGER NOT NULL,
        alimento_id INTEGER NOT NULL,
        quantidade REAL NOT NULL DEFAULT 1,
        FOREIGN KEY (refeicao_id) REFERENCES refeicoes_usuario (id),
        FOREIGN KEY (alimento_id) REFERENCES alimentos (id)
      )
    ''');

    // Tabela de treinos do usuário
    await db.execute('''
      CREATE TABLE treinos_usuario (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        data TEXT NOT NULL,
        completo INTEGER NOT NULL DEFAULT 0,
        duracao_minutos INTEGER,
        created_at TEXT NOT NULL,
        usuario_id INTEGER,
        FOREIGN KEY (usuario_id) REFERENCES usuarios (id)
      )
    ''');

    // Tabela de exercícios nos treinos
    await db.execute('''
      CREATE TABLE exercicios_treino (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        treino_id INTEGER NOT NULL,
        exercicio_id INTEGER NOT NULL,
        series INTEGER,
        repeticoes INTEGER,
        peso REAL,
        tempo_segundos INTEGER,
        FOREIGN KEY (treino_id) REFERENCES treinos_usuario (id),
        FOREIGN KEY (exercicio_id) REFERENCES exercicios (id)
      )
    ''');
  }

  // Métodos para usuários
  Future<int> insertUsuario(Map<String, dynamic> usuario) async {
    final db = await database;
    return await db.insert('usuarios', usuario);
  }

  Future<Map<String, dynamic>?> getUsuarioByEmail(String email) async {
    final db = await database;
    final result = await db.query('usuarios', where: 'email = ?', whereArgs: [email]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getUsuarioById(int id) async {
    final db = await database;
    final result = await db.query('usuarios', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String,dynamic>?>getUsuarioByEmailAndPassword(String email, String senha) async {
    final db = await database;
    final result = await db.query(
      'usuarios',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getUsuarios() async {
    final db = await database;
    return await db.query('usuarios', orderBy: 'nome ASC');
  }

  // Métodos para alimentos
  Future<int> insertAlimento(Map<String, dynamic> alimento) async {
    final db = await database;
    alimento['created_at'] = DateTime.now().toIso8601String();
    return await db.insert('alimentos', alimento);
  }

  Future<List<Map<String, dynamic>>> getAlimentos({int? usuarioId}) async {
    final db = await database;
    if (usuarioId != null) {
      return await db.query('alimentos', where: 'usuario_id = ?', whereArgs: [usuarioId], orderBy: 'nome ASC');
    }
    return await db.query('alimentos', orderBy: 'nome ASC');
  }

  Future<Map<String, dynamic>?> getAlimentoById(int id) async {
    final db = await database;
    final result = await db.query('alimentos', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> searchAlimentos(String query, {int? usuarioId}) async {
    final db = await database;
    if (usuarioId != null) {
      return await db.query(
        'alimentos',
        where: 'nome LIKE ? AND usuario_id = ?',
        whereArgs: ['%$query%', usuarioId],
        orderBy: 'nome ASC',
      );
    }
    return await db.query(
      'alimentos',
      where: 'nome LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'nome ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getRefeicoesByDataUsuario(String data, int usuarioId) async {
    final db = await database;
    return await db.query(
      'refeicoes_usuario',
      where: 'data = ? AND usuario_id = ?',
      whereArgs: [data, usuarioId],
      orderBy: 'created_at ASC',
    );
  }

  // Métodos para exercícios
  Future<int> insertExercicio(Map<String, dynamic> exercicio) async {
    final db = await database;
    exercicio['created_at'] = DateTime.now().toIso8601String();
    return await db.insert('exercicios', exercicio);
  }

  Future<List<Map<String, dynamic>>> getExercicios({int? usuarioId}) async {
    final db = await database;
    if (usuarioId != null) {
      return await db.query('exercicios', where: 'usuario_id = ?', whereArgs: [usuarioId], orderBy: 'nome ASC');
    }
    return await db.query('exercicios', orderBy: 'nome ASC');
  }

  Future<List<Map<String, dynamic>>> getExerciciosByMusculo(String musculo, {int? usuarioId}) async {
    final db = await database;
    if (usuarioId != null) {
      return await db.query(
        'exercicios',
        where: 'musculo = ? AND usuario_id = ?',
        whereArgs: [musculo, usuarioId],
        orderBy: 'nome ASC',
      );
    }
    return await db.query(
      'exercicios',
      where: 'musculo = ?',
      whereArgs: [musculo],
      orderBy: 'nome ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getTreinosByDataUsuario(String data, int usuarioId) async {
    final db = await database;
    return await db.query(
      'treinos_usuario',
      where: 'data = ? AND usuario_id = ?',
      whereArgs: [data, usuarioId],
      orderBy: 'created_at ASC',
    );
  }
  Future<List<Map<String, dynamic>>> searchExercicios(String query, {int? usuarioId}) async {
    final db = await database;
    if (usuarioId != null) {
      return await db.query(
        'exercicios',
        where: '(nome LIKE ? OR musculo LIKE ?) AND usuario_id = ?',
        whereArgs: ['%$query%', '%$query%', usuarioId],
        orderBy: 'nome ASC',
      );
    }
    return await db.query(
      'exercicios',
      where: 'nome LIKE ? OR musculo LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'nome ASC',
    );
  }

  // Métodos para refeições do usuário
  Future<int> insertRefeicaoUsuario(Map<String, dynamic> refeicao) async {
    final db = await database;
    refeicao['created_at'] = DateTime.now().toIso8601String();
    return await db.insert('refeicoes_usuario', refeicao);
  }

  Future<List<Map<String, dynamic>>> getRefeicoesByData(String data, {int? usuarioId}) async {
    final db = await database;
    if (usuarioId != null) {
      return await db.query(
        'refeicoes_usuario',
        where: 'data = ? AND usuario_id = ?',
        whereArgs: [data, usuarioId],
        orderBy: 'created_at ASC',
      );
    }
    return await db.query(
      'refeicoes_usuario',
      where: 'data = ?',
      whereArgs: [data],
      orderBy: 'created_at ASC',
    );
  }

  Future<void> updateRefeicaoCompleta(int id, bool completo) async {
    final db = await database;
    await db.update(
      'refeicoes_usuario',
      {'completo': completo ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos para alimentos nas refeições
  Future<int> insertAlimentoRefeicao(Map<String, dynamic> alimentoRefeicao) async {
    final db = await database;
    return await db.insert('alimentos_refeicao', alimentoRefeicao);
  }

  Future<List<Map<String, dynamic>>> getAlimentosRefeicao(int refeicaoId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT ar.*, a.nome, a.calorias, a.carboidratos, a.proteinas, a.gorduras
      FROM alimentos_refeicao ar
      JOIN alimentos a ON ar.alimento_id = a.id
      WHERE ar.refeicao_id = ?
    ''', [refeicaoId]);
  }

  // Métodos para treinos do usuário
  Future<int> insertTreinoUsuario(Map<String, dynamic> treino) async {
    final db = await database;
    treino['created_at'] = DateTime.now().toIso8601String();
    return await db.insert('treinos_usuario', treino);
  }

  Future<List<Map<String, dynamic>>> getTreinosByData(String data, {int? usuarioId}) async {
    final db = await database;
    if (usuarioId != null) {
      return await db.query(
        'treinos_usuario',
        where: 'data = ? AND usuario_id = ?',
        whereArgs: [data, usuarioId],
        orderBy: 'created_at ASC',
      );
    }
    return await db.query(
      'treinos_usuario',
      where: 'data = ?',
      whereArgs: [data],
      orderBy: 'created_at ASC',
    );
  }

  Future<void> updateTreinoCompleto(int id, bool completo) async {
    final db = await database;
    await db.update(
      'treinos_usuario',
      {'completo': completo ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos para exercícios nos treinos
  Future<int> insertExercicioTreino(Map<String, dynamic> exercicioTreino) async {
    final db = await database;
    return await db.insert('exercicios_treino', exercicioTreino);
  }

  Future<List<Map<String, dynamic>>> getExerciciosTreino(int treinoId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT et.*, e.nome, e.tipo, e.musculo, e.equipamento, e.dificuldade, e.instrucoes
      FROM exercicios_treino et
      JOIN exercicios e ON et.exercicio_id = e.id
      WHERE et.treino_id = ?
    ''', [treinoId]);
  }

  // Método para limpar cache antigo (opcional)
  Future<void> clearOldCache() async {
    final db = await database;
    final oneWeekAgo = DateTime.now().subtract(const Duration(days: 7)).toIso8601String();
    
    await db.delete('alimentos', where: 'created_at < ?', whereArgs: [oneWeekAgo]);
    await db.delete('exercicios', where: 'created_at < ?', whereArgs: [oneWeekAgo]);
  }

  // Método para fechar o banco
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
