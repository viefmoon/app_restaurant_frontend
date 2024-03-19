import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/repositories/OrdersRepository.dart';
import 'package:app/src/domain/utils/Resource.dart';

class UpdateOrderUseCase {
  OrdersRepository ordersRepository;

  UpdateOrderUseCase(this.ordersRepository);

  Future<Resource<Order>> run(int orderId, Map<String, dynamic> updateData) =>
      ordersRepository.updateOrder(orderId, updateData);
}
