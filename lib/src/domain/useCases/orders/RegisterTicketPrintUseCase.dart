import 'package:app/src/domain/repositories/OrdersRepository.dart';
import 'package:app/src/domain/utils/Resource.dart';

class RegisterTicketPrintUseCase {
  final OrdersRepository ordersRepository;

  RegisterTicketPrintUseCase(this.ordersRepository);

  Future<Resource<void>> run(int orderId, String printedBy) {
    return ordersRepository.registerTicketPrint(orderId, printedBy);
  }
}
