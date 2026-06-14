class ItemVenda {
  int? produtoId;
  String? nomeProduto;
  int quantidade;
  double valorUnitario;

  ItemVenda({
    this.produtoId,
    this.nomeProduto,
    required this.quantidade,
    required this.valorUnitario,
  });

  factory ItemVenda.fromJson(Map<String, dynamic> j) => ItemVenda(
    produtoId: j['produto']?['id'],
    nomeProduto: j['produto']?['nome'],
    quantidade: j['quantidadeItem'] ?? 1,
    valorUnitario: (j['valorUnitario'] as num?)?.toDouble() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'produto': {'id': produtoId},
    'quantidadeItem': quantidade,
    'valorUnitario': valorUnitario,
    'valorTotal': valorUnitario * quantidade,
  };
}
