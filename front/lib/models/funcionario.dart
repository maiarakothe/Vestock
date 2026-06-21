class Funcionario {
  final int? id;
  final String nome, cpf, cargo, telefone, email;
  final String? sexo, dataAdmissao, rua, bairro, cidade, estado;
  final int? lojaId;

  Funcionario({
    this.id,
    required this.nome,
    required this.cpf,
    required this.cargo,
    required this.telefone,
    required this.email,
    this.sexo,
    this.dataAdmissao,
    this.rua,
    this.bairro,
    this.cidade,
    this.estado,
    this.lojaId,
  });

  factory Funcionario.fromJson(Map<String, dynamic> j) => Funcionario(
    id: j['id'],
    nome: j['nome'] ?? '',
    cpf: j['cpf'] ?? '',
    cargo: j['cargo'] ?? '',
    telefone: j['telefone'] ?? '',
    email: j['email'] ?? '',
    sexo: j['sexo'],
    dataAdmissao: j['dataAdmissao'],
    rua: j['rua'],
    bairro: j['bairro'],
    cidade: j['cidade'],
    estado: j['estado'],
    lojaId: j['loja']?['id'],
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'nome': nome,
    'cpf': cpf,
    'cargo': cargo,
    'telefone': telefone,
    'email': email,
    'sexo': sexo,
    'dataAdmissao': '${dataAdmissao ?? ''}T00:00:00',
    'rua': rua,
    'bairro': bairro,
    'cidade': cidade,
    'estado': estado,
    if (lojaId != null) 'loja': <String, int?>{'id': lojaId},
  };
}
