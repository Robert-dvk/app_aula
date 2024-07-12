class Agenda {
  int? id;
  String data;
  String hora;
  int idusuario;
  int idpet;
  String? nomepet;
  String? serviconome;
  double? servicovalor;

  Agenda({
    this.id,
    required this.data,
    required this.hora,
    required this.idusuario,
    this.nomepet,
    this.serviconome,
    this.servicovalor,
    required this.idpet,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data,
      'hora': hora,
      'idusuario': idusuario,
      'idpet': idpet,
    };
  }

  factory Agenda.fromMap(Map<String, dynamic> map) {
    return Agenda(
      id: map['id'],
      data: map['data'],
      hora: map['hora'],
      idusuario: map['idusuario'],
      idpet: map['idpet'],
    );
  }

  factory Agenda.fromJson(Map<String, dynamic> json) {
    return Agenda(
      id: json['idagenda'],
      data: json['data'],
      hora: json['hora'],
      idusuario: json['idusuario'],
      nomepet: json['pet_nome'],
      serviconome: json['servico_nome'],
      servicovalor: double.parse(json['servico_valor'].toString()),
      idpet: json['idpet'],
    );
  }
}
