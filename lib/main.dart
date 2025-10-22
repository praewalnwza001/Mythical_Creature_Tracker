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
          primarySwatch: Colors.deepPurple,
        ),
        initialRoute: CreatureListScreen.routeName,
        routes: {
          CreatureListScreen.routeName: (_) => const CreatureListScreen(),
          AddCreatureScreen.routeName: (_) => const AddCreatureScreen(),
        },
      ),
    );
  }
}
