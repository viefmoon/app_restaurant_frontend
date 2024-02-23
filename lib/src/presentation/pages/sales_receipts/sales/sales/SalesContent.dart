import 'package:flutter/material.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/sales/bloc/SalesBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/sales/bloc/SalesEvent.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/sales/bloc/SalesState.dart';

class SalesContent extends StatelessWidget {
  final SalesBloc? bloc;
  final SalesState state;

  SalesContent(this.bloc, this.state);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: TextTheme(
          bodyMedium:
              TextStyle(fontSize: 30), // Estilo por defecto para Text widgets.
        ),
      ),
      child: Form(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state.showOrderTypeOptions) ...[
                      SizedBox(height: 25), // Espacio antes del texto
                      Text(
                        'Seleccione una opción:', // Texto agregado
                        style: TextStyle(
                            fontSize: 20), // Estilo opcional para el texto
                      ),
                      SizedBox(
                          height:
                              25), // Espacio entre el texto y el primer botón
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(200, 75), // Establece el tamaño mínimo
                          shape: RoundedRectangleBorder(
                            // Hace que el botón sea rectangular
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, 'order/delivery/add_phone_number');
                        },
                        child: Text(
                          'Para llevar',
                        ),
                      ),
                      SizedBox(height: 25), // Espacio entre botones
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(200, 75), // Establece el tamaño mínimo
                          shape: RoundedRectangleBorder(
                            // Hace que el botón sea rectangular
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, 'order/table_selection');
                        },
                        child: Text(
                          'Pasan/Esperan',
                        ),
                      ),
                      SizedBox(height: 25), // Espacio entre botones
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(200, 75), // Establece el tamaño mínimo
                          shape: RoundedRectangleBorder(
                            // Hace que el botón sea rectangular
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, 'order/dine_in/table_selection');
                        },
                        child: Text(
                          'Comer dentro',
                        ),
                      ),
                    ] else ...[
                      SizedBox(height: 25), // Espaciado arriba del botón
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(200, 75), // Establece el tamaño mínimo
                          shape: RoundedRectangleBorder(
                            // Hace que el botón sea rectangular
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: () => bloc?.add(ShowOrderTypeOptions()),
                        child: Text(
                          'Crear orden',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
