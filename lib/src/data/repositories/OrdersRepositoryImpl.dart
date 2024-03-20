import 'package:app/src/data/dataSource/remote/services/OrdersService.dart';
import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/models/OrderItem.dart';
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
}
