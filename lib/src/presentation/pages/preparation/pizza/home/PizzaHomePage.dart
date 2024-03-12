import 'package:app/main.dart';
import 'package:app/src/presentation/pages/preparation/pizza/PizzaPreparationPage.dart';
import 'package:flutter/material.dart';
import 'bloc/PizzaHomeBloc.dart';
import 'bloc/PizzaHomeEvent.dart';
import 'bloc/PizzaHomeState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PizzaHomePage extends StatefulWidget {
  const PizzaHomePage({super.key});

  @override
  State<PizzaHomePage> createState() => _PizzaHomePageState();
}

class _PizzaHomePageState extends State<PizzaHomePage> {
  PizzaHomeBloc? _bloc;

  List<Widget> pageList = <Widget>[
    PizzaPreparationPage(),
  ];

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<PizzaHomeBloc>(context, listen: false);
    // Disparar el evento de inicialización para cargar el nombre de usuario
    BlocProvider.of<PizzaHomeBloc>(context, listen: false).add(InitEvent());
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<PizzaHomeBloc>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('PIZZAS - PREPARACIÓN'),
        ),
        drawer: BlocBuilder<PizzaHomeBloc, PizzaHomeState>(
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
                    title: Text('Pizzas'),
                    selected: state.pageIndex == 0,
                    onTap: () {
                      _bloc?.add(PizzaChangeDrawerPage(pageIndex: 0));
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
        body: BlocBuilder<PizzaHomeBloc, PizzaHomeState>(
            builder: (context, state) {
          return pageList[state.pageIndex];
        }));
  }
}
