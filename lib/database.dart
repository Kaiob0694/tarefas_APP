import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Tarefa {
  final int? id;
  final String titulo;
  final bool concluida;
  final DateTime criadaEm;
  final DateTime? concluidaEm;

  Tarefa({
    this.id,
    required this.titulo,
    this.concluida = false,
    required this.criadaEm,
    this.concluidaEm,
  });

  factory Tarefa.fromMap(Map<String, Object?> m) => Tarefa(
        id: m['id'] as int,
        titulo: m['titulo'] as String,
        concluida: (m['concluida'] as int) == 1,
        criadaEm: DateTime.parse(m['criada_em'] as String),
        concluidaEm: m['concluida_em'] == null
            ? null
            : DateTime.parse(m['concluida_em'] as String),
      );
}

class TarefaDb {
  TarefaDb._();
  static final TarefaDb instance = TarefaDb._();

  Database? _db;

  Future<Database> get _banco async => _db ??= await _abrir();

  Future<Database> _abrir() async {
    final caminho = join(await getDatabasesPath(), 'tarefas2000.db');
    return openDatabase(
      caminho,
      version: 1,
      onCreate: (db, versao) => db.execute('''
        CREATE TABLE tarefas (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          titulo TEXT NOT NULL,
          concluida INTEGER NOT NULL DEFAULT 0,
          criada_em TEXT NOT NULL,
          concluida_em TEXT
        )
      '''),
    );
  }

  Future<int> inserir(String titulo) async {
    final db = await _banco;
    return db.insert('tarefas', {
      'titulo': titulo,
      'concluida': 0,
      'criada_em': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Tarefa>> listar({required bool concluidas}) async {
    final db = await _banco;
    final linhas = await db.query(
      'tarefas',
      where: 'concluida = ?',
      whereArgs: [concluidas ? 1 : 0],
      orderBy: concluidas ? 'concluida_em DESC' : 'criada_em DESC',
    );
    return linhas.map(Tarefa.fromMap).toList();
  }

  Future<int> contar({bool? concluidas}) async {
    final db = await _banco;
    final res = concluidas == null
        ? await db.rawQuery('SELECT COUNT(*) FROM tarefas')
        : await db.rawQuery('SELECT COUNT(*) FROM tarefas WHERE concluida = ?',
            [concluidas ? 1 : 0]);
    return Sqflite.firstIntValue(res) ?? 0;
  }

  Future<void> concluir(int id) async {
    final db = await _banco;
    await db.update(
      'tarefas',
      {'concluida': 1, 'concluida_em': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> reabrir(int id) async {
    final db = await _banco;
    await db.update(
      'tarefas',
      {'concluida': 0, 'concluida_em': null},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> excluir(int id) async {
    final db = await _banco;
    await db.delete('tarefas', where: 'id = ?', whereArgs: [id]);
  }
}
