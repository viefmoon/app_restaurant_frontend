import 'package:app/src/domain/repositories/OrdersRepository.dart';

class GetPrintedOrdersUseCase {
  OrdersRepository ordersRepository;
  GetPrintedOrdersUseCase(this.ordersRepository);

  run() => ordersRepository.getPrintedOrders();
}
