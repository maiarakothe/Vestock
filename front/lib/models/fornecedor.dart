class Fornecedor {
  final int? id, lojaId;
  final String nome, cnpj, telefone, email;
  final String? nomeFantasia, sexo, rua, bairro, cidade, estado;

  Fornecedor({
    this.id,
    this.lojaId,
    required this.nome,
    required this.cnpj,
    required this.telefone,
    required this.email,
    this.nomeFantasia,
    this.sexo,
    this.rua,
    this.bairro,
    this.cidade,
    this.estado,
  });

  factory Fornecedor.fromJson(Map<String, dynamic> j) => Fornecedor(
    id: j['id'],
    lojaId: j['loja'] != null ? j['loja']['id'] : null,
    nome: j['nome'] ?? '',
    cnpj: j['cnpj'] ?? '',
    telefone: j['telefone'] ?? '',
    email: j['email'] ?? '',
    nomeFantasia: j['nomeFantasia'],
    sexo: j['sexo'],
    rua: j['rua'],
    bairro: j['bairro'],
    cidade: j['cidade'],
    estado: j['estado'],
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'nome': nome,
    'cnpj': cnpj,
    'telefone': telefone,
    'email': email,
    'nomeFantasia': nomeFantasia,
    'sexo': sexo,
    'rua': rua,
    'bairro': bairro,
    'cidade': cidade,
    'estado': estado,
    if (lojaId != null) 'loja': <String, int?>{'id': lojaId},
  };
}
