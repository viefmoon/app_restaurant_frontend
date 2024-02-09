import 'package:flutter/material.dart';

class Order {
  final String id;
  final String
      type; // Considera usar un enum o una clase para tipos específicos
  final DateTime date;
  final List<String>
      items; // Considera crear un modelo específico para los ítems
  final double total;

  Order(
      {required this.id,
      required this.type,
      required this.date,
      required this.items,
      required this.total});

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
        type: json['type'],
        date: DateTime.parse(json['date']),
        items: List<String>.from(json['items']),
        total: json['total'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'date': date.toIso8601String(),
        'items': items,
        'total': total,
      };
}
