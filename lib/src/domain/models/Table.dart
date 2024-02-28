import 'Area.dart';

enum Status { Disponible, Ocupada }

class Table {
  final int id;
  final int number;
  final Status status;
  Area? area;

  Table({
    required this.id,
    required this.number,
    required this.status,
    this.area,
  });

  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(
      id: json['id'],
      number: json['number'],
      status: Status.values
          .firstWhere((e) => e.toString().split('.').last == json['status']),
      area: json['area'] != null ? Area.fromJson(json['area']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['number'] = number;
    data['status'] = status.toString().split('.').last;
    if (area != null) {
      data['area'] = area!.toJson();
    }
    return data;
  }
}
