import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/repositories/OrdersRepository.dart';
import 'package:app/src/domain/utils/Resource.dart';

class UpdateOrderStatusUseCase {
  OrdersRepository ordersRepository;

  UpdateOrderStatusUseCase(this.ordersRepository);

  Future<Resource<Order>> run(Order order) =>
      ordersRepository.updateOrderStatus(order);
}
