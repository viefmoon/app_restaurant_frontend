import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/repositories/OrdersRepository.dart';
import 'package:app/src/domain/utils/Resource.dart';

class RevertMultipleOrdersUseCase {
  OrdersRepository ordersRepository;

  RevertMultipleOrdersUseCase(this.ordersRepository);

  Future<Resource<List<Order>>> run(List<int> orderIds) =>
      ordersRepository.revertMultipleOrdersToPrepared(orderIds);
}
