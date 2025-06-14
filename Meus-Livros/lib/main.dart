import 'package:flutter/material.dart';
import 'Home.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meus Livros',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFDFF5E3), // verde claro
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF14532D), // verde escuro
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF14532D), // botão e destaque
          secondary: Colors.amber, // estrelas
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.amber,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF14532D), // botão flutuante
        ),
      ),
      home: const Home(),
    );
  }
}
