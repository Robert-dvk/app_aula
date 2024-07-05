import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_aula/providers/user_provider.dart';
import 'package:app_aula/repositories/usuario_repository.dart';
import 'package:app_aula/models/usuario.dart';
import 'package:app_aula/screens/edit_usuario_modal.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<Map<String, dynamic>> _user = [];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).userId;
      if (userId != null) {
        Usuario? user = await UsuarioRepository().getUserById(userId);
        setState(() {
          if (user != null) {
            _user = [user.toMap()];
          } else {
            _user = [];
          }
        });
      } else {
        print('User ID is null');
      }
    } catch (e) {
      print('Erro ao carregar usuário: $e');
    }
  }

  void _openEditUserModal(BuildContext context, Map<String, dynamic> userData) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: EditUserModal(userData, _editUser),
        );
      },
    );
  }

  Future<void> _editUser(int id, String nome, String telefone, String login, String senha) async {
    try {
      Usuario user = Usuario(
        id: id,
        nome: nome,
        telefone: telefone,
        login: login,
        senha: senha,
        isadmin: 0, // Não precisa passar esse campo na UI, apenas um valor default
      );

      await UsuarioRepository().updateUser(user);
      await _loadUser();

      Navigator.of(context).pop();
    } catch (e) {
      print('Erro ao atualizar usuário: $e');
    }
  }

  void _confirmDeleteUser(int id) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tem certeza que deseja excluir este usuário?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Excluir'),
              onPressed: () {
                _deleteUser(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser(int id) async {
    try {
      await UsuarioRepository().deleteUser(id);
      setState(() {
        _user.removeWhere((user) => user['id'] == id);
      });
    } catch (e) {
      print('Erro ao excluir usuário: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuários'),
      ),
      body: ListView.builder(
        itemCount: _user.length,
        itemBuilder: (ctx, index) {
          return ListTile(
            leading: _user[index]['imagem'] != null
                ? Image.file(File(_user[index]['imagem']))
                : null,
            title: Text(_user[index]['nome']),
            subtitle: Text(_user[index]['telefone']),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _confirmDeleteUser(_user[index]['id'] as int),
            ),
            onTap: () => _openEditUserModal(context, _user[index]),
          );
        },
      ),
    );
  }
}
