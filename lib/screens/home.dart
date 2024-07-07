import 'package:app_aula/models/usuario.dart';
import 'package:app_aula/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_aula/components/custom_bottom_navigation_bar.dart';
import 'package:app_aula/screens/agenda.dart';
import 'package:app_aula/screens/pets.dart';
import 'package:app_aula/screens/user.dart';
import 'package:app_aula/providers/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;
  late UsuarioService _usuarioService;
  final PageController _pageController = PageController(initialPage: 2);
  @override
  void initState() {
    super.initState();
     _usuarioService = UsuarioService();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final token = Provider.of<UserProvider>(context, listen: false).token;
      Usuario? user = await _usuarioService.getData(token);
      setState(() {
        if (user != null) {
        } else {
        }
      });
        } catch (e) {
      debugPrint('Erro ao carregar usuário: $e');
    }
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  void _signOut() {
    Provider.of<UserProvider>(context, listen: false).setUserId(-1);
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Petshop'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _signOut,
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const [
          AgendaScreen(),
          PetsScreen(),
          UserScreen(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
