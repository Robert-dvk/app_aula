import 'package:flutter/material.dart';

class EditUserModal extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Function(int, String, String, String, String) onEditUser;

  EditUserModal(this.userData, this.onEditUser);

  @override
  _EditUserModalState createState() => _EditUserModalState();
}

class _EditUserModalState extends State<EditUserModal> {
  final _formKey = GlobalKey<FormState>();
  late int _id;
  late String _nome;
  late String _telefone;
  late String _login;
  late String _senha;

  @override
  void initState() {
    super.initState();
    _id = widget.userData['id'];
    _nome = widget.userData['nome'];
    _telefone = widget.userData['telefone'];
    _login = widget.userData['login'];
    _senha = widget.userData['senha'];
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onEditUser(_id, _nome, _telefone, _login, _senha);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _nome,
              decoration: InputDecoration(labelText: 'Nome'),
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
            TextFormField(
              initialValue: _telefone,
              decoration: InputDecoration(labelText: 'Telefone'),
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
            TextFormField(
              initialValue: _login,
              decoration: InputDecoration(labelText: 'Login'),
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
            TextFormField(
              initialValue: _senha,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, insira a senha';
                }
                return null;
              },
              onSaved: (value) {
                _senha = value!;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
