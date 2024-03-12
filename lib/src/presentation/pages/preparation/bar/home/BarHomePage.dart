import 'package:app/main.dart';
import 'package:app/src/presentation/pages/preparation/bar/BarPreparationPage.dart';
import 'package:flutter/material.dart';
import 'bloc/BarHomeBloc.dart';
import 'bloc/BarHomeEvent.dart';
import 'bloc/BarHomeState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BarHomePage extends StatefulWidget {
  const BarHomePage({super.key});

  @override
  State<BarHomePage> createState() => _BarHomePageState();
}

class _BarHomePageState extends State<BarHomePage> {
  BarHomeBloc? _bloc;

  List<Widget> pageList = <Widget>[
    BarPreparationPage(),
  ];

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<BarHomeBloc>(context, listen: false);
    // Disparar el evento de inicialización para cargar el nombre de usuario
    BlocProvider.of<BarHomeBloc>(context, listen: false).add(InitEvent());
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<BarHomeBloc>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('BAR - PREPARACIÓN'),
        ),
        drawer: BlocBuilder<BarHomeBloc, BarHomeState>(
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
                    title: Text('Hamburguesas'),
                    selected: state.pageIndex == 0,
                    onTap: () {
                      _bloc?.add(BarChangeDrawerPage(pageIndex: 0));
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
        body: BlocBuilder<BarHomeBloc, BarHomeState>(builder: (context, state) {
          return pageList[state.pageIndex];
        }));
  }
}
