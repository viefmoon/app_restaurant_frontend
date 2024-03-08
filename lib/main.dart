import 'package:app/src/presentation/pages/sales_receipts/home/SalesHomePage.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/OrderCreationContainer.dart';
import 'injection.dart';
import 'src/blocProviders.dart';
import 'src/presentation/pages/auth/login/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app/src/presentation/pages/auth/register/RegisterPage.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Definición del tema personalizado
    final ThemeData theme = ThemeData(
      useMaterial3: true, // Habilita Material 3
      colorScheme: ColorScheme.fromSeed(
        seedColor:
            Colors.white, // Color semilla utilizado para generar la paleta
        brightness: Brightness.dark, // Prefiere el modo claro
        primary: Colors.white, // Color principal para elementos interactivos
        secondary: Colors
            .tealAccent, // Color secundario para complementar al principal
        error: Colors.redAccent, // Color para indicaciones de errores
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[800], // Color de fondo para la AppBar
        foregroundColor:
            Colors.green, // Color del texto y los iconos en la AppBar
      ),

      // Añade más personalizaciones según sea necesario
    );

    return MultiBlocProvider(
      providers: blocProviders,
      child: MaterialApp(
        builder: FToastBuilder(),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: theme, // Usa el tema personalizado aquí
        initialRoute: 'login',
        navigatorObservers: [routeObserver], // Añade el RouteObserver aquí
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'register': (BuildContext context) => RegisterPage(),
          'salesHome': (BuildContext context) => SalesHomePage(),
          'order/create': (BuildContext context) => OrderCreationContainer(),
        },
      ),
    );
  }
}
