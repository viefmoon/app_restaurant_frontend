import 'package:ecommerce_flutter/injection.dart';
import 'package:ecommerce_flutter/src/blocProviders.dart';
import 'package:ecommerce_flutter/src/presentation/pages/admin/category/create/AdminCategoryCreatePage.dart';
import 'package:ecommerce_flutter/src/presentation/pages/admin/category/update/AdminCategoryUpdatePage.dart';
import 'package:ecommerce_flutter/src/presentation/pages/admin/home/AdminHomePage.dart';
import 'package:ecommerce_flutter/src/presentation/pages/admin/order/detail/AdminOrderDetailPage.dart';
import 'package:ecommerce_flutter/src/presentation/pages/admin/product/create/AdminProductCreatePage.dart';
import 'package:ecommerce_flutter/src/presentation/pages/admin/product/list/AdminProductListPage.dart';
import 'package:ecommerce_flutter/src/presentation/pages/admin/product/update/AdminProductUpdatePage.dart';
import 'package:ecommerce_flutter/src/presentation/pages/auth/login/LoginPage.dart';
import 'package:ecommerce_flutter/src/presentation/pages/auth/register/RegisterPage.dart';
import 'package:ecommerce_flutter/src/presentation/pages/client/ShoppingBag/ClientShoppingBagPage.dart';
import 'package:ecommerce_flutter/src/presentation/pages/client/address/create/ClientAddressCreatePage.dart';
import 'package:ecommerce_flutter/src/presentation/pages/client/address/list/ClientAddressListPage.dart';
import 'package:ecommerce_flutter/src/presentation/pages/client/home/ClientHomePage.dart';
import 'package:ecommerce_flutter/src/presentation/pages/client/order/detail/ClientOrderDetailPage.dart';
import 'package:ecommerce_flutter/src/presentation/pages/client/payment/form/ClientPaymentFormPage.dart';
import 'package:ecommerce_flutter/src/presentation/pages/client/payment/installments/ClientPaymentInstallmentsPage.dart';
import 'package:ecommerce_flutter/src/presentation/pages/client/payment/status/ClientPaymentStatusPage.dart';
import 'package:ecommerce_flutter/src/presentation/pages/client/product/detail/ClientProductDetailPage.dart';
import 'package:ecommerce_flutter/src/presentation/pages/client/product/list/ClientProductListPage.dart';
import 'package:ecommerce_flutter/src/presentation/pages/profile/info/ProfileInfoPage.dart';
import 'package:ecommerce_flutter/src/presentation/pages/profile/update/ProfileUpdatePage.dart';
import 'package:ecommerce_flutter/src/presentation/pages/roles/RolesPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    return MultiBlocProvider(
      providers: blocProviders,
      child: MaterialApp(
        builder: FToastBuilder(),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'register': (BuildContext context) => RegisterPage(),
          'roles': (BuildContext context) => RolesPage(),
          'profile/info': (BuildContext context) => ProfileInfoPage(),
          'profile/update': (BuildContext context) => ProfileUpdatePage(),
          'client/home': (BuildContext context) => ClientHomePage(),
          'admin/home': (BuildContext context) => AdminHomePage(),
          'admin/category/create': (BuildContext context) => AdminCategoryCreatePage(),
          'admin/category/update': (BuildContext context) => AdminCategoryUpdatePage(),
          'admin/product/list': (BuildContext context) => AdminProductListPage(),
          'admin/product/create': (BuildContext context) => AdminProductCreatePage(),
          'admin/product/update': (BuildContext context) => AdminProductUpdatePage(),
          'client/product/list': (BuildContext context) => ClientProductListPage(),
          'client/product/detail': (BuildContext context) => ClientProductDetailPage(),
          'client/shopping_bag': (BuildContext context) => ClientShoppingBagPage(),
          'client/address/list': (BuildContext context) => ClientAddressListPage(),
          'client/address/create': (BuildContext context) => ClientAddressCreatePage(),
          'client/payment/form': (BuildContext context) => ClientPaymentFormPage(),
          'client/payment/installments': (BuildContext context) => ClientPaymentInstallmentsPage(),
          'client/payment/status': (BuildContext context) => ClientPaymentStatusPage(),          
          'admin/order/detail': (BuildContext context) => AdminOrderDetailPage(),          
          'client/order/detail': (BuildContext context) => ClientOrderDetailPage(),          
        },
      ),
    );
  }
}
