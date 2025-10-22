import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/creature.dart';
import '../providers/creature_provider.dart';

class AddCreatureScreen extends StatefulWidget {
  static const String routeName = '/add-creature';
  final Creature? existing; // ถ้ามี = แก้ไข, ถ้าไม่มี = เพิ่มใหม่
  const AddCreatureScreen({super.key, this.existing});

  @override
  State<AddCreatureScreen> createState() => _AddCreatureScreenState();
}

class _AddCreatureScreenState extends State<AddCreatureScreen> {
  final _nameCtrl = TextEditingController();
  final _originCtrl = TextEditingController();
  final _elementCtrl = TextEditingController();
  final _powerCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ถ้าเป็นโหมดแก้ไข ให้เติมค่าลงช่อง
    final e = widget.existing;
    if (e != null) {
      _nameCtrl.text = e.name;
      _originCtrl.text = e.origin;
      _elementCtrl.text = e.element;
      _powerCtrl.text = e.power;
      _descCtrl.text = e.description;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _originCtrl.dispose();
    _elementCtrl.dispose();
    _powerCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final origin = _originCtrl.text.trim();
    final element = _elementCtrl.text.trim();
    final power = _powerCtrl.text.trim();
    final desc = _descCtrl.text.trim();

    if (name.isEmpty || origin.isEmpty || element.isEmpty || power.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรอกข้อมูลให้ครบ (ชื่อ/ต้นกำเนิด/ธาตุ/พลัง)')),
      );
      return;
    }

    final provider = Provider.of<CreatureProvider>(context, listen: false);

    if (widget.existing == null) {
      // เพิ่มใหม่
      await provider.addCreature(Creature(
        name: name,
        origin: origin,
        element: element,
        power: power,
        description: desc,
      ));
    } else {
      // แก้ไข
      await provider.updateCreature(Creature(
        id: widget.existing!.id,
        name: name,
        origin: origin,
        element: element,
        power: power,
        description: desc,
      ));
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'แก้ไขสัตว์ในตำนาน' : 'เพิ่มสัตว์ในตำนาน')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'ชื่อ')),
            TextField(controller: _originCtrl, decoration: const InputDecoration(labelText: 'ต้นกำเนิด')),
            TextField(controller: _elementCtrl, decoration: const InputDecoration(labelText: 'ธาตุ (เช่น Fire/Water/Earth/Air)')),
            TextField(controller: _powerCtrl, decoration: const InputDecoration(labelText: 'พลังพิเศษ')),
            TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'รายละเอียด (ไม่บังคับ)')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _save,
              child: Text(isEdit ? 'บันทึกการแก้ไข' : 'บันทึก'),
            ),
          ],
        ),
      ),
    );
  }
}
