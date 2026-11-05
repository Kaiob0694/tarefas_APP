import 'package:flutter/material.dart';

import '../controllers/tarefa_controller.dart';
import 'concluidas_view.dart';
import 'nova_tarefa_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _controller = TarefaController.instance;

  @override
  void initState() {
    super.initState();
    _controller.carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas tarefas')),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _resumo(),
                  const SizedBox(height: 12),
                  Expanded(child: _lista()),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const NovaTarefaView()),
                          ),
                          child: const Text('Nova tarefa'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const ConcluidasView()),
                          ),
                          child: const Text('Concluídas'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _resumo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Text(
              'Total de tarefas: ${_controller.total}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Pendentes: ${_controller.pendentes.length}   '
              'Concluídas: ${_controller.concluidas.length}',
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lista() {
    if (_controller.carregando) {
      return const Center(child: CircularProgressIndicator());
    }
    final tarefas = _controller.pendentes;
    if (tarefas.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma tarefa pendente.',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }
    return ListView.separated(
      itemCount: tarefas.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final t = tarefas[i];
        return Card(
          child: ListTile(
            title: Text(t.titulo,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(t.criadaEmFormatada),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Concluir',
                  icon: const Icon(Icons.check_box_outline_blank),
                  onPressed: () => _controller.concluir(t),
                ),
                IconButton(
                  tooltip: 'Excluir',
                  icon: const Icon(Icons.delete),
                  onPressed: () => _controller.excluir(t),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
