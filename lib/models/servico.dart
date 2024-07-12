class Servico {
  int? id;
  String nome;
  double valor;

  Servico({
    this.id,
    required this.nome,
    required this.valor,
  });

  factory Servico.fromJson(Map<String, dynamic> json) {
    return Servico(
      id: json['idservico'],
      nome: json['nome'],
      valor: double.parse(json['valor'].toString()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'valor': valor,
    };
  }

  factory Servico.fromMap(Map<String, dynamic> map) {
    return Servico(
      id: map['idservico'],
      nome: map['nome'],
      valor: double.parse(map['valor'].toString()),
    );
  }
}
