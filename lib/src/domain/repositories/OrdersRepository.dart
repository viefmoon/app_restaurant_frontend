import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/models/OrderItemSummary.dart';
import 'package:app/src/domain/utils/Resource.dart';
import 'package:app/src/domain/models/Order.dart';

abstract class OrdersRepository {
  Future<Resource<Order>> createOrder(Order order);
  Future<Resource<List<Order>>> getOpenOrders();
  Future<Resource<List<Order>>> getClosedOrders();
  Future<Resource<Order>> getOrderForUpdate(int orderId);
  Future<Resource<Order>> updateOrderStatus(Order order);
  Future<Resource<OrderItem>> updateOrderItemStatus(OrderItem orderItem);
  Future<Resource<Order>> updateOrder(Order order);
  Future<Resource<void>> synchronizeData();
  Future<Resource<List<OrderItemSummary>>> findOrderItemsWithCounts(
      {List<String>? subcategories, int? ordersLimit});
  Future<Resource<Order>> registerPayment(int orderId, double amount);
  Future<Resource<Order>> completeOrder(int orderId);
  Future<Resource<Order>> cancelOrder(int orderId);
  Future<Resource<List<Order>>> getDeliveryOrders();
  Future<Resource<void>> markOrdersAsInDelivery(List<Order> orders);
}
