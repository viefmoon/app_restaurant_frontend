import 'dart:convert';
import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/models/OrderItem.dart';
import 'package:http/http.dart' as http;
import 'package:app/src/data/api/ApiConfig.dart';
import 'package:app/src/domain/utils/Resource.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/src/domain/models/OrderItemSummary.dart'; // Asegúrate de definir este modelo

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
        return Success<Order>(createdOrder);
      } else {
        return Error<Order>("Error al crear la orden: ${response.body}");
      }
    } catch (e) {
      return Error<Order>(e.toString());
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

  Future<Resource<List<Order>>> getClosedOrders() async {
    try {
      String apiEcommerce = await ApiConfig.getApiEcommerce();
      Uri url = Uri.http(apiEcommerce, '/orders/closed');
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body) as List<dynamic>;
        List<Order> orders =
            data.map((orderJson) => Order.fromJson(orderJson)).toList();
        return Success(orders);
      } else {
        return Error("Error al obtener las órdenes cerradas: ${response.body}");
      }
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Resource<List<Order>>> getDeliveryOrders() async {
    try {
      String apiEcommerce = await ApiConfig.getApiEcommerce();
      Uri url = Uri.http(apiEcommerce, '/orders/delivery');
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body) as List<dynamic>;
        List<Order> orders =
            data.map((orderJson) => Order.fromJson(orderJson)).toList();
        return Success(orders);
      } else {
        return Error(
            "Error al obtener las órdenes de entrega: ${response.body}");
      }
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Resource<Order>> getOrderForUpdate(int orderId) async {
    try {
      print("Obteniendo orden para actualizar");
      String apiEcommerce = await ApiConfig.getApiEcommerce();
      Uri url = Uri.http(apiEcommerce, '/orders/$orderId');
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        Order order = Order.fromJson(json.decode(response.body));
        print(
            "orden: ${json.encode(order.toJson())}"); // Modificado para imprimir la orden serializada
        return Success(order);
      } else {
        return Error(
            "Error al obtener la orden para actualizar: ${response.body}");
      }
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Resource<Order>> updateOrder(Order order) async {
    try {
      String apiEcommerce = await ApiConfig.getApiEcommerce();

      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('user');

      // Deserializar userData desde JSON
      final userData = json.decode(userDataString!);
      final userName = userData['user']['name'];

      // Incluir el nombre del usuario como parámetro de consulta en la URL
      Uri url =
          Uri.http(apiEcommerce, '/orders/${order.id}', {'userName': userName});

      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(order.toJson()),
      );
      if (response.statusCode == 200) {
        print('response.body: ${response.body}');
        Order updatedOrder = Order.fromJson(json.decode(response.body));
        return Success(updatedOrder);
      } else {
        return Error("Error al actualizar la orden: ${response.body}");
      }
    } catch (e) {
      print('Errors: $e');
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

  Future<Resource<List<OrderItemSummary>>> findOrderItemsWithCounts(
      {List<String>? subcategories, int? ordersLimit}) async {
    print("fetching summary2");
    try {
      String apiEcommerce = await ApiConfig.getApiEcommerce();
      Map<String, dynamic> queryParams = {};
      if (subcategories != null && subcategories.isNotEmpty) {
        queryParams['subcategories'] = subcategories.join(',');
      }
      if (ordersLimit != null) {
        queryParams['ordersLimit'] = ordersLimit.toString();
      }
      Uri url = Uri.http(apiEcommerce, '/orders/items/counts', queryParams);

      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      print("response: ${response.statusCode}");
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<OrderItemSummary> summaries = data
            .map((itemJson) => OrderItemSummary.fromJson(itemJson))
            .toList();
        print("summariesssss: $summaries");
        return Success(summaries);
      } else {
        return Error(
            "Error al obtener el resumen de los ítems de la orden: ${response.body}");
      }
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Resource<Order>> registerPayment(int orderId, double amount) async {
    try {
      String apiEcommerce = await ApiConfig.getApiEcommerce();
      Uri url = Uri.http(apiEcommerce, '/orders/$orderId/payment');
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"amount": amount}),
      );
      if (response.statusCode == 200) {
        Order updatedOrder = Order.fromJson(json.decode(response.body));
        return Success(updatedOrder);
      } else {
        return Error("Error al registrar el pago: ${response.body}");
      }
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Resource<Order>> completeOrder(int orderId) async {
    try {
      String apiEcommerce = await ApiConfig.getApiEcommerce();
      Uri url = Uri.http(apiEcommerce, '/orders/$orderId/complete');
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        Order completedOrder = Order.fromJson(json.decode(response.body));
        return Success(completedOrder);
      } else {
        return Error("Error al completar la orden: ${response.body}");
      }
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Resource<Order>> cancelOrder(int orderId) async {
    try {
      print("cancelling order");
      String apiEcommerce = await ApiConfig.getApiEcommerce();
      Uri url = Uri.http(apiEcommerce, '/orders/$orderId/cancel');
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
      );
      print("response: ${response.statusCode}");
      if (response.statusCode == 200) {
        Order canceledOrder = Order.fromJson(json.decode(response.body));
        return Success(canceledOrder);
      } else {
        return Error("Error al cancelar la orden: ${response.body}");
      }
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Resource<void>> markOrdersAsInDelivery(List<Order> orders) async {
    try {
      String apiEcommerce = await ApiConfig.getApiEcommerce();
      Uri url = Uri.http(apiEcommerce, '/orders/delivery/mark-in-delivery');
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(orders.map((order) => order.toJson()).toList()),
      );
      if (response.statusCode == 200) {
        return Success(
            null); // No hay objeto de respuesta específico, así que devolvemos null con Success.
      } else {
        return Error(
            "Error al marcar las órdenes como en reparto: ${response.body}");
      }
    } catch (e) {
      return Error(e.toString());
    }
  }
}
