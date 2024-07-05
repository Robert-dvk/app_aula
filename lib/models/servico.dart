class Servico {
  int? id;
  String nome;
  double valor;

  Servico({
    this.id,
    required this.nome,
    required this.valor,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'valor': valor,
    };
  }

  factory Servico.fromMap(Map<String, dynamic> map) {
    return Servico(
      id: map['id'],
      nome: map['nome'],
      valor: map['valor'],
    );
  }
}
