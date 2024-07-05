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
      id: map['id'],
      nome: map['nome'],
      datanasc: map['datanasc'],
      sexo: map['sexo'],
      peso: map['peso'],
      porte: map['porte'],
      altura: map['altura'],
      imagem: map['imagem'],
      idusuario: map['idusuario'],
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
      map['id'] = id;
    }
    return map;
  }
}
