// lib/models/models.dart

class Cliente {
  final int? id;
  final String nome, cpf, telefone, email, sexo;
  final String dataCadastro;
  final String rua, bairro, cidade, estado;

  Cliente({
    this.id,
    required this.nome,
    required this.cpf,
    required this.telefone,
    required this.email,
    required this.sexo,
    required this.dataCadastro,
    required this.rua,
    required this.bairro,
    required this.cidade,
    required this.estado,
  });

  factory Cliente.fromJson(Map<String, dynamic> j) => Cliente(
    id: j['id'],
    nome: j['nome'] ?? '',
    cpf: j['cpf'] ?? '',
    telefone: j['telefone'] ?? '',
    email: j['email'] ?? '',
    sexo: j['sexo'] ?? '',
    dataCadastro: j['dataCadastro'] ?? '',
    rua: j['rua'] ?? '',
    bairro: j['bairro'] ?? '',
    cidade: j['cidade'] ?? '',
    estado: j['estado'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'nome': nome, 'cpf': cpf, 'telefone': telefone, 'email': email,
    'sexo': sexo, 'dataCadastro': dataCadastro,
    'rua': rua, 'bairro': bairro, 'cidade': cidade, 'estado': estado,
  };
}

class Fornecedor {
  final int? id;
  final String nome, cnpj, telefone, email;
  final String? nomeFantasia, sexo, rua, bairro, cidade, estado;

  Fornecedor({
    this.id, required this.nome, required this.cnpj,
    required this.telefone, required this.email,
    this.nomeFantasia, this.sexo, this.rua, this.bairro, this.cidade, this.estado,
  });

  factory Fornecedor.fromJson(Map<String, dynamic> j) => Fornecedor(
    id: j['id'], nome: j['nome'] ?? '', cnpj: j['cnpj'] ?? '',
    telefone: j['telefone'] ?? '', email: j['email'] ?? '',
    nomeFantasia: j['nomeFantasia'], sexo: j['sexo'],
    rua: j['rua'], bairro: j['bairro'], cidade: j['cidade'], estado: j['estado'],
  );

  Map<String, dynamic> toJson() => {
    'nome': nome, 'cnpj': cnpj, 'telefone': telefone, 'email': email,
    'nomeFantasia': nomeFantasia, 'sexo': sexo,
    'rua': rua, 'bairro': bairro, 'cidade': cidade, 'estado': estado,
  };
}

class Loja {
  final int? id;
  final String nome, cnpj, telefone;
  final String? rua, bairro, cidade;

  Loja({this.id, required this.nome, required this.cnpj, required this.telefone,
    this.rua, this.bairro, this.cidade});

  factory Loja.fromJson(Map<String, dynamic> j) => Loja(
    id: j['id'], nome: j['nome'] ?? '', cnpj: j['cnpj'] ?? '',
    telefone: j['telefone'] ?? '', rua: j['rua'],
    bairro: j['bairro'], cidade: j['cidade'],
  );

  Map<String, dynamic> toJson() => {
    'nome': nome, 'cnpj': cnpj, 'telefone': telefone,
    'rua': rua, 'bairro': bairro, 'cidade': cidade,
  };
}

class Produto {
  final int? id;
  final String nome;
  final String? tamanho, cor, tipo, descricao;
  final double custo, venda;
  final int quantidadeEstoque;
  final bool ativo;
  final String? dataCadastro;
  final Fornecedor? fornecedor;
  final Loja? loja;

  Produto({
    this.id, required this.nome, this.tamanho, this.cor, this.tipo,
    this.descricao, required this.custo, required this.venda,
    required this.quantidadeEstoque, required this.ativo,
    this.dataCadastro, this.fornecedor, this.loja,
  });

  factory Produto.fromJson(Map<String, dynamic> j) => Produto(
    id: j['id'], nome: j['nome'] ?? '',
    tamanho: j['tamanho'], cor: j['cor'], tipo: j['tipo'],
    descricao: j['descricao'],
    custo: (j['custo'] as num?)?.toDouble() ?? 0,
    venda: (j['venda'] as num?)?.toDouble() ?? 0,
    quantidadeEstoque: j['quantidadeEstoque'] ?? 0,
    ativo: j['ativo'] ?? true,
    dataCadastro: j['dataCadastro'],
    fornecedor: j['fornecedor'] != null ? Fornecedor.fromJson(j['fornecedor']) : null,
    loja: j['loja'] != null ? Loja.fromJson(j['loja']) : null,
  );

