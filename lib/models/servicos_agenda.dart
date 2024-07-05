class ServicoAgenda {
  int? id;
  int idservico;
  int idagenda;

  ServicoAgenda({
    this.id,
    required this.idservico,
    required this.idagenda,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idservico': idservico,
      'idagenda': idagenda,
    };
  }

  factory ServicoAgenda.fromMap(Map<String, dynamic> map) {
    return ServicoAgenda(
      id: map['id'],
      idservico: map['idservico'],
      idagenda: map['idagenda'],
    );
  }
}
