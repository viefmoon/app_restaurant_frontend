import 'package:app/injection.dart';
import 'package:app/src/domain/useCases/areas/AreasUseCases.dart';
import 'package:app/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:app/src/domain/useCases/roles/RolesUseCases.dart';
import 'package:app/src/presentation/pages/auth/login/bloc/LoginBloc.dart';
import 'package:app/src/presentation/pages/auth/login/bloc/LoginEvent.dart';
import 'package:app/src/presentation/pages/auth/register/bloc/RegisterBloc.dart';
import 'package:app/src/presentation/pages/auth/register/bloc/RegisterEvent.dart';
import 'package:app/src/presentation/pages/sales_receipts/home/bloc/SalesHomeBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/add_phone_number/bloc/AddPhoneNumberBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/table_selection/bloc/TableSelectionBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/table_selection/bloc/TableSelectionEvent.dart';
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
  BlocProvider<TableSelectionBloc>(
      create: (context) => TableSelectionBloc(locator<AreasUseCases>())
        ..add(TableSelectionInitEvent())),
  BlocProvider<AddPhoneNumberBloc>(
    create: (context) => AddPhoneNumberBloc(),
  ),
];
