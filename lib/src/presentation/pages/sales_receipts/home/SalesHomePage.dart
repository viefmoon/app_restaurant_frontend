import 'package:app/main.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/OrderCreationContainer.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/sales_options/SalesOptionsPage.dart';
import 'package:flutter/material.dart';
import 'bloc/SalesHomeBloc.dart';
import 'bloc/SalesHomeEvent.dart';
import 'bloc/SalesHomeState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/receipts/ReceiptsPage.dart';

class SalesHomePage extends StatefulWidget {
  const SalesHomePage({super.key});

  @override
  State<SalesHomePage> createState() => _SalesHomePageState();
}

class _SalesHomePageState extends State<SalesHomePage> {
  SalesHomeBloc? _bloc;

  List<Widget> pageList = <Widget>[
    SalesOptionsPage(),
    ReceiptsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<SalesHomeBloc>(context, listen: false);
    // Disparar el evento de inicialización para cargar el nombre de usuario
    BlocProvider.of<SalesHomeBloc>(context, listen: false).add(InitEvent());
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<SalesHomeBloc>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('ORDENES'),
        ),
        drawer: BlocBuilder<SalesHomeBloc, SalesHomeState>(
          builder: (context, state) {
            return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                      decoration: BoxDecoration(color: Colors.black),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.name ?? "Usuario",
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          Text(
                            state.role ?? "Rol no disponible",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      )),
                  ListTile(
                    title: Text('Ventas'),
                    selected: state.pageIndex == 0,
                    onTap: () {
                      _bloc?.add(SalesChangeDrawerPage(pageIndex: 0));
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Recibos'),
                    selected: state.pageIndex == 1,
                    onTap: () {
                      _bloc?.add(SalesChangeDrawerPage(pageIndex: 1));
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Cerrar sesión'),
                    onTap: () {
                      _bloc?.add(Logout());
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp()),
                          (route) => false);
                    },
                  ),
                ],
              ),
            );
          },
        ),
        body: BlocBuilder<SalesHomeBloc, SalesHomeState>(
            builder: (context, state) {
          return pageList[state.pageIndex];
        }));
  }
}
