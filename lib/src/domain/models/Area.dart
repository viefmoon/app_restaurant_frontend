import 'Table.dart';

class Area {
  final int id;
  final String name;
  List<Table>? tables;

  Area({required this.id, required this.name, this.tables});

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'],
      name: json['name'],
      tables: json['tables'] != null
          ? (json['tables'] as List).map((i) => Table.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.tables != null) {
      data['tables'] = this.tables!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
