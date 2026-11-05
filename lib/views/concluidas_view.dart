import 'package:flutter/material.dart';

import '../controllers/tarefa_controller.dart';

class ConcluidasView extends StatelessWidget {
  const ConcluidasView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TarefaController.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Tarefas concluídas')),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final tarefas = controller.concluidas;
            if (tarefas.isEmpty) {
              return const Center(
                child: Text(
                  'Nenhuma tarefa concluída ainda.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: tarefas.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final t = tarefas[i];
                return Card(
                  child: ListTile(
                    title: Text(
                      t.titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    subtitle: Text('Concluída em ${t.concluidaEmFormatada}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Reabrir',
                          icon: const Icon(Icons.check_box),
                          onPressed: () => controller.reabrir(t),
                        ),
                        IconButton(
                          tooltip: 'Excluir',
                          icon: const Icon(Icons.delete),
                          onPressed: () => controller.excluir(t),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
