class Pet {
  int? id;
  String nome;
  String datanasc;
  String sexo;
  double peso;
  String porte;
  double altura;
  String? imagem;
  int idusuario;

  Pet({
    this.id,
    required this.nome,
    required this.datanasc,
    required this.sexo,
    required this.peso,
    required this.porte,
    required this.altura,
    this.imagem,
    required this.idusuario,
  });

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['idpet'],
      nome: map['nome'],
      datanasc: map['datanasc'],
      sexo: map['sexo'],
      peso: double.parse(map['peso'].toString()),
      porte: map['porte'],
      altura: double.parse(map['altura'].toString()),
      imagem: map['imagem'],
      idusuario: map['idusuario'],
    );
  }

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['idpet'],
      nome: json['nome'],
      datanasc: json['datanasc'],
      sexo: json['sexo'],
      peso: double.parse(json['peso'].toString()),
      porte: json['porte'],
      altura: double.parse(json['altura'].toString()),
      imagem: json['imagem'],
      idusuario: json['idusuario'],
    );
  }

  Map<String, dynamic> toMap({bool withId = true}) {
    var map = {
      'nome': nome,
      'datanasc': datanasc,
      'sexo': sexo,
      'peso': peso,
      'porte': porte,
      'altura': altura,
      'imagem': imagem,
      'idusuario': idusuario,
    };
    if (withId) {
      map['idpet'] = id;
    }
    return map;
  }
}
