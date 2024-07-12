class Usuario {
  int? id;
  String nome;
  String telefone;
  String login;
  String senha;
  bool isadmin;

  Usuario({
    this.id,
    required this.nome,
    required this.telefone,
    required this.login,
    required this.senha,
    required this.isadmin,
  });

  Map<String, dynamic> toMap() {
    return {
      'idusuario': id,
      'nome': nome,
      'telefone': telefone,
      'login': login,
      'senha': senha,
      'isadmin': isadmin,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['idusuario'],
      nome: map['nome'],
      telefone: map['telefone'],
      login: map['login'],
      senha: map['senha'],
      isadmin: map['isadmin'] ?? false,
    );
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['idusuario'],
      nome: json['nome'] ?? '',
      telefone: json['telefone'] ?? '',
      login: json['login'] ?? '',
      senha: json['senha'] ?? '',
      isadmin: json['isadmin'] ?? false,
    );
  }

}
