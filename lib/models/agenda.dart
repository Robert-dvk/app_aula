class Agenda {
  int? id;
  String data;
  String hora;
  int idusuario;
  int idpet;

  Agenda({
    this.id,
    required this.data,
    required this.hora,
    required this.idusuario,
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
      id: json['id'],
      data: json['data'],
      hora: json['hora'],
      idusuario: json['idusuario'],
      idpet: json['idpet'],
    );
  }

}
