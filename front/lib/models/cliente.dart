class Cliente {
  final int? id, lojaId;
  final String nome, cpf, telefone, email, sexo;
  final String dataCadastro;
  final String rua, bairro, cidade, estado;

  Cliente({
    this.id,
    this.lojaId,
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
    lojaId: j['loja'] != null ? j['loja']['id'] : null,
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

  Map<String, dynamic> toJson() => <String, dynamic>{
    'nome': nome,
    'cpf': cpf,
    'telefone': telefone,
    'email': email,
    'sexo': sexo,
    'dataCadastro': dataCadastro,
    'rua': rua,
    'bairro': bairro,
    'cidade': cidade,
    'estado': estado,
    if (lojaId != null) 'loja': <String, int?>{'id': lojaId},
  };
}
