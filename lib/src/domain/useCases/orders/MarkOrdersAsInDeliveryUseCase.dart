import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/repositories/OrdersRepository.dart';
import 'package:app/src/domain/utils/Resource.dart';

class MarkOrdersAsInDeliveryUseCase {
  final OrdersRepository ordersRepository;

  MarkOrdersAsInDeliveryUseCase(this.ordersRepository);

  Future<Resource<void>> run(List<Order> orders) {
    return ordersRepository.markOrdersAsInDelivery(orders);
  }
}
