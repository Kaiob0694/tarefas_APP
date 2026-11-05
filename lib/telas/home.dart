import 'package:flutter/material.dart';

import '../database.dart';
import '../retro.dart';
import 'concluidas.dart';
import 'nova_tarefa.dart';

class TelaHome extends StatefulWidget {
  const TelaHome({super.key});

  @override
  State<TelaHome> createState() => _TelaHomeState();
}

class _TelaHomeState extends State<TelaHome> {
  List<Tarefa> _pendentes = [];
  int _totalConcluidas = 0;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final pendentes = await TarefaDb.instance.listar(concluidas: false);
    final concluidas = await TarefaDb.instance.contar(concluidas: true);
    if (!mounted) return;
    setState(() {
      _pendentes = pendentes;
      _totalConcluidas = concluidas;
      _carregando = false;
    });
  }

  Future<void> _abrir(Widget tela) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => tela));
    _carregar();
  }

  Future<void> _concluir(Tarefa t) async {
    await TarefaDb.instance.concluir(t.id!);
    _carregar();
  }

  Future<void> _excluir(Tarefa t) async {
    await TarefaDb.instance.excluir(t.id!);
    _carregar();
  }

  @override
  Widget build(BuildContext context) {
    final total = _pendentes.length + _totalConcluidas;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TextoRolando(
                  texto:
                      '*** Você é o visitante número 000001 *** Não esqueça de assinar o livro de visitas ***'),
              const SizedBox(height: 10),
              JanelaRetro(
                titulo: 'Resumo.exe',
                child: Column(
                  children: [
                    Text('Total de tarefas cadastradas:',
                        style: estiloTexto(negrito: true)),
                    const SizedBox(height: 8),
                    ContadorRetro(valor: total),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Pendentes: ${_pendentes.length}',
                            style: estiloTexto(
                                cor: Colors.red.shade800, negrito: true)),
                        Text('Concluídas: $_totalConcluidas',
                            style: estiloTexto(
                                cor: Colors.green.shade800, negrito: true)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: JanelaRetro(
                  titulo: 'Tarefas pendentes',
                  padding: const EdgeInsets.all(6),
                  expandir: true,
                  child: _listaPendentes(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BotaoRetro(
                    texto: '+ Nova tarefa',
                    onPressed: () => _abrir(const TelaNovaTarefa()),
                  ),
                  BotaoRetro(
                    texto: 'Concluídas ($_totalConcluidas)',
                    onPressed: () => _abrir(const TelaConcluidas()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listaPendentes() {
    if (_carregando) {
      return Center(child: Text('Carregando...', style: estiloTexto()));
    }
    if (_pendentes.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma tarefa pendente!\nClique em "Nova tarefa".',
          textAlign: TextAlign.center,
          style: estiloTexto(),
        ),
      );
    }
    return Container(
      decoration: decoracaoBisel(afundado: true, cor: Colors.white),
      child: ListView.separated(
        padding: const EdgeInsets.all(6),
        itemCount: _pendentes.length,
        separatorBuilder: (_, __) => const Divider(height: 10),
        itemBuilder: (context, i) {
          final t = _pendentes[i];
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.titulo, style: estiloTexto(negrito: true)),
                    Text(formatarData(t.criadaEm),
                        style: estiloTexto(
                            tamanho: 11, cor: corCinzaEscuro)),
                  ],
                ),
              ),
              BotaoRetro(
                  texto: 'Concluir',
                  compacto: true,
                  onPressed: () => _concluir(t)),
              const SizedBox(width: 4),
              BotaoRetro(
                  texto: 'X',
                  compacto: true,
                  onPressed: () => _excluir(t)),
            ],
          );
        },
      ),
    );
  }
}
