import 'package:flutter/material.dart';

import '../database.dart';
import '../retro.dart';

class TelaConcluidas extends StatefulWidget {
  const TelaConcluidas({super.key});

  @override
  State<TelaConcluidas> createState() => _TelaConcluidasState();
}

class _TelaConcluidasState extends State<TelaConcluidas> {
  List<Tarefa> _tarefas = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final lista = await TarefaDb.instance.listar(concluidas: true);
    if (!mounted) return;
    setState(() {
      _tarefas = lista;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: JanelaRetro(
                  titulo: 'Tarefas concluídas (${_tarefas.length})',
                  padding: const EdgeInsets.all(6),
                  expandir: true,
                  child: _lista(),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: BotaoRetro(
                  texto: '<< Voltar',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lista() {
    if (_carregando) {
      return Center(child: Text('Carregando...', style: estiloTexto()));
    }
    if (_tarefas.isEmpty) {
      return Center(
        child: Text('Nenhuma tarefa concluída ainda.',
            style: estiloTexto()),
      );
    }
    return Container(
      decoration: decoracaoBisel(afundado: true, cor: Colors.white),
      child: ListView.separated(
        padding: const EdgeInsets.all(6),
        itemCount: _tarefas.length,
        separatorBuilder: (_, __) => const Divider(height: 10),
        itemBuilder: (context, i) {
          final t = _tarefas[i];
          return Row(
            children: [
              const Icon(Icons.check_box, color: Color(0xFF006400)),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.titulo,
                      style: estiloTexto(negrito: true).copyWith(
                          decoration: TextDecoration.lineThrough),
                    ),
                    if (t.concluidaEm != null)
                      Text('Concluída em ${formatarData(t.concluidaEm!)}',
                          style: estiloTexto(
                              tamanho: 11, cor: corCinzaEscuro)),
                  ],
                ),
              ),
              BotaoRetro(
                texto: 'Reabrir',
                compacto: true,
                onPressed: () async {
                  await TarefaDb.instance.reabrir(t.id!);
                  _carregar();
                },
              ),
              const SizedBox(width: 4),
              BotaoRetro(
                texto: 'X',
                compacto: true,
                onPressed: () async {
                  await TarefaDb.instance.excluir(t.id!);
                  _carregar();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
