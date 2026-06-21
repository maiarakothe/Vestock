class Loja {
  final int? id;
  final String nome;
  final String cnpj;
  final String telefone;
  final String email;
  final String senha;

  final String? rua;
  final String? bairro;
  final String? cidade;

  Loja({
    this.id,
    required this.nome,
    required this.cnpj,
    required this.telefone,
    required this.email,
    required this.senha,
    this.rua,
    this.bairro,
    this.cidade,
  });

  factory Loja.fromJson(Map<String, dynamic> j) => Loja(
    id: j['id'],
    nome: j['nome'] ?? '',
    cnpj: j['cnpj'] ?? '',
    telefone: j['telefone'] ?? '',
    email: j['email'] ?? '',
    senha: '',
    rua: j['rua'],
    bairro: j['bairro'],
    cidade: j['cidade'],
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'nome': nome,
    'cnpj': cnpj,
    'telefone': telefone,
    'email': email,
    'senha': senha,
    'rua': rua,
    'bairro': bairro,
    'cidade': cidade,
  };
}
