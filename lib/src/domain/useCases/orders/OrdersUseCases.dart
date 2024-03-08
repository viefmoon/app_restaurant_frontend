import 'package:app/src/domain/useCases/orders/CreateOrderUseCase.dart';
import 'package:app/src/domain/useCases/orders/GetOpenOrdersUseCase.dart';

class OrdersUseCases {
  CreateOrderUseCase createOrder;
  GetOpenOrdersUseCase getOpenOrders;

  OrdersUseCases({
    required this.createOrder,
    required this.getOpenOrders,
  });
}
