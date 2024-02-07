import 'package:ecommerce_flutter/src/domain/repositories/OrdersRepository.dart';

class GetOrdersUseCase {

  OrdersRepository ordersRepository;

  GetOrdersUseCase(this.ordersRepository);

  run() => ordersRepository.getOrders();

}