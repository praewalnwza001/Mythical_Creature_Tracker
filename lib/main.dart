import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/creature_provider.dart';
import 'screens/creature_list_screen.dart';
import 'screens/add_creature_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreatureProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mythical Creature Tracker',
        theme: ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  fontFamily: 'Prompt',
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontWeight: FontWeight.w700),
    titleMedium: TextStyle(fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontWeight: FontWeight.w400),
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 1,
    titleTextStyle: TextStyle(
      fontFamily: 'Prompt',
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    backgroundColor: Color(0xFF6A5AE0),
    foregroundColor: Colors.white,
  ),
),

        home: const CreatureListScreen(),
        routes: {
          AddCreatureScreen.routeName: (_) => const AddCreatureScreen(),
        },
      ),
    );
  }
}
