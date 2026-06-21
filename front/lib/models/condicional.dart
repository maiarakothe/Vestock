import 'item_condicional.dart';

class Condicional {
  final int? id, lojaId;
  final int clienteId;
  final String clienteNome;
  final String? nomeItem, dataRetirada, dataDevolucao, observacao;
  final bool devolvido;
  final List<ItemCondicional> itens;

  Condicional({
    this.id,
    this.lojaId,
    required this.clienteId,
    required this.clienteNome,
    this.nomeItem,
    this.dataRetirada,
    this.dataDevolucao,
    this.observacao,
    required this.devolvido,
    required this.itens,
  });

  factory Condicional.fromJson(Map<String, dynamic> j) => Condicional(
    id: j['id'],
    lojaId: j['loja'] != null ? j['loja']['id'] : null,
    clienteId: j['cliente']?['id'] ?? 0,
    clienteNome: j['cliente']?['nome'] ?? '',
    nomeItem: j['nomeItem'],
    dataRetirada: j['dataRetirada'],
    dataDevolucao: j['dataDevolucao'],
    observacao: j['observacao'],
    devolvido: j['devolvido'] ?? false,
    itens: (j['itens'] as List? ?? <dynamic>[])
        .map((i) => ItemCondicional.fromJson(i))
        .toList(),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'cliente': <String, int>{'id': clienteId},
    'nomeItem': nomeItem,
    'dataRetirada': dataRetirada,
    'dataDevolucao': dataDevolucao,
    'observacao': observacao,
    'itens': itens.map((ItemCondicional i) => i.toJson()).toList(),
    if (lojaId != null) 'loja': <String, int?>{'id': lojaId},
  };
}
