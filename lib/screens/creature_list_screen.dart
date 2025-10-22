import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mythical_creature_tracker/providers/creature_provider.dart';
import '../models/creature.dart';
import './add_creature_screen.dart';

class CreatureListScreen extends StatefulWidget {
  static const String routeName = '/';
  const CreatureListScreen({super.key});

  @override
  State<CreatureListScreen> createState() => _CreatureListScreenState();
}

class _CreatureListScreenState extends State<CreatureListScreen> {
  @override
  void initState() {
    super.initState();
    // โหลดข้อมูลจาก DB เมื่อเข้าหน้านี้
    Future.microtask(() =>
        Provider.of<CreatureProvider>(context, listen: false).loadCreatures());
  }

  void _confirmDelete(BuildContext context, Creature c) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('ยืนยันการลบ'),
          content: Text('ต้องการลบ "${c.name}" ใช่ไหม?'),
          actions: [
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('ลบ', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await Provider.of<CreatureProvider>(context, listen: false)
                    .deleteCreature(c.id!);
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ลบเรียบร้อย')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreatureProvider>(context);
    final items = provider.creatures;

    return Scaffold(
      appBar: AppBar(title: const Text('Mythical Creatures')),
      body: items.isEmpty
          ? const Center(child: Text('ยังไม่มีข้อมูล'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, i) {
                final c = items[i];
                return ListTile(
                  title: Text(c.name),
                  subtitle: Text('${c.origin} • ${c.element} • ${c.power}'),
                  onTap: () async {
                    // แก้ไข: ส่ง creature ไปหน้า add/edit
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddCreatureScreen(existing: c),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(context, c),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // เพิ่มข้อมูลใหม่
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
