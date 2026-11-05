import 'package:flutter/material.dart';

import '../controllers/tarefa_controller.dart';

class NovaTarefaView extends StatefulWidget {
  const NovaTarefaView({super.key});

  @override
  State<NovaTarefaView> createState() => _NovaTarefaViewState();
}

class _NovaTarefaViewState extends State<NovaTarefaView> {
  final _texto = TextEditingController();
  String? _erro;

  @override
  void dispose() {
    _texto.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    final titulo = _texto.text.trim();
    if (titulo.isEmpty) {
      setState(() => _erro = 'Digite o nome da tarefa.');
      return;
    }
    await TarefaController.instance.adicionar(titulo);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova tarefa')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _texto,
                    autofocus: true,
                    onSubmitted: (_) => _salvar(),
                    decoration: InputDecoration(
                      labelText: 'Nome da tarefa',
                      errorText: _erro,
                      filled: true,
                      fillColor: Colors.white,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _salvar,
                    child: const Text('Salvar'),
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
