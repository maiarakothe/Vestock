import 'item_venda.dart';

class Venda {
  final int? id, lojaId;
  final String clienteNome, funcionarioNome, formaPagamento;
  final String? dataVenda, descontoNome;
  final double totalVenda, valorCupomDesconto;
  final List<ItemVenda> itens;

  Venda({
    this.id,
    this.lojaId,
    required this.clienteNome,
    required this.funcionarioNome,
    required this.formaPagamento,
    this.dataVenda,
    this.descontoNome,
    required this.totalVenda,
    required this.valorCupomDesconto,
    required this.itens,
  });

  factory Venda.fromJson(Map<String, dynamic> j) => Venda(
    id: j['id'],
    clienteNome: j['cliente']?['nome'] ?? '',
    funcionarioNome: j['funcionario']?['nome'] ?? '',
    formaPagamento: j['formaPagamento'] ?? '',
    dataVenda: j['dataVenda'],
    descontoNome: j['desconto']?['nome'],
    totalVenda: (j['totalVenda'] as num?)?.toDouble() ?? 0,
    valorCupomDesconto: (j['valorCupomDesconto'] as num?)?.toDouble() ?? 0,
    itens: (j['itens'] as List? ?? <dynamic>[])
        .map((i) => ItemVenda.fromJson(i))
        .toList(),
    lojaId: j['loja'] != null ? j['loja']['id'] : null,
  );
}
