import 'package:app/src/domain/useCases/orders/CancelOrderUseCase.dart';
import 'package:app/src/domain/useCases/orders/CompleteOrderUseCase.dart';
import 'package:app/src/domain/useCases/orders/CreateOrderUseCase.dart';
import 'package:app/src/domain/useCases/orders/FindOrderItemsWithCounts.dart';
import 'package:app/src/domain/useCases/orders/GetClosedOrdersUseCase.dart';
import 'package:app/src/domain/useCases/orders/GetDeliveryOrdersUseCase.dart';
import 'package:app/src/domain/useCases/orders/GetOpenOrdersUseCase.dart';
import 'package:app/src/domain/useCases/orders/GetOrderForUpdateUseCase.dart';
import 'package:app/src/domain/useCases/orders/MarkOrdersAsInDeliveryUseCase.dart';
import 'package:app/src/domain/useCases/orders/RegisterPaymentUseCase.dart';
import 'package:app/src/domain/useCases/orders/SynchronizeDataUseCase.dart';
import 'package:app/src/domain/useCases/orders/UpdateOrderItemStatusUseCase.dart';
import 'package:app/src/domain/useCases/orders/UpdateOrderStatusUseCase.dart';
import 'package:app/src/domain/useCases/orders/UpdateOrderUseCase.dart';

class OrdersUseCases {
  CreateOrderUseCase createOrder;
  GetOpenOrdersUseCase getOpenOrders;
  GetClosedOrdersUseCase getClosedOrders;
  GetOrderForUpdateUseCase getOrderForUpdate;
  UpdateOrderUseCase updateOrder;
  UpdateOrderStatusUseCase updateOrderStatus;
  UpdateOrderItemStatusUseCase updateOrderItemStatus;
  SynchronizeDataUseCase synchronizeData;
  FindOrderItemsWithCountsUseCase findOrderItemsWithCounts;
  RegisterPaymentUseCase registerPayment;
  CompleteOrderUseCase completeOrder;
  CancelOrderUseCase cancelOrder;
  GetDeliveryOrdersUseCase getDeliveryOrders;
  MarkOrdersAsInDeliveryUseCase markOrdersAsInDelivery;

  OrdersUseCases({
    required this.createOrder,
    required this.getOpenOrders,
    required this.getClosedOrders,
    required this.updateOrder,
    required this.getOrderForUpdate,
    required this.updateOrderStatus,
    required this.updateOrderItemStatus,
    required this.synchronizeData,
    required this.findOrderItemsWithCounts,
    required this.registerPayment,
    required this.completeOrder,
    required this.cancelOrder,
    required this.getDeliveryOrders,
    required this.markOrdersAsInDelivery,
  });
}
