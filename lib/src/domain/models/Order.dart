import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/models/OrderUpdate.dart';
import 'package:app/src/domain/models/Table.dart' as TableModel;
import 'package:flutter/material.dart';

enum OrderType { delivery, dineIn, pickUpWait }

enum OrderStatus { creado, preparandose, preparada, finalizada, cancelada }

class Order {
  final int id;
  final OrderType orderType;
  final OrderStatus status;
  final double? amountPaid;
  final DateTime creationDate;
  final double? total;
  final String? comments;
  final String? phoneNumber;
  final String? address;
  final String? customerName;
  TableModel.Table? table;
  List<OrderItem>? orderItems;
  List<OrderUpdate>? orderUpdates;

  Order({
    required this.id,
    required this.orderType,
    required this.status,
    this.amountPaid,
    required this.creationDate,
    this.total,
    this.comments,
    this.phoneNumber,
    this.address,
    this.customerName,
    this.table,
    this.orderItems,
    this.orderUpdates,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderType: OrderType.values
          .firstWhere((e) => e.toString().split(".").last == json['orderType']),
      status: OrderStatus.values
          .firstWhere((e) => e.toString().split(".").last == json['status']),
      amountPaid: json['amountPaid']?.toDouble(),
      creationDate: DateTime.parse(json['creationDate']),
      total: json['total']?.toDouble(),
      comments: json['comments'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      customerName: json['customerName'],
      table: json['table'] != null
          ? TableModel.Table.fromJson(json['table'])
          : null,
      orderItems: json['orderItems'] != null
          ? (json['orderItems'] as List)
              .map((i) => OrderItem.fromJson(i))
              .toList()
          : null,
      orderUpdates: json['orderUpdates'] != null
          ? (json['orderUpdates'] as List)
              .map((i) => OrderUpdate.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['orderType'] = orderType.toString().split(".").last;
    data['status'] = status.toString().split(".").last;
    data['amountPaid'] = amountPaid;
    data['creationDate'] = creationDate.toIso8601String();
    data['total'] = total;
    data['comments'] = comments;
    data['phoneNumber'] = phoneNumber;
    data['address'] = address;
    data['customerName'] = customerName;
    if (table != null) data['table'] = table!.toJson();
    if (orderItems != null) {
      data['orderItems'] = orderItems!.map((v) => v.toJson()).toList();
    }
    if (orderUpdates != null) {
      data['orderUpdates'] = orderUpdates!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
