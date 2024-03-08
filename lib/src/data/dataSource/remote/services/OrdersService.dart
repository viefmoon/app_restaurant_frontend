import 'dart:convert';
import 'package:app/src/domain/models/Order.dart';
import 'package:http/http.dart' as http;
import 'package:app/src/data/api/ApiConfig.dart';
import 'package:app/src/domain/utils/Resource.dart';

class OrdersService {
  Future<Resource<Order>> createOrder(Order order) async {
    print('order: $order');
    try {
      Uri url = Uri.http(ApiConfig.API_ECOMMERCE, '/orders');
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
      Uri url = Uri.http(ApiConfig.API_ECOMMERCE, '/orders/open');
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
}
