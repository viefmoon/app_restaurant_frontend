import 'Area.dart';

enum Status { Disponible, Ocupada }

class Table {
  final int id; // 'id' ahora es no nulo
  final int number; // 'number' ahora es no nulo
  final Status? status;
  Area? area;

  Table({
    required this.id,
    required this.number,
    this.status,
    this.area,
  });

  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(
      id: json['id'], // Asumimos que 'id' siempre está presente
      number: json['number'], // Asumimos que 'number' siempre está presente
      status: json['status'] != null
          ? Status.values.firstWhere(
              (e) => e.toString().split('.').last == json['status'],
              orElse: () => Status.Disponible,
            )
          : null,
      area: json['area'] != null ? Area.fromJson(json['area']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['number'] = number;
    data['status'] = status?.toString().split('.').last;
    if (area != null) {
      data['area'] = area?.toJson();
    }
    return data;
  }
}
