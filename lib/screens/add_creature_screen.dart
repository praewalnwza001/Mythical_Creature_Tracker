import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/creature.dart';
import '../providers/creature_provider.dart';

class AddCreatureScreen extends StatefulWidget {
  static const String routeName = '/add-creature';
  final Creature? existing;

  const AddCreatureScreen({super.key, this.existing});

  @override
  State<AddCreatureScreen> createState() => _AddCreatureScreenState();
}

class _AddCreatureScreenState extends State<AddCreatureScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _originCtrl = TextEditingController();
  final _elementCtrl = TextEditingController();
  final _powerCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
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
    if (!_formKey.currentState!.validate()) return;

    final name = _nameCtrl.text.trim();
    final origin = _originCtrl.text.trim();
    final element = _elementCtrl.text.trim();
    final power = _powerCtrl.text.trim();
    final desc = _descCtrl.text.trim();

    final provider = Provider.of<CreatureProvider>(context, listen: false);

    if (widget.existing == null) {
      await provider.addCreature(
        Creature(
          name: name,
          origin: origin,
          element: element,
          power: power,
          description: desc,
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('บันทึกข้อมูลเรียบร้อย')),
        );
      }
    } else {
      // แก้ไข
      await provider.updateCreature(
        Creature(
          id: widget.existing!.id,
          name: name,
          origin: origin,
          element: element,
          power: power,
          description: desc,
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('บันทึกการแก้ไขเรียบร้อย')),
        );
      }
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'แก้ไขสัตว์ในตำนาน' : 'เพิ่มสัตว์ในตำนาน'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F5FF), Color(0xFFFFFFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'รายละเอียดสัตว์ในตำนาน',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'ชื่อ',
                      hintText: 'เช่น Naga, Garuda, Phoenix',
                      prefixIcon: Icon(Icons.pets_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'กรอกชื่อ' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _originCtrl,
                    decoration: const InputDecoration(
                      labelText: 'ต้นกำเนิด',
                      hintText: 'เช่น Thailand / Laos',
                      prefixIcon: Icon(Icons.public_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'กรอกต้นกำเนิด' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _elementCtrl,
                    decoration: const InputDecoration(
                      labelText: 'ธาตุ',
                      hintText: 'เช่น Fire / Water / Earth / Air',
                      prefixIcon: Icon(Icons.flash_on_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'กรอกธาตุ' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _powerCtrl,
                    decoration: const InputDecoration(
                      labelText: 'พลังพิเศษ',
                      hintText: 'เช่น Fire Breath, Rebirth from Ashes',
                      prefixIcon: Icon(Icons.auto_awesome_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'กรอกพลังพิเศษ'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descCtrl,
                    decoration: const InputDecoration(
                      labelText: 'รายละเอียด (ไม่บังคับ)',
                      hintText: 'คำอธิบายสั้น ๆ เกี่ยวกับสัตว์ตัวนี้',
                      prefixIcon: Icon(Icons.notes_outlined),
                    ),
                    maxLines: 3,
                  ),

                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.save_outlined),
                      label: Text(isEdit ? 'บันทึกการแก้ไข' : 'บันทึก'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
