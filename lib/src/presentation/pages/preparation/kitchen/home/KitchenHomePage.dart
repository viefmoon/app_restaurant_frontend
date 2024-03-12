import 'package:app/main.dart';
import 'package:app/src/presentation/pages/preparation/kitchen/KitchenPage.dart';
import 'package:flutter/material.dart';
import 'bloc/KitchenHomeBloc.dart';
import 'bloc/KitchenHomeEvent.dart';
import 'bloc/KitchenHomeState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KitchenHomePage extends StatefulWidget {
  const KitchenHomePage({Key? key});

  @override
  State<KitchenHomePage> createState() => _KitchenHomePageState();
}

class _KitchenHomePageState extends State<KitchenHomePage> {
  KitchenHomeBloc? _bloc;

  List<Widget> pageList = <Widget>[
    KitchenPage(),
  ];

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<KitchenHomeBloc>(context, listen: false);
    // Disparar el evento de inicialización para cargar el nombre de usuario
    BlocProvider.of<KitchenHomeBloc>(context, listen: false).add(InitEvent());
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<KitchenHomeBloc>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('COCINA'),
        ),
        drawer: BlocBuilder<KitchenHomeBloc, KitchenHomeState>(
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
                    title: Text('Cocina'),
                    selected: state.pageIndex == 0,
                    onTap: () {
                      _bloc?.add(KitchenChangeDrawerPage(pageIndex: 0));
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
        body: BlocBuilder<KitchenHomeBloc, KitchenHomeState>(
            builder: (context, state) {
          return pageList[state.pageIndex];
        }));
  }
}
