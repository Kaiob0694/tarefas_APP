import 'package:flutter/material.dart';

import '../retro.dart';
import 'home.dart';

class TelaInicio extends StatelessWidget {
  const TelaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TextoRolando(
                  texto:
                      '*** Bem-vindo ao melhor gerenciador de tarefas da Internet!!! *** Melhor visualizado em 800x600 ***',
                ),
                const SizedBox(height: 16),
                JanelaRetro(
                  titulo: 'Tarefas 2000 - Microsoft Internet Explorer',
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'TAREFAS',
                        style: TextStyle(
                          fontFamily: fonteComic,
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                          color: Colors.red.shade700,
                          shadows: const [
                            Shadow(
                                color: Colors.black,
                                offset: Offset(3, 3),
                                blurRadius: 0),
                          ],
                        ),
                      ),
                      Text(
                        'D O T  2 0 0 0',
                        style: TextStyle(
                          fontFamily: fonteComic,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      const LinhaRetro(),
                      Text(
                        'Organize sua vida no melhor estilo\nWeb 1.0!',
                        textAlign: TextAlign.center,
                        style: estiloTexto(tamanho: 15),
                      ),
                      const SizedBox(height: 12),
                      TextoPiscando(
                        texto: '>>> NOVO! Agora com SQLite! <<<',
                        estilo: estiloTexto(
                            tamanho: 14, cor: Colors.red, negrito: true),
                      ),
                      const SizedBox(height: 20),
                      BotaoRetro(
                        texto: '>> CLIQUE AQUI PARA INICIAR <<',
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const TelaHome()),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.construction,
                              color: Colors.orange, size: 22),
                          const SizedBox(width: 6),
                          Text('Site em construção',
                              style: estiloTexto(
                                  tamanho: 12, cor: corLink, sublinhado: true)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '© 2000 Tarefas Corp. Todos os direitos reservados.',
                  style: estiloTexto(tamanho: 11, cor: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
