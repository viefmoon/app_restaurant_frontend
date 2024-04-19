import 'package:app/src/domain/repositories/OrdersRepository.dart';
import 'package:app/src/domain/utils/Resource.dart';

class ResetDatabaseUseCase {
  OrdersRepository ordersRepository;

  ResetDatabaseUseCase(this.ordersRepository);

  Future<Resource<void>> run() => ordersRepository.resetDatabase();
}
