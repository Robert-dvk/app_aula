import 'package:app_aula/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:app_aula/components/custom_bottom_navigation_bar.dart';
import 'package:app_aula/screens/agenda.dart';
import 'package:app_aula/screens/pets.dart';
import 'package:app_aula/screens/user.dart';
import 'package:app_aula/providers/user_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;
  final PageController _pageController = PageController(initialPage: 2);
  final UserProvider _userProvider = UserProvider();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  void _signOut() {
    _userProvider.setUserId(-1);

   Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => LoginPage(),
    ),
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Petshop'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
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
        children: [
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
