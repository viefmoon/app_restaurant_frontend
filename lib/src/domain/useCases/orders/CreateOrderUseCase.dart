import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/repositories/OrdersRepository.dart';
import 'package:app/src/domain/utils/Resource.dart';

class CreateOrderUseCase {
  final OrdersRepository ordersRepository;

  CreateOrderUseCase(this.ordersRepository);

  Future<Resource<Order>> call(Order order) async {
    return await ordersRepository.createOrder(order);
  }
}
