import 'package:flutter/foundation.dart';

import '../database/database_helper.dart';
import '../models/tarefa.dart';

/// Controla o estado das tarefas. As telas ouvem este controller
/// e se atualizam sozinhas quando algo muda.
class TarefaController extends ChangeNotifier {
  TarefaController._();
  static final TarefaController instance = TarefaController._();

  final DatabaseHelper _db = DatabaseHelper.instance;

  List<Tarefa> _pendentes = [];
  List<Tarefa> _concluidas = [];
  bool _carregando = true;

  List<Tarefa> get pendentes => _pendentes;
  List<Tarefa> get concluidas => _concluidas;
  bool get carregando => _carregando;
  int get total => _pendentes.length + _concluidas.length;

  Future<void> carregar() async {
    _pendentes = await _db.listar(concluidas: false);
    _concluidas = await _db.listar(concluidas: true);
    _carregando = false;
    notifyListeners();
  }

  Future<void> adicionar(String titulo) async {
    await _db.inserir(titulo);
    await carregar();
  }

  Future<void> concluir(Tarefa t) async {
    await _db.concluir(t.id!);
    await carregar();
  }

  Future<void> reabrir(Tarefa t) async {
    await _db.reabrir(t.id!);
    await carregar();
  }

  Future<void> excluir(Tarefa t) async {
    await _db.excluir(t.id!);
    await carregar();
  }
}
