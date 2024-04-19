import 'package:app/injection.dart';
import 'package:app/src/domain/useCases/areas/AreasUseCases.dart';
import 'package:app/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:app/src/domain/useCases/categories/CategoriesUseCases.dart';
import 'package:app/src/domain/useCases/orders/OrdersUseCases.dart';
import 'package:app/src/domain/useCases/roles/RolesUseCases.dart';
import 'package:app/src/presentation/pages/auth/login/bloc/LoginBloc.dart';
import 'package:app/src/presentation/pages/auth/login/bloc/LoginEvent.dart';
import 'package:app/src/presentation/pages/auth/register/bloc/RegisterBloc.dart';
import 'package:app/src/presentation/pages/auth/register/bloc/RegisterEvent.dart';
import 'package:app/src/presentation/pages/preparation/bar/bloc/BarPreparationBloc.dart';
import 'package:app/src/presentation/pages/preparation/bar/home/bloc/BarHomeBloc.dart';
import 'package:app/src/presentation/pages/preparation/burger/bloc/BurgerPreparationBloc.dart';
import 'package:app/src/presentation/pages/preparation/burger/home/bloc/BurgerHomeBloc.dart';
import 'package:app/src/presentation/pages/preparation/pizza/bloc/PizzaPreparationBloc.dart';
import 'package:app/src/presentation/pages/preparation/pizza/home/bloc/PizzaHomeBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/closed_orders/bloc/ClosedOrdersBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/delivery_orders/bloc/DeliveryOrdersBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/home/bloc/SalesHomeBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/home_waiter/bloc/WaiterHomeBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/bloc/OrderUpdateBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/pending_order_items/bloc/PendingOrderItemsBloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<BlocProvider> blocProviders = [
  BlocProvider<LoginBloc>(
      create: (context) =>
          LoginBloc(locator<AuthUseCases>())..add(InitEvent())),
  BlocProvider<RegisterBloc>(
      create: (context) =>
          RegisterBloc(locator<AuthUseCases>(), locator<RolesUseCases>())
            ..add(RegisterInitEvent())),
  BlocProvider<SalesHomeBloc>(
      create: (context) => SalesHomeBloc(locator<AuthUseCases>())),
  BlocProvider<WaiterHomeBloc>(
      create: (context) => WaiterHomeBloc(locator<AuthUseCases>())),
  BlocProvider<OrderCreationBloc>(
      create: (context) => OrderCreationBloc(
          categoriesUseCases: locator<CategoriesUseCases>(),
          areasUseCases: locator<AreasUseCases>(),
          ordersUseCases: locator<OrdersUseCases>(),
          authUseCases: locator<AuthUseCases>())),
  BlocProvider<ClosedOrdersBloc>(
      create: (context) =>
          ClosedOrdersBloc(ordersUseCases: locator<OrdersUseCases>())),
  BlocProvider<PendingOrderItemsBloc>(
      create: (context) =>
          PendingOrderItemsBloc(ordersUseCases: locator<OrdersUseCases>())),
  BlocProvider<DeliveryOrdersBloc>(
      create: (context) =>
          DeliveryOrdersBloc(ordersUseCases: locator<OrdersUseCases>())),
  BlocProvider<OrderUpdateBloc>(
      create: (context) => OrderUpdateBloc(
          ordersUseCases: locator<OrdersUseCases>(),
          areasUseCases: locator<AreasUseCases>(),
          categoriesUseCases: locator<CategoriesUseCases>(),
          authUseCases: locator<AuthUseCases>())),
  BlocProvider<PizzaHomeBloc>(
      create: (context) => PizzaHomeBloc(locator<AuthUseCases>())),
  BlocProvider<BurgerHomeBloc>(
      create: (context) => BurgerHomeBloc(locator<AuthUseCases>())),
  BlocProvider<BarHomeBloc>(
      create: (context) => BarHomeBloc(locator<AuthUseCases>())),
  BlocProvider<BarPreparationBloc>(
    create: (context) => BarPreparationBloc(
      orderUseCases: locator<OrdersUseCases>(),
    ),
  ),
  BlocProvider<PizzaPreparationBloc>(
    create: (context) => PizzaPreparationBloc(
      orderUseCases: locator<OrdersUseCases>(),
    ),
  ),
  BlocProvider<BurgerPreparationBloc>(
    create: (context) => BurgerPreparationBloc(
      orderUseCases: locator<OrdersUseCases>(),
    ),
  ),
];
