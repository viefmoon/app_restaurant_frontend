import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/utils/Resource.dart';
import 'package:app/src/domain/models/Order.dart';

abstract class OrdersRepository {
  Future<Resource<Order>> createOrder(Order order);
  Future<Resource<List<Order>>> getOpenOrders();
  Future<Resource<Order>> updateOrderStatus(Order order);
  Future<Resource<OrderItem>> updateOrderItemStatus(OrderItem orderItem);
  Future<Resource<Order>> updateOrder(
      int orderId, Map<String, dynamic> updateData);
  Future<Resource<void>> synchronizeData();
}
