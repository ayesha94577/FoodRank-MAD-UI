import 'package:flutter/material.dart';

import 'screens/home_screens.dart';
import 'screens/welcome_screen.dart';

const ink = Color(0xFFF4F4F5);
const gold = Color(0xFFFFB03A);
const orange = Color(0xFFFF6B35);
const cyan = Color(0xFF22D3EE);
const cream = Color(0xFF121418);
const surface = Color(0xFF1C2027);
const muted = Color(0xFFA1A1AA);
const line = Color(0xFF30343D);
const appContentMaxWidth = 1160.0;

void main() {
  runApp(const FoodRankApp());
}

class FoodRankApp extends StatelessWidget {
  const FoodRankApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'FoodRank Islamabad',
    debugShowCheckedModeBanner: false,
    builder: (context, child) => ColoredBox(
      color: cream,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: appContentMaxWidth),
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    ),
    initialRoute: '/home',
    routes: {
      '/': (_) => const WelcomeScreen(),
      '/home': (_) => const MainShell(),
    },
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: cream,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: orange,
        secondary: cyan,
        surface: surface,
        error: Color(0xFFFF6B6B),
      ),
      fontFamily: 'Roboto',
      textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: ink,
        displayColor: ink,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: cream,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: cyan, width: 1.5),
        ),
      ),
    ),
  );
}
