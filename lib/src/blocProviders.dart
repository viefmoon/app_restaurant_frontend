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
import 'package:app/src/presentation/pages/preparation/bar/bloc/BarPreparationEvent.dart';
import 'package:app/src/presentation/pages/preparation/bar/home/bloc/BarHomeBloc.dart';
import 'package:app/src/presentation/pages/preparation/hamburger/home/bloc/HamburgerHomeBloc.dart';
import 'package:app/src/presentation/pages/preparation/kitchen/home/bloc/KitchenHomeBloc.dart';
import 'package:app/src/presentation/pages/preparation/pizza/home/bloc/PizzaHomeBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/home/bloc/SalesHomeBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/bloc/OrderUpdateBloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
  BlocProvider<OrderCreationBloc>(
      create: (context) => OrderCreationBloc(
          categoriesUseCases: locator<CategoriesUseCases>(),
          areasUseCases: locator<AreasUseCases>(),
          ordersUseCases: locator<OrdersUseCases>())),
  BlocProvider<OrderUpdateBloc>(
      create: (context) => OrderUpdateBloc(
          ordersUseCases: locator<OrdersUseCases>(),
          areasUseCases: locator<AreasUseCases>(),
          categoriesUseCases: locator<CategoriesUseCases>())),
  BlocProvider<PizzaHomeBloc>(
      create: (context) => PizzaHomeBloc(locator<AuthUseCases>())),
  BlocProvider<KitchenHomeBloc>(
      create: (context) => KitchenHomeBloc(locator<AuthUseCases>())),
  BlocProvider<HamburgerHomeBloc>(
      create: (context) => HamburgerHomeBloc(locator<AuthUseCases>())),
  BlocProvider<BarHomeBloc>(
      create: (context) => BarHomeBloc(locator<AuthUseCases>())),
  BlocProvider<BarPreparationBloc>(
    create: (context) => BarPreparationBloc(
      socket: IO.io('http://192.168.100.32:3000', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'query': {'screenType': 'barScreen'}
      }),
    )..add(ConnectToWebSocket()), // Cambio aquí para conectar manualmente
  ),
];
