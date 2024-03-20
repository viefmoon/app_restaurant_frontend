import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/repositories/OrdersRepository.dart';
import 'package:app/src/domain/utils/Resource.dart';

class UpdateOrderUseCase {
  OrdersRepository ordersRepository;

  UpdateOrderUseCase(this.ordersRepository);

  Future<Resource<Order>> run(Order order) =>
      ordersRepository.updateOrder(order);
}
