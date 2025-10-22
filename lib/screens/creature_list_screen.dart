import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/creature_provider.dart';
import '../models/creature.dart';
import 'add_creature_screen.dart';

class CreatureListScreen extends StatefulWidget {
  const CreatureListScreen({super.key});

  @override
  State<CreatureListScreen> createState() => _CreatureListScreenState();
}

class _CreatureListScreenState extends State<CreatureListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<CreatureProvider>(context, listen: false).loadCreatures());
  }

  Future<void> _confirmDelete(BuildContext context, Creature creature) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('ยืนยันการลบ'),
          content: Text('คุณต้องการลบ "${creature.name}" ใช่หรือไม่?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('ลบ'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await Provider.of<CreatureProvider>(context, listen: false)
          .deleteCreature(creature.id!);

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ลบ "${creature.name}" เรียบร้อยแล้ว')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreatureProvider>(context);
    final items = provider.creatures;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mythical Creatures'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F3FF), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: items.isEmpty
            ? const Center(
                child: Text(
                  'ยังไม่มีข้อมูล',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final c = items[i];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: Color(0xFFE6E1FF)),
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundColor: const Color(0xFFE6E1FF),
                        child: Text(
                          c.name.isNotEmpty
                              ? c.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF6A5AE0),
                            fontSize: 18,
                          ),
                        ),
                      ),
                      title: Text(
                        c.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700, // ชื่อให้เด่นหน่อย
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '🌍 ${c.origin}  •  ⚡ ${c.element}  •  ✨ ${c.power}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddCreatureScreen(existing: c),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _confirmDelete(context, c),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddCreatureScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}