import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/models/OrderUpdate.dart';
import 'package:app/src/domain/models/Table.dart' as TableModel;
import 'package:app/src/domain/models/Area.dart';

enum OrderType { delivery, dineIn, pickUpWait }

enum OrderStatus { created, in_preparation, prepared, finished, canceled }

class Order {
  final int? id;
  final OrderType? orderType;
  final OrderStatus? status;
  final double? amountPaid;
  final DateTime? creationDate;
  final double? totalCost;
  final String? comments;
  final DateTime? scheduledDeliveryTime;
  final String? phoneNumber;
  final String? deliveryAddress;
  final String? customerName;
  Area? area;
  TableModel.Table? table;
  List<OrderItem>? orderItems;
  List<OrderUpdate>? orderUpdates;

  Order({
    this.id,
    this.orderType,
    this.status,
    this.amountPaid,
    this.creationDate,
    this.totalCost,
    this.comments,
    this.scheduledDeliveryTime,
    this.phoneNumber,
    this.deliveryAddress,
    this.customerName,
    this.area,
    this.table,
    this.orderItems,
    this.orderUpdates,
  });

  Order copyWith({
    int? id,
    OrderType? orderType,
    OrderStatus? status,
    double? amountPaid,
    DateTime? creationDate,
    double? totalCost,
    String? comments,
    DateTime? scheduledDeliveryTime,
    String? phoneNumber,
    String? deliveryAddress,
    String? customerName,
    Area? area,
    TableModel.Table? table,
    List<OrderItem>? orderItems,
    List<OrderUpdate>? orderUpdates,
  }) {
    return Order(
      id: id ?? this.id,
      orderType: orderType ?? this.orderType,
      status: status ?? this.status,
      amountPaid: amountPaid ?? this.amountPaid,
      creationDate: creationDate ?? this.creationDate,
      totalCost: totalCost ?? this.totalCost,
      comments: comments ?? this.comments,
      scheduledDeliveryTime:
          scheduledDeliveryTime ?? this.scheduledDeliveryTime,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      customerName: customerName ?? this.customerName,
      area: area ?? this.area,
      table: table ?? this.table,
      orderItems: orderItems ?? this.orderItems,
      orderUpdates: orderUpdates ?? this.orderUpdates,
    );
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderType: OrderType.values.firstWhere(
          (e) => e.toString().split(".").last == json['orderType'],
          orElse: () => OrderType.delivery),
      status: OrderStatus.values.firstWhere(
          (e) => e.toString().split(".").last == json['status'],
          orElse: () => OrderStatus.finished), //
      amountPaid: json['price'] != null ? double.tryParse(json['price']) : null,
      creationDate: json['creationDate'] != null
          ? DateTime.tryParse(json['creationDate'])
          : null,
      totalCost:
          json['totalCost'] != null ? double.tryParse(json['totalCost']) : null,
      comments: json['comments'],
      scheduledDeliveryTime: json['scheduledDeliveryTime'] != null
          ? DateTime.tryParse(json['scheduledDeliveryTime'])
          : null,
      phoneNumber: json['phoneNumber'],
      deliveryAddress: json['deliveryAddress'],
      customerName: json['customerName'],
      area: json['area'] != null ? Area.fromJson(json['area']) : null,
      table: json['table'] != null
          ? TableModel.Table.fromJson(json['table'])
          : null,
      orderItems: json['orderItems'] != null
          ? (json['orderItems'] as List)
              .map((i) => OrderItem.fromJson(i))
              .toList()
          : null,
      // orderUpdates: json['orderUpdates'] != null
      //     ? (json['orderUpdates'] as List)
      //         .map((i) => OrderUpdate.fromJson(i))
      //         .toList()
      //     : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['orderType'] = orderType.toString().split(".").last;
    data['status'] = status.toString().split(".").last;
    data['amountPaid'] = amountPaid;
    data['creationDate'] = creationDate?.toIso8601String();
    data['totalCost'] = totalCost;
    data['comments'] = comments;
    data['scheduledDeliveryTime'] = scheduledDeliveryTime?.toIso8601String();
    data['phoneNumber'] = phoneNumber;
    data['deliveryAddress'] = deliveryAddress;
    data['customerName'] = customerName;
    data['area'] = area?.toJson();
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
