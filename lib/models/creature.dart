class Creature {
  final int? id;
  final String name;        // ชื่อสัตว์ในตำนาน
  final String origin;      // แหล่งกำเนิด
  final String element;     // ธาตุ (Fire/Water/Earth/Air ฯลฯ)
  final String power;       // พลังพิเศษ
  final String description; // รายละเอียด

  Creature({
    this.id,
    required this.name,
    required this.origin,
    required this.element,
    required this.power,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'origin': origin,
      'element': element,
      'power': power,
      'description': description,
    };
  }

  factory Creature.fromMap(Map<String, dynamic> map) {
    return Creature(
      id: map['id'] as int?,
      name: map['name'] as String,
      origin: map['origin'] as String,
      element: map['element'] as String,
      power: map['power'] as String,
      description: map['description'] as String,
    );
  }
}
