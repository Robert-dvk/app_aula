import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_aula/services/auth_service.dart';
import 'package:app_aula/models/usuario.dart';
import 'package:app_aula/providers/user_provider.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  LoginPage({super.key});

  void _login(BuildContext context) async {
    String login = _loginController.text.trim();
    String senha = _senhaController.text.trim();

    AuthService authService = AuthService();
    Map<String, dynamic> result = await authService.login(login, senha);

    if (result['success']) {
      Map<String, dynamic> userData = result['usuario'];

      if (userData.isNotEmpty) {
        try {
          Usuario usuario = Usuario.fromJson(userData);

          String token = result['token'] ?? '';

          Provider.of<UserProvider>(context, listen: false)
              .setUserData(usuario, token);

          Navigator.pushReplacementNamed(context, '/home');
        } catch (e) {
          debugPrint('Erro ao converter dados do usuário: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao converter dados do usuário.')),
          );
        }
      } else {
        debugPrint('Dados do usuário estão vazios ou inválidos.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados do usuário estão vazios ou inválidos.')),
        );
      }
    } else {
      debugPrint(result['message']);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  void _goToRegisterPage(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    TextField(
                      controller: _loginController,
                      decoration: const InputDecoration(
                        labelText: 'Login',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _senhaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: () => _login(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onPressed: () => _goToRegisterPage(context),
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
