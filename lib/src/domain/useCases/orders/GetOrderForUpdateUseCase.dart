import 'package:app/src/domain/repositories/OrdersRepository.dart';

class GetOrderForUpdateUseCase {
  OrdersRepository ordersRepository;
  GetOrderForUpdateUseCase(this.ordersRepository);

  run(int orderId) => ordersRepository.getOrderForUpdate(orderId);
}
