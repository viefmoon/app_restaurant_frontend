import 'package:app/src/data/dataSource/remote/services/OrdersService.dart';
import 'package:app/src/domain/models/Order.dart';
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
}
