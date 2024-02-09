import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/utils/Resource.dart';

abstract class OrdersRepository {
  Future<Resource<List<Order>>> fetchOpenOrders();
  Future<Resource<Order>> createOrder(Order order);
  Future<Resource<void>> updateOrder(Order order);
  Future<Resource<void>> deleteOrder(String orderId);
}
