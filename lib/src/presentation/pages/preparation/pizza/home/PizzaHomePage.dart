import 'package:app/main.dart';
import 'package:app/src/presentation/pages/preparation/pizza/PizzaPreparationPage.dart';
import 'package:app/src/presentation/pages/setting/SettingsPage.dart'; // Added import for SettingsPage
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
  OrderFilterType _currentFilter = OrderFilterType.all;
  int _currentPageIndex = 0;
  bool _filterByPrepared = false;
  bool _filterByScheduledDelivery = false;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<PizzaHomeBloc>(context, listen: false);
    _bloc!.add(InitEvent());
  }

  AppBar _buildAppBar() {
    double screenWidth = MediaQuery.of(context).size.width;

    IconButton _buildIconButton(IconData icon, OrderFilterType filterType) {
      return IconButton(
        icon: Icon(icon),
        color: _currentFilter == filterType
            ? Colors.black
            : Colors.white, // Cambia el color aquí
        iconSize: 40,
        onPressed: () {
          setState(() {
            _currentFilter = filterType;
          });
          _bloc?.add(ChangeOrderFilterType(filterType));
        },
      );
    }

    return AppBar(
      title: Text(
        'Pizza',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        if (_currentPageIndex == 0)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildIconButton(Icons.filter_list, OrderFilterType.all),
              SizedBox(width: screenWidth * 0.10),
              _buildIconButton(Icons.local_shipping, OrderFilterType.delivery),
              SizedBox(width: screenWidth * 0.10),
              _buildIconButton(Icons.restaurant, OrderFilterType.dineIn),
              SizedBox(width: screenWidth * 0.10),
              _buildIconButton(Icons.shopping_bag, OrderFilterType.pickUpWait),
              SizedBox(width: screenWidth * 0.16),
              IconButton(
                iconSize: 40,
                icon: Icon(_filterByPrepared
                    ? Icons.check_box
                    : Icons.check_box_outline_blank),
                onPressed: () {
                  setState(() {
                    _filterByPrepared = !_filterByPrepared;
                  });
                },
              ),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pageList = <Widget>[
      PizzaPreparationPage(
          filterType: _currentFilter,
          filterByPrepared: _filterByPrepared,
          filterByScheduledDelivery: _filterByScheduledDelivery),
      SettingsPage(),
    ];

    return Theme(
      data: ThemeData(
        primaryColor: Colors.orange, // Color primario
        scaffoldBackgroundColor: Colors.white, // Color de fondo del Scaffold
        appBarTheme: AppBarTheme(
          color: Colors.orange, // Color de la AppBar
          iconTheme: IconThemeData(
              color: Colors.white), // Color de los iconos de la AppBar
        ),
        // Otros colores y estilos que desees personalizar
      ),
      child: Scaffold(
        appBar: _buildAppBar(),
        drawer: BlocBuilder<PizzaHomeBloc, PizzaHomeState>(
          builder: (context, state) {
            return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                      decoration: BoxDecoration(
                          color: Colors.brown), // Cambia el color aquí
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.name ?? "Usuario",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28), // Tamaño de letra aumentado
                          ),
                          Text(
                            state.role ?? "Rol no disponible",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20), // Tamaño de letra aumentado
                          ),
                        ],
                      )),
                  ListTile(
                    title: Text('Pizza',
                        style: TextStyle(
                            fontSize: 24)), // Tamaño de letra aumentado
                    selected: _currentPageIndex == 0,
                    onTap: () {
                      setState(() {
                        _currentPageIndex = 0;
                      });
                      _bloc?.add(PizzaChangeDrawerPage(pageIndex: 0));
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Configuración',
                        style: TextStyle(
                            fontSize: 24)), // Tamaño de letra aumentado
                    selected: _currentPageIndex == 1,
                    onTap: () {
                      setState(() {
                        _currentPageIndex = 1;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 50),
                  ListTile(
                    title: Text('Cerrar sesión',
                        style: TextStyle(
                            fontSize: 24)), // Tamaño de letra aumentado
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
        body: pageList[
            _currentPageIndex], // Display the page based on _currentPageIndex
      ),
    );
  }
}
