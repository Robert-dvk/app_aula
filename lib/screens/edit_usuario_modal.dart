import 'package:flutter/material.dart';

class EditUserModal extends StatefulWidget {
  final Map<String, dynamic> userData;
  final int userId;
  final String token;
  final Function(Map<String, dynamic>) onEditUser;

  const EditUserModal({
    required this.userData,
    required this.userId,
    required this.token,
    required this.onEditUser,
    Key? key,
  }) : super(key: key);

  @override
  _EditUserModalState createState() => _EditUserModalState();
}

class _EditUserModalState extends State<EditUserModal> {
  final _formKey = GlobalKey<FormState>();
  late int _id;
  late String _nome;
  late String _telefone;
  late String _login;

  @override
  void initState() {
    super.initState();
    _id = widget.userId;
    _nome = widget.userData['nome'] ?? '';
    _telefone = widget.userData['telefone'] ?? '';
    _login = widget.userData['login'] ?? '';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onEditUser({
        'id': _id,
        'nome': _nome,
        'telefone': _telefone,
        'login': _login,
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: _nome,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o nome';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _nome = value!;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: _telefone,
                  decoration: const InputDecoration(labelText: 'Telefone'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o telefone';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _telefone = value!;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: _login,
                  decoration: const InputDecoration(labelText: 'Login'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o login';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _login = value!;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                      'Salvar',
                      style: TextStyle(color: Colors.white),
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
