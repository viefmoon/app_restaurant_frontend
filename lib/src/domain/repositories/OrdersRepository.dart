import 'package:app/src/domain/utils/Resource.dart';
import 'package:app/src/domain/models/Order.dart';

abstract class OrdersRepository {
  Future<Resource<Order>> createOrder(Order order);
  Future<Resource<List<Order>>> getOpenOrders();
}
