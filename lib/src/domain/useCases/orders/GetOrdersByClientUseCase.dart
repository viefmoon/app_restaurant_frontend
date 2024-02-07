import 'package:ecommerce_flutter/src/domain/repositories/OrdersRepository.dart';

class GetOrdersByClientUseCase {

  OrdersRepository ordersRepository;

  GetOrdersByClientUseCase(this.ordersRepository);

  run(int idClient) => ordersRepository.getOrdersByClient(idClient);

}