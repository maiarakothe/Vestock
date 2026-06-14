class Desconto {
  final int? id, lojaId;
  final String nome;
  final double valor;
  final String? dataCadastro, dataValidade;

  Desconto({
    this.id,
    this.lojaId,
    required this.nome,
    required this.valor,
    this.dataCadastro,
    this.dataValidade,
  });

  factory Desconto.fromJson(Map<String, dynamic> j) => Desconto(
    id: j['id'],
    nome: j['nome'] ?? '',
    valor: (j['valor'] as num?)?.toDouble() ?? 0,
    dataCadastro: j['dataCadastro'],
    dataValidade: j['dataValidade'],
    lojaId: j['loja'] != null ? j['loja']['id'] : null,
  );

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'valor': valor,
    'dataCadastro': (dataCadastro ?? '') + 'T00:00:00',
    'dataValidade': dataValidade,
      if (lojaId != null) 'loja': {'id': lojaId},
  };
}
