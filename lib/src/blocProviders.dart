import 'package:app/injection.dart';
import 'package:app/src/domain/useCases/areas/AreasUseCases.dart';
import 'package:app/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:app/src/domain/useCases/categories/CategoriesUseCases.dart';
import 'package:app/src/domain/useCases/roles/RolesUseCases.dart';
import 'package:app/src/presentation/pages/auth/login/bloc/LoginBloc.dart';
import 'package:app/src/presentation/pages/auth/login/bloc/LoginEvent.dart';
import 'package:app/src/presentation/pages/auth/register/bloc/RegisterBloc.dart';
import 'package:app/src/presentation/pages/auth/register/bloc/RegisterEvent.dart';
import 'package:app/src/presentation/pages/sales_receipts/home/bloc/SalesHomeBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationBloc.dart';
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
  BlocProvider<OrderCreationBloc>(
      create: (context) => OrderCreationBloc(
          categoriesUseCases: locator<CategoriesUseCases>(),
          areasUseCases: locator<AreasUseCases>())),
];
