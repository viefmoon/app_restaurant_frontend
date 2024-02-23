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
    data['id'] = this.id;
    data['number'] = this.number;
    data['status'] = this.status.toString().split('.').last;
    if (this.area != null) {
      data['area'] = this.area!.toJson();
    }
    return data;
  }
}
