class ItemCondicional {
  int? produtoId;
  String? nomeProduto;
  int quantidade;

  ItemCondicional({this.produtoId, this.nomeProduto, required this.quantidade});

  factory ItemCondicional.fromJson(Map<String, dynamic> j) => ItemCondicional(
    produtoId: j['produto']?['id'],
    nomeProduto: j['produto']?['nome'],
    quantidade: j['quantidadeItem'] ?? 1,
  );

  Map<String, dynamic> toJson() => {
    'produto': {'id': produtoId},
    'quantidadeItem': quantidade,
  };
}
