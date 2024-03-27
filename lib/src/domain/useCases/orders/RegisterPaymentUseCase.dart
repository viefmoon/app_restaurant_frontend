import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/repositories/OrdersRepository.dart';
import 'package:app/src/domain/utils/Resource.dart';

class RegisterPaymentUseCase {
  OrdersRepository ordersRepository;

  RegisterPaymentUseCase(this.ordersRepository);

  Future<Resource<Order>> run(int orderId, double amount) =>
      ordersRepository.registerPayment(orderId, amount);
}
