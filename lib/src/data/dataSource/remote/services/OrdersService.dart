import 'dart:convert';
import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/models/OrderItem.dart';
import 'package:http/http.dart' as http;
import 'package:app/src/data/api/ApiConfig.dart';
import 'package:app/src/domain/utils/Resource.dart';

class OrdersService {
  Future<Resource<Order>> createOrder(Order order) async {
    try {
      String apiEcommerce = await ApiConfig.getApiEcommerce();
      Uri url = Uri.http(apiEcommerce, '/orders');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(order.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Order createdOrder = Order.fromJson(json.decode(response.body));
        return Success(createdOrder);
      } else {
        return Error("Error al crear la orden: ${response.body}");
      }
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Resource<List<Order>>> getOpenOrders() async {
    try {
      String apiEcommerce = await ApiConfig.getApiEcommerce();
      Uri url = Uri.http(apiEcommerce, '/orders/open');
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        print(response.body);
        List<dynamic> data = (json.decode(response.body) as List<dynamic>);
        List<Order> orders =
            data.map((orderJson) => Order.fromJson(orderJson)).toList();
        return Success(orders);
      } else {
        return Error("Error al obtener las órdenes abiertas: ${response.body}");
      }
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Resource<Order>> updateOrder(
      int orderId, Map<String, dynamic> updateData) async {
    try {
      String apiEcommerce = await ApiConfig.getApiEcommerce();
      Uri url = Uri.http(apiEcommerce, '/orders/$orderId');
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(updateData),
      );
      if (response.statusCode == 200) {
        Order updatedOrder = Order.fromJson(json.decode(response.body));
        return Success(updatedOrder);
      } else {
        return Error("Error al actualizar la orden: ${response.body}");
      }
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Resource<Order>> updateOrderStatus(Order order) async {
    try {
      String apiEcommerce = await ApiConfig.getApiEcommerce();
      Uri url = Uri.http(apiEcommerce, '/orders/${order.id}/status');
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(order.toJson()),
      );
      if (response.statusCode == 200) {
        Order updatedOrder = Order.fromJson(json.decode(response.body));
        return Success(updatedOrder);
      } else {
        return Error(
            "Error al actualizar el estado de la orden: ${response.body}");
      }
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Resource<OrderItem>> updateOrderItemStatus(OrderItem orderItem) async {
    try {
      print('Updatingdddds order item status');
      String apiEcommerce = await ApiConfig.getApiEcommerce();
      Uri url =
          Uri.http(apiEcommerce, '/orders/orderitems/${orderItem.id}/status');
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(orderItem.toJson()),
      );
      print('response: $response');
      if (response.statusCode == 200) {
        OrderItem updatedOrderItem =
            OrderItem.fromJson(json.decode(response.body));
        return Success(updatedOrderItem);
      } else {
        return Error(
            "Error al actualizar el estado del ítem de la orden: ${response.body}");
      }
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Resource<void>> synchronizeData() async {
    try {
      String apiEcommerce = await ApiConfig.getApiEcommerce();
      Uri url = Uri.http(apiEcommerce, '/orders/synchronize');
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        return Success(
            null); // No hay objeto de respuesta específico, así que devolvemos null con Success.
      } else {
        return Error("Error al sincronizar los datos: ${response.body}");
      }
    } catch (e) {
      return Error(e.toString());
    }
  }
}
