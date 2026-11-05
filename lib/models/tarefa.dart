class Tarefa {
  final int? id;
  final String titulo;
  final bool concluida;
  final DateTime criadaEm;
  final DateTime? concluidaEm;

  Tarefa({
    this.id,
    required this.titulo,
    this.concluida = false,
    required this.criadaEm,
    this.concluidaEm,
  });

  factory Tarefa.fromMap(Map<String, Object?> m) => Tarefa(
        id: m['id'] as int,
        titulo: m['titulo'] as String,
        concluida: (m['concluida'] as int) == 1,
        criadaEm: DateTime.parse(m['criada_em'] as String),
        concluidaEm: m['concluida_em'] == null
            ? null
            : DateTime.parse(m['concluida_em'] as String),
      );

  String get criadaEmFormatada => _formatar(criadaEm);

  String get concluidaEmFormatada =>
      concluidaEm == null ? '' : _formatar(concluidaEm!);

  static String _formatar(DateTime d) {
    String dois(int n) => n.toString().padLeft(2, '0');
    return '${dois(d.day)}/${dois(d.month)}/${d.year} ${dois(d.hour)}:${dois(d.minute)}';
  }
}
