import 'package:app/src/domain/models/Modifier.dart';

class ModifierType {
  final int id;
  final String name;
  final bool acceptsMultiple;
  List<Modifier>? modifiers;

  ModifierType({
    required this.id,
    required this.name,
    required this.acceptsMultiple,
    this.modifiers,
  });

  factory ModifierType.fromJson(Map<String, dynamic> json) {
    return ModifierType(
      id: json['id'],
      name: json['name'],
      acceptsMultiple: json['acceptsMultiple'],
      modifiers: json['modifiers'] != null
          ? (json['modifiers'] as List)
              .map((i) => Modifier.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'name': name,
      'acceptsMultiple': acceptsMultiple,
    };
    if (modifiers != null) {
      data['modifiers'] = modifiers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
