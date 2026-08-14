
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TawafuqApp());
}

class TawafuqApp extends StatelessWidget {
  const TawafuqApp({super.key});

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF1677FF);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'توافقات الأجهزة',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: blue),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: HomeScreen(),
      ),
    );
  }
}
