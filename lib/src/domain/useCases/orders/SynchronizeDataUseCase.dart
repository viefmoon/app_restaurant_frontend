import 'package:app/src/domain/repositories/OrdersRepository.dart';

class SynchronizeDataUseCase {
  OrdersRepository ordersRepository;
  SynchronizeDataUseCase(this.ordersRepository);

  run() => ordersRepository.synchronizeData();
}
