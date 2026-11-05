import 'package:flutter/material.dart';

// Paleta estilo Windows 98 / web 2000
const corFundo = Color(0xFF008080);
const corCinza = Color(0xFFC0C0C0);
const corCinzaEscuro = Color(0xFF808080);
const corAzulTitulo = Color(0xFF000080);
const corLink = Color(0xFF0000EE);

const fonteComic = 'Comic Sans MS';

TextStyle estiloTexto({
  double tamanho = 14,
  Color cor = Colors.black,
  bool negrito = false,
  bool sublinhado = false,
}) =>
    TextStyle(
      fontFamily: fonteComic,
      fontFamilyFallback: const ['Chalkboard SE', 'Comic Neue', 'cursive'],
      fontSize: tamanho,
      color: cor,
      fontWeight: negrito ? FontWeight.bold : FontWeight.normal,
      decoration: sublinhado ? TextDecoration.underline : TextDecoration.none,
    );

/// Borda "alto relevo" (elevada) ou "baixo relevo" (afundada) clássica.
BoxDecoration decoracaoBisel({
  bool afundado = false,
  Color cor = corCinza,
}) {
  final claro = afundado ? corCinzaEscuro : Colors.white;
  final escuro = afundado ? Colors.white : Colors.black;
  return BoxDecoration(
    color: cor,
    border: Border(
      top: BorderSide(color: claro, width: 2),
      left: BorderSide(color: claro, width: 2),
      right: BorderSide(color: escuro, width: 2),
      bottom: BorderSide(color: escuro, width: 2),
    ),
  );
}

/// Janela com barra de título azul, como no Windows 98.
class JanelaRetro extends StatelessWidget {
  final String titulo;
  final Widget child;
  final EdgeInsets padding;
  final bool expandir;

  const JanelaRetro({
    super.key,
    required this.titulo,
    required this.child,
    this.padding = const EdgeInsets.all(10),
    this.expandir = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoracaoBisel(),
      padding: const EdgeInsets.all(3),
      child: Column(
        mainAxisSize: expandir ? MainAxisSize.max : MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [corAzulTitulo, Color(0xFF1084D0)],
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.folder_open, size: 16, color: Colors.yellow),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    titulo,
                    overflow: TextOverflow.ellipsis,
                    style: estiloTexto(
                        tamanho: 13, cor: Colors.white, negrito: true),
                  ),
                ),
                _botaoTitulo('_'),
                _botaoTitulo('□'),
                _botaoTitulo('X'),
              ],
            ),
          ),
          if (expandir)
            Expanded(child: Padding(padding: padding, child: child))
          else
            Padding(padding: padding, child: child),
        ],
      ),
    );
  }

  Widget _botaoTitulo(String t) => Container(
        width: 18,
        height: 16,
        margin: const EdgeInsets.only(left: 2),
        alignment: Alignment.center,
        decoration: decoracaoBisel(),
        child: Text(t,
            style: const TextStyle(
                fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold)),
      );
}

/// Botão cinza com bisel que "afunda" ao clicar.
class BotaoRetro extends StatefulWidget {
  final String texto;
  final VoidCallback? onPressed;
  final bool compacto;

  const BotaoRetro({
    super.key,
    required this.texto,
    required this.onPressed,
    this.compacto = false,
  });

  @override
  State<BotaoRetro> createState() => _BotaoRetroState();
}

class _BotaoRetroState extends State<BotaoRetro> {
  bool _apertado = false;

  @override
  Widget build(BuildContext context) {
    final ativo = widget.onPressed != null;
    return GestureDetector(
      onTapDown: ativo ? (_) => setState(() => _apertado = true) : null,
      onTapUp: ativo ? (_) => setState(() => _apertado = false) : null,
      onTapCancel: ativo ? () => setState(() => _apertado = false) : null,
      onTap: widget.onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: widget.compacto ? 8 : 16,
          vertical: widget.compacto ? 4 : 8,
        ),
        decoration: decoracaoBisel(afundado: _apertado),
        child: Transform.translate(
          offset: _apertado ? const Offset(1, 1) : Offset.zero,
          child: Text(
            widget.texto,
            textAlign: TextAlign.center,
            style: estiloTexto(
              tamanho: widget.compacto ? 12 : 14,
              cor: ativo ? Colors.black : corCinzaEscuro,
              negrito: true,
            ),
          ),
        ),
      ),
    );
  }
}

/// Texto rolando da direita para a esquerda (<marquee> dos anos 2000).
class TextoRolando extends StatefulWidget {
  final String texto;
  final TextStyle? estilo;

  const TextoRolando({super.key, required this.texto, this.estilo});

  @override
  State<TextoRolando> createState() => _TextoRolandoState();
}

class _TextoRolandoState extends State<TextoRolando>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estilo = widget.estilo ??
        estiloTexto(tamanho: 15, cor: Colors.yellow, negrito: true);
    return Container(
      height: 28,
      decoration: decoracaoBisel(afundado: true, cor: Colors.black),
      child: LayoutBuilder(builder: (context, box) {
        final tp = TextPainter(
          text: TextSpan(text: widget.texto, style: estilo),
          textDirection: TextDirection.ltr,
        )..layout();
        final largura = box.maxWidth;
        return ClipRect(
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, _) => Stack(
              children: [
                Positioned(
                  left: largura - (largura + tp.width) * _c.value,
                  top: 3,
                  child: Text(widget.texto,
                      softWrap: false, style: estilo),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

/// Texto que pisca (<blink>).
class TextoPiscando extends StatefulWidget {
  final String texto;
  final TextStyle estilo;

  const TextoPiscando({super.key, required this.texto, required this.estilo});

  @override
  State<TextoPiscando> createState() => _TextoPiscandoState();
}

class _TextoPiscandoState extends State<TextoPiscando>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) => Opacity(
        opacity: _c.value > 0.5 ? 1 : 0,
        child: Text(widget.texto, style: widget.estilo),
      ),
    );
  }
}

/// Contador de visitas com dígitos verdes sobre fundo preto.
class ContadorRetro extends StatelessWidget {
  final int valor;
  final int digitos;

  const ContadorRetro({super.key, required this.valor, this.digitos = 4});

  @override
  Widget build(BuildContext context) {
    final texto = valor.toString().padLeft(digitos, '0');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final d in texto.split(''))
          Container(
            width: 26,
            height: 36,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            alignment: Alignment.center,
            decoration: decoracaoBisel(afundado: true, cor: Colors.black),
            child: Text(
              d,
              style: const TextStyle(
                fontFamily: 'Courier',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00FF00),
              ),
            ),
          ),
      ],
    );
  }
}

/// Linha horizontal em relevo (<hr>).
class LinhaRetro extends StatelessWidget {
  const LinhaRetro({super.key});

  @override
  Widget build(BuildContext context) => Container(
        height: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: decoracaoBisel(afundado: true),
      );
}

String formatarData(DateTime d) {
  String dois(int n) => n.toString().padLeft(2, '0');
  return '${dois(d.day)}/${dois(d.month)}/${d.year} ${dois(d.hour)}:${dois(d.minute)}';
}
