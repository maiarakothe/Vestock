import 'fornecedor.dart';
import 'loja.dart';

class Produto {
  final int? id, lojaId;
  final String nome;
  final String? tamanho, cor, tipo, descricao;
  final double custo, venda;
  final int quantidadeEstoque;
  final bool ativo;
  final String? dataCadastro;
  final Fornecedor? fornecedor;
  final Loja? loja;

  Produto({
    this.id,
    this.lojaId,
    required this.nome,
    this.tamanho,
    this.cor,
    this.tipo,
    this.descricao,
    required this.custo,
    required this.venda,
    required this.quantidadeEstoque,
    required this.ativo,
    this.dataCadastro,
    this.fornecedor,
    this.loja,
  });

  factory Produto.fromJson(Map<String, dynamic> j) => Produto(
    id: j['id'],
    lojaId: j['loja'] != null ? j['loja']['id'] : null,
    nome: j['nome'] ?? '',
    tamanho: j['tamanho'],
    cor: j['cor'],
    tipo: j['tipo'],
    descricao: j['descricao'],
    custo: (j['custo'] as num?)?.toDouble() ?? 0,
    venda: (j['venda'] as num?)?.toDouble() ?? 0,
    quantidadeEstoque: j['quantidadeEstoque'] ?? 0,
    ativo: j['ativo'] ?? true,
    dataCadastro: j['dataCadastro'],
    fornecedor: j['fornecedor'] != null
        ? Fornecedor.fromJson(j['fornecedor'])
        : null,
    loja: j['loja'] != null ? Loja.fromJson(j['loja']) : null,
  );

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'tamanho': tamanho,
    'cor': cor,
    'tipo': tipo,
    'descricao': descricao,
    'custo': custo,
    'venda': venda,
    'quantidadeEstoque': quantidadeEstoque,
    'ativo': ativo,
    'dataCadastro': dataCadastro,
    if (fornecedor?.id != null) 'fornecedor': {'id': fornecedor!.id},
    if (loja?.id != null) 'loja': {'id': loja!.id},
    if (lojaId != null) 'loja': {'id': lojaId},
  };
}
