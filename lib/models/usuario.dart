class Usuario {
  int? id;
  String nome;
  String telefone;
  String login;
  String senha;
  int isadmin;

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
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'login': login,
      'senha': senha,
      'isadmin': isadmin,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      telefone: map['telefone'],
      login: map['login'],
      senha: map['senha'],
      isadmin: map['isadmin'],
    );
  }
}
