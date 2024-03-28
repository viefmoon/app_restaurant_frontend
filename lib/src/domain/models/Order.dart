import 'package:app/src/domain/models/OrderAdjustment.dart';
import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/models/OrderUpdate.dart';
import 'package:app/src/domain/models/Table.dart' as TableModel;
import 'package:app/src/domain/models/Area.dart';

enum OrderType { delivery, dineIn, pickUpWait }

enum OrderStatus { created, in_preparation, prepared, finished, canceled }

enum OrderPreparationStatus { created, in_preparation, prepared, not_required }

class Order {
  final int? id;
  final OrderType? orderType;
  final OrderStatus? status;
  final OrderPreparationStatus? barPreparationStatus;
  final OrderPreparationStatus? burgerPreparationStatus;
  final OrderPreparationStatus? pizzaPreparationStatus;
  final double? amountPaid;
  final DateTime? creationDate;
  final double? totalCost;
  final String? comments;
  final DateTime? scheduledDeliveryTime;
  final String? phoneNumber;
  final String? deliveryAddress;
  final String? customerName;
  final String? createdBy;
  Area? area;
  TableModel.Table? table;
  List<OrderItem>? orderItems;
  List<OrderAdjustment>? orderAdjustments;
  List<OrderUpdate>? orderUpdates;

  void updateItems(List<OrderItem> newItems) {
    orderItems = newItems;
  }

  Order({
    this.id,
    this.orderType,
    this.status,
    this.barPreparationStatus,
    this.burgerPreparationStatus,
    this.pizzaPreparationStatus,
    this.amountPaid,
    this.creationDate,
    this.totalCost,
    this.comments,
    this.scheduledDeliveryTime,
    this.phoneNumber,
    this.deliveryAddress,
    this.customerName,
    this.createdBy,
    this.area,
    this.table,
    this.orderItems,
    this.orderAdjustments,
    this.orderUpdates,
  });

  Order copyWith({
    int? id,
    OrderType? orderType,
    OrderStatus? status,
    OrderPreparationStatus? barPreparationStatus,
    OrderPreparationStatus? burgerPreparationStatus,
    OrderPreparationStatus? pizzaPreparationStatus,
    double? amountPaid,
    DateTime? creationDate,
    double? totalCost,
    String? comments,
    DateTime? scheduledDeliveryTime,
    String? phoneNumber,
    String? deliveryAddress,
    String? customerName,
    String? createdBy,
    Area? area,
    TableModel.Table? table,
    List<OrderItem>? orderItems,
    List<OrderAdjustment>? orderAdjustments,
    List<OrderUpdate>? orderUpdates,
  }) {
    return Order(
      id: id ?? this.id,
      orderType: orderType ?? this.orderType,
      status: status ?? this.status,
      barPreparationStatus: barPreparationStatus ?? this.barPreparationStatus,
      burgerPreparationStatus:
          burgerPreparationStatus ?? this.burgerPreparationStatus,
      pizzaPreparationStatus:
          pizzaPreparationStatus ?? this.pizzaPreparationStatus,
      amountPaid: amountPaid ?? this.amountPaid,
      creationDate: creationDate ?? this.creationDate,
      totalCost: totalCost ?? this.totalCost,
      comments: comments ?? this.comments,
      scheduledDeliveryTime:
          scheduledDeliveryTime ?? this.scheduledDeliveryTime,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      customerName: customerName ?? this.customerName,
      createdBy: createdBy ?? this.createdBy,
      area: area ?? this.area,
      table: table ?? this.table,
      orderItems: orderItems ?? this.orderItems,
      orderAdjustments: orderAdjustments ?? this.orderAdjustments,
      orderUpdates: orderUpdates ?? this.orderUpdates,
    );
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderType: json['orderType'] != null
          ? OrderType.values.firstWhere(
              (e) => e.toString().split(".").last == json['orderType'],
              orElse: () => OrderType.delivery)
          : OrderType.delivery,
      status: json['status'] != null
          ? OrderStatus.values.firstWhere(
              (e) => e.toString().split(".").last == json['status'],
              orElse: () => OrderStatus.created)
          : OrderStatus.created,
      barPreparationStatus: json['barPreparationStatus'] != null
          ? OrderPreparationStatus.values.firstWhere(
              (e) =>
                  e.toString().split(".").last == json['barPreparationStatus'],
              orElse: () => OrderPreparationStatus.created)
          : OrderPreparationStatus.created,
      burgerPreparationStatus: json['burgerPreparationStatus'] != null
          ? OrderPreparationStatus.values.firstWhere(
              (e) =>
                  e.toString().split(".").last ==
                  json['burgerPreparationStatus'],
              orElse: () => OrderPreparationStatus.created)
          : OrderPreparationStatus.created,
      pizzaPreparationStatus: json['pizzaPreparationStatus'] != null
          ? OrderPreparationStatus.values.firstWhere(
              (e) =>
                  e.toString().split(".").last ==
                  json['pizzaPreparationStatus'],
              orElse: () => OrderPreparationStatus.created)
          : OrderPreparationStatus.created,
      amountPaid: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
      creationDate: json['creationDate'] != null
          ? DateTime.tryParse(json['creationDate'])
          : null,
      totalCost: json['totalCost'] != null
          ? double.tryParse(json['totalCost'].toString())
          : null,
      comments: json['comments'],
      scheduledDeliveryTime: json['scheduledDeliveryTime'] != null
          ? DateTime.tryParse(json['scheduledDeliveryTime'])
          : null,
      phoneNumber: json['phoneNumber'],
      deliveryAddress: json['deliveryAddress'],
      customerName: json['customerName'],
      createdBy: json['createdBy'],
      area: json['area'] != null
          ? Area.fromJson(json['area'] as Map<String, dynamic>)
          : null,
      table: json['table'] != null
          ? TableModel.Table.fromJson(json['table'] as Map<String, dynamic>)
          : null,
      orderItems: json['orderItems'] != null
          ? (json['orderItems'] as List)
              .map((i) => OrderItem.fromJson(i))
              .toList()
          : null,
      orderAdjustments: json['orderAdjustments'] != null
          ? (json['orderAdjustments'] as List)
              .map((i) => OrderAdjustment.fromJson(i))
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
    data['barPreparationStatus'] =
        barPreparationStatus.toString().split(".").last;
    data['burgerPreparationStatus'] =
        burgerPreparationStatus.toString().split(".").last;
    data['pizzaPreparationStatus'] =
        pizzaPreparationStatus.toString().split(".").last;
    data['amountPaid'] = amountPaid;
    data['creationDate'] = creationDate?.toIso8601String();
    data['totalCost'] = totalCost;
    data['comments'] = comments;
    data['scheduledDeliveryTime'] = scheduledDeliveryTime?.toIso8601String();
    data['phoneNumber'] = phoneNumber;
    data['deliveryAddress'] = deliveryAddress;
    data['customerName'] = customerName;
    data['createdBy'] = createdBy;
    data['area'] = area?.toJson();
    if (table != null) data['table'] = table!.toJson();
    if (orderItems != null) {
      data['orderItems'] = orderItems!.map((v) => v.toJson()).toList();
    }
    if (orderAdjustments != null) {
      data['orderAdjustments'] =
          orderAdjustments!.map((v) => v.toJson()).toList();
    }
    if (orderUpdates != null) {
      data['orderUpdates'] = orderUpdates!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
