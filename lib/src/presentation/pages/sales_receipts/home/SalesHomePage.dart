import 'package:flutter/material.dart';
import 'bloc/SalesHomeBloc.dart';
import 'bloc/SalesHomeEvent.dart';
import 'bloc/SalesHomeState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SalesHomePage extends StatefulWidget {
  const SalesHomePage({super.key});

  @override
  State<SalesHomePage> createState() => _SalesHomePageState();
}

class _SalesHomePageState extends State<SalesHomePage> {

  SalesHomeBloc? _bloc;

  List<Widget> pageList = <Widget>[
    ReceiptsPage(),
    SalesPage(),
  ];

  @override
  Widget build(BuildContext context) {

    _bloc = BlocProvider.of<SalesHomeBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Menu')),
      drawer: BlocBuilder<SalesHomeBloc, SalesHomeState>(
        builder: (context, state) {
          return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.black
                    ),
                    child: Text(
                      'Menu de ventas',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    )
                  ),
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
                    title: Text('Cerrar sesion'),
                    onTap: () {
                      _bloc?.add(AdminLogout());
                      Navigator.pushAndRemoveUntil(
                        context, 
                        MaterialPageRoute(builder: (context) => MyApp()), 
                        (route) => false
                      );
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
        }
      )
    );
  }
}