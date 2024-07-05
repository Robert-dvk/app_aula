import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_aula/screens/register.dart';
import 'package:app_aula/screens/home.dart';
import 'package:app_aula/repositories/usuario_repository.dart';
import 'package:app_aula/providers/user_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _loginMessage = '';
  final UsuarioRepository _userRepository = UsuarioRepository();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
  if (_formKey.currentState!.validate()) {
    String username = _usernameController.text;
    String password = _passwordController.text;

    final user = await _userRepository.loginUser(username, password);

    if (user != null) {
      int userId = user.id!;
      Provider.of<UserProvider>(context, listen: false).setUserId(userId);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      setState(() {
        _loginMessage = 'Login failed. Please check your credentials.';
      });
    }
  }
}

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              SizedBox(height: 8.0),
              Text(
                _loginMessage,
                style: TextStyle(
                  color: _loginMessage.contains('failed') ? Colors.red : Colors.green,
                ),
              ),
              SizedBox(height: 8.0),
              TextButton(
                onPressed: _navigateToRegister,
                child: Text('Create an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