  Map<String, dynamic> toJson() => {
    'nome': nome, 'tamanho': tamanho, 'cor': cor, 'tipo': tipo,
    'descricao': descricao, 'custo': custo, 'venda': venda,
    'quantidadeEstoque': quantidadeEstoque, 'ativo': ativo,
    'dataCadastro': dataCadastro,
    if (fornecedor?.id != null) 'fornecedor': {'id': fornecedor!.id},
    if (loja?.id != null) 'loja': {'id': loja!.id},
  };
}

class Funcionario {
  final int? id;
  final String nome, cpf, cargo, telefone, email;
  final String? sexo, dataAdmissao, rua, bairro, cidade, estado;

  Funcionario({
    this.id, required this.nome, required this.cpf,
    required this.cargo, required this.telefone, required this.email,
    this.sexo, this.dataAdmissao, this.rua, this.bairro, this.cidade, this.estado,
  });

  factory Funcionario.fromJson(Map<String, dynamic> j) => Funcionario(
    id: j['id'], nome: j['nome'] ?? '', cpf: j['cpf'] ?? '',
    cargo: j['cargo'] ?? '', telefone: j['telefone'] ?? '', email: j['email'] ?? '',
    sexo: j['sexo'], dataAdmissao: j['dataAdmissao'],
    rua: j['rua'], bairro: j['bairro'], cidade: j['cidade'], estado: j['estado'],
  );

  Map<String, dynamic> toJson() => {
    'nome': nome, 'cpf': cpf, 'cargo': cargo, 'telefone': telefone,
    'email': email, 'sexo': sexo,
    'dataAdmissao': (dataAdmissao ?? '') + 'T00:00:00',
    'rua': rua, 'bairro': bairro, 'cidade': cidade, 'estado': estado,
  };
}

class Desconto {
  final int? id;
  final String nome;
  final double valor;
  final String? dataCadastro, dataValidade;

  Desconto({this.id, required this.nome, required this.valor,
    this.dataCadastro, this.dataValidade});

  factory Desconto.fromJson(Map<String, dynamic> j) => Desconto(
    id: j['id'], nome: j['nome'] ?? '',
    valor: (j['valor'] as num?)?.toDouble() ?? 0,
    dataCadastro: j['dataCadastro'], dataValidade: j['dataValidade'],
  );

  Map<String, dynamic> toJson() => {
    'nome': nome, 'valor': valor,
    'dataCadastro': (dataCadastro ?? '') + 'T00:00:00',
    'dataValidade': dataValidade,
  };
}

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

class Condicional {
  final int? id;
  final int clienteId;
  final String clienteNome;
  final String? nomeItem, dataRetirada, dataDevolucao, observacao;
  final bool devolvido;
  final List<ItemCondicional> itens;

  Condicional({
    this.id, required this.clienteId, required this.clienteNome,
    this.nomeItem, this.dataRetirada, this.dataDevolucao,
    this.observacao, required this.devolvido, required this.itens,
  });

  factory Condicional.fromJson(Map<String, dynamic> j) => Condicional(
    id: j['id'],
    clienteId: j['cliente']?['id'] ?? 0,
    clienteNome: j['cliente']?['nome'] ?? '',
    nomeItem: j['nomeItem'],
    dataRetirada: j['dataRetirada'],
    dataDevolucao: j['dataDevolucao'],
    observacao: j['observacao'],
    devolvido: j['devolvido'] ?? false,
    itens: (j['itens'] as List? ?? [])
        .map((i) => ItemCondicional.fromJson(i))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'cliente': {'id': clienteId},
    'nomeItem': nomeItem,
    'dataRetirada': dataRetirada,
    'dataDevolucao': dataDevolucao,
    'observacao': observacao,
    'itens': itens.map((i) => i.toJson()).toList(),
  };
}

class ItemVenda {
  int? produtoId;
  String? nomeProduto;
  int quantidade;
  double valorUnitario;

  ItemVenda({this.produtoId, this.nomeProduto,
    required this.quantidade, required this.valorUnitario});

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

class Venda {
  final int? id;
  final String clienteNome, funcionarioNome, formaPagamento;
  final String? dataVenda, descontoNome;
  final double totalVenda, valorCupomDesconto;
  final List<ItemVenda> itens;

  Venda({
    this.id, required this.clienteNome, required this.funcionarioNome,
    required this.formaPagamento, this.dataVenda, this.descontoNome,
    required this.totalVenda, required this.valorCupomDesconto,
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
    itens: (j['itens'] as List? ?? [])
        .map((i) => ItemVenda.fromJson(i))
        .toList(),
  );
}