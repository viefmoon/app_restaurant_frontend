import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/models/ProductObservation.dart';

class SelectedProductObservation {
  final int id;
  OrderItem? orderItem;
  ProductObservation? productObservation;

  SelectedProductObservation({
    required this.id,
    this.orderItem,
    this.productObservation,
  });

  factory SelectedProductObservation.fromJson(Map<String, dynamic> json) {
    return SelectedProductObservation(
      id: json['id'],
      // Nota: Necesitarás definir la deserialización para OrderItem si planeas usarla directamente
      orderItem: json['orderItem'] != null
          ? OrderItem.fromJson(json['orderItem'])
          : null,
      productObservation: json['productObservation'] != null
          ? ProductObservation.fromJson(json['productObservation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    if (orderItem != null) {
      // Nota: Asegúrate de tener un método toJson en OrderItem si planeas incluirlo
      data['orderItem'] = orderItem!.toJson();
    }
    if (productObservation != null) {
      data['productObservation'] = productObservation!.toJson();
    }
    return data;
  }
}
