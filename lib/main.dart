import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_aula/providers/user_provider.dart';
import 'package:app_aula/screens/login.dart';
import 'package:app_aula/screens/home.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Aula',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        '/home': (context) => const HomePage(),
      },
    );
  }
}
