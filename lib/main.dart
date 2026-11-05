import 'package:flutter/material.dart';

import 'views/inicio_view.dart';

const corFundo = Color(0xFF008080);
const corCinza = Color(0xFFC0C0C0);
const corAzul = Color(0xFF000080);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TarefasApp());
}

class TarefasApp extends StatelessWidget {
  const TarefasApp({super.key});

  @override
  Widget build(BuildContext context) {
    const borda = BorderSide(color: Colors.black, width: 1.5);

    return MaterialApp(
      title: 'Tarefas 2000',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: 'Tahoma',
        fontFamilyFallback: const ['Verdana', 'Arial', 'Roboto', 'sans-serif'],
        scaffoldBackgroundColor: corFundo,
        appBarTheme: const AppBarTheme(
          backgroundColor: corAzul,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          color: corCinza,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(side: borda),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: corCinza,
            foregroundColor: Colors.black,
            elevation: 0,
            shape: const RoundedRectangleBorder(side: borda),
            textStyle:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const InicioView(),
    );
  }
}
