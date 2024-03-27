import 'package:app/src/data/dataSource/remote/services/OrdersService.dart';
import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/models/OrderItemSummary.dart';
import 'package:app/src/domain/repositories/OrdersRepository.dart';
import 'package:app/src/domain/utils/Resource.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  OrdersService ordersService;

  OrdersRepositoryImpl(this.ordersService);

  @override
  Future<Resource<Order>> createOrder(Order order) async {
    return ordersService.createOrder(order);
  }

  @override
  Future<Resource<List<Order>>> getOpenOrders() async {
    return ordersService.getOpenOrders();
  }

  @override
  Future<Resource<Order>> getOrderForUpdate(int orderId) {
    return ordersService.getOrderForUpdate(orderId);
  }

  @override
  Future<Resource<Order>> updateOrderStatus(Order order) {
    return ordersService.updateOrderStatus(order);
  }

  @override
  Future<Resource<OrderItem>> updateOrderItemStatus(OrderItem orderItem) {
    return ordersService.updateOrderItemStatus(orderItem);
  }

  @override
  Future<Resource<Order>> updateOrder(Order order) {
    return ordersService.updateOrder(order);
  }

  @override
  Future<Resource<void>> synchronizeData() async {
    return ordersService.synchronizeData();
  }

  @override
  Future<Resource<List<OrderItemSummary>>> findOrderItemsWithCounts(
      {List<String>? subcategories, int? ordersLimit}) {
    return ordersService.findOrderItemsWithCounts(
        subcategories: subcategories, ordersLimit: ordersLimit);
  }

  @override
  Future<Resource<Order>> registerPayment(int orderId, double amount) {
    return ordersService.registerPayment(orderId, amount);
  }

  @override
  Future<Resource<Order>> completeOrder(int orderId) {
    return ordersService.completeOrder(orderId);
  }

  @override
  Future<Resource<Order>> cancelOrder(int orderId) {
    return ordersService.cancelOrder(orderId);
  }
}
