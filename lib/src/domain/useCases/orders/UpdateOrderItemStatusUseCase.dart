import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/repositories/OrdersRepository.dart';
import 'package:app/src/domain/utils/Resource.dart';

class UpdateOrderItemStatusUseCase {
  OrdersRepository ordersRepository;

  UpdateOrderItemStatusUseCase(this.ordersRepository);

  Future<Resource<OrderItem>> run(OrderItem orderItem) =>
      ordersRepository.updateOrderItemStatus(orderItem);
}
