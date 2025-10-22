import 'package:flutter/foundation.dart';
import '../helpers/database_helper.dart';
import '../models/creature.dart';

class CreatureProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<Creature> _creatures = [];

  List<Creature> get creatures => _creatures;

  Future<void> loadCreatures() async {
    _creatures = await _db.getAllCreatures();
    notifyListeners();
  }

  Future<void> addCreature(Creature c) async {
    await _db.insertCreature(c);
    await loadCreatures();
  }

  Future<void> updateCreature(Creature c) async {
    if (c.id == null) return;
    await _db.updateCreature(c);
    await loadCreatures();
  }

  Future<void> deleteCreature(int id) async {
    await _db.deleteCreature(id);
    await loadCreatures();
  }
}
