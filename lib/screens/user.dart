import 'package:app_aula/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_aula/providers/user_provider.dart';
import 'package:app_aula/models/usuario.dart';
import 'package:app_aula/screens/edit_usuario_modal.dart';
import 'package:app_aula/services/usuario_service.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

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
        return Container(
          padding: const EdgeInsets.all(16),
          child: GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: EditUserModal(
              userData: user.toMap(),
              userId: user.id ?? 0,
              token: Provider.of<UserProvider>(context, listen: false).token,
              onEditUser: _editUser,
            ),
          ),
        );
      },
    );
  }

  Future<void> _editUser(Map<String, dynamic> userData) async {
    try {
      final token = Provider.of<UserProvider>(context, listen: false).token;
      final result =
          await _usuarioService.updateUser(userData['id'], token, userData);
      if (result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
        await _loadUsers();
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
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
              ),
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
    final token = Provider.of<UserProvider>(context, listen: false).token;
    final result = await _usuarioService.deleteUser(id, token);
    if (result['status'] == 'success') {
      setState(() {
        _users.removeWhere((user) => user.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  } catch (e) {
    debugPrint('Erro ao excluir usuário: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (ctx, index) {
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.grey[200],
            child: ListTile(
              title: Text(
                _users[index].nome,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(_users[index].telefone),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                onPressed: () => _confirmDeleteUser(_users[index].id!),
              ),
              onTap: () => _openEditUserModal(context, _users[index]),
            ),
          );
        },
      ),
    );
  }
}
