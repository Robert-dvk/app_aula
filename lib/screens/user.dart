import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_aula/providers/user_provider.dart';
import 'package:app_aula/repositories/usuario_repository.dart';
import 'package:app_aula/models/usuario.dart';
import 'package:app_aula/screens/edit_usuario_modal.dart';
import 'package:app_aula/services/usuario_service.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late List<Usuario> _users = [];
  late UsuarioService _usuarioService;

  @override
  void initState() {
    super.initState();
    _usuarioService = UsuarioService();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final token = Provider.of<UserProvider>(context, listen: false).token;
      Usuario? user = await _usuarioService.getData(token);
      setState(() {
        if (user != null) {
          _users = [user];
        } else {
          _users = [];
        }
      });
    } catch (e) {
      debugPrint('Erro ao carregar usuário: $e');
    }
  }

  void _openEditUserModal(BuildContext context, Usuario user) {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      return GestureDetector(
        onTap: () {},
        behavior: HitTestBehavior.opaque,
        child: EditUserModal(
          userData: user.toMap(),
          userId: user.id ?? 0,
          token: Provider.of<UserProvider>(context, listen: false).token,
          onEditUser: _editUser,
        ),
      );
    },
  );
}

  Future<void> _editUser(Map<String, dynamic> userData) async {
    try {
      final token = Provider.of<UserProvider>(context, listen: false).token;
      final result = await _usuarioService.updateUser(userData['id'], token, userData);
      print(userData['id']);
      print(token);
      print(userData);
      if (result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
        await _loadUsers();
        Navigator.of(context).pop(); // NÂO ADICIONAR ESSA LINHA
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      }
    } catch (e) {
      debugPrint('Erro ao atualizar usuário: $e');
    }
  }

  void _confirmDeleteUser(int id) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tem certeza que deseja excluir este usuário?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Excluir'),
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
        _users.removeWhere((user) => user.id == id);
      });
    } catch (e) {
      debugPrint('Erro ao excluir usuário: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (ctx, index) {
          return ListTile(
            title: Text(_users[index].nome),
            subtitle: Text(_users[index].telefone),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDeleteUser(_users[index].id!),
            ),
            onTap: () => _openEditUserModal(context, _users[index]),
          );
        },
      ),
    );
  }
}
