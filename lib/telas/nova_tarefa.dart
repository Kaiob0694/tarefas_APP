import 'package:flutter/material.dart';

import '../database.dart';
import '../retro.dart';

class TelaNovaTarefa extends StatefulWidget {
  const TelaNovaTarefa({super.key});

  @override
  State<TelaNovaTarefa> createState() => _TelaNovaTarefaState();
}

class _TelaNovaTarefaState extends State<TelaNovaTarefa> {
  final _controller = TextEditingController();
  String? _erro;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    final titulo = _controller.text.trim();
    if (titulo.isEmpty) {
      setState(() => _erro = 'Digite o nome da tarefa!');
      return;
    }
    await TarefaDb.instance.inserir(titulo);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: JanelaRetro(
              titulo: 'Nova tarefa',
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Nome da tarefa:', style: estiloTexto(negrito: true)),
                  const SizedBox(height: 6),
                  Container(
                    decoration:
                        decoracaoBisel(afundado: true, cor: Colors.white),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      style: estiloTexto(),
                      onSubmitted: (_) => _salvar(),
                      decoration: const InputDecoration(
                          border: InputBorder.none),
                    ),
                  ),
                  if (_erro != null) ...[
                    const SizedBox(height: 6),
                    TextoPiscando(
                      texto: _erro!,
                      estilo: estiloTexto(
                          cor: Colors.red, negrito: true, tamanho: 13),
                    ),
                  ],
                  const LinhaRetro(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BotaoRetro(texto: 'Salvar', onPressed: _salvar),
                      BotaoRetro(
                          texto: 'Cancelar',
                          onPressed: () => Navigator.of(context).pop()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
