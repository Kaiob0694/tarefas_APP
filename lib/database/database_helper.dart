import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/tarefa.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

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

  Future<void> inserir(String titulo) async {
    final db = await _banco;
    await db.insert('tarefas', {
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
