import 'package:app/src/presentation/utils/BlocFormItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/sales/bloc/SalesBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/sales/bloc/SalesEvent.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/sales/bloc/SalesState.dart';
import 'package:app/src/presentation/widgets/DefaultTextField.dart';
import 'package:app/src/presentation/widgets/DefaultButton.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SalesContent extends StatelessWidget {
  final SalesBloc? bloc;
  final SalesState state;

  SalesContent(this.bloc, this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Colors.black, // Establece el color de fondo a negro
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.3),
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: SingleChildScrollView(
              // Asegura que el contenido sea desplazable si es necesario
              child: Column(
                mainAxisSize: MainAxisSize
                    .min, // Para minimizar el espacio que ocupa la columna
                children: [
                  if (state.showOrderTypeOptions) ...[
                    ElevatedButton(
                      onPressed: () =>
                          bloc?.add(SelectOrderTypeOption('Para llevar')),
                      child: Text('Para llevar'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          bloc?.add(SelectOrderTypeOption('Pasan/Esperan')),
                      child: Text('Pasan/Esperan'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          bloc?.add(SelectOrderTypeOption('Comer dentro')),
                      child: Text('Comer dentro'),
                    ),
                    if (state.selectedOrderTypeOption == 'Para llevar')
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: DefaultTextField(
                          label: 'Número de teléfono',
                          icon: Icons.phone,
                          onChanged: (value) => bloc?.add(PhoneNumberChanged(
                              phoneNumber: BlocFormItem(value: value))),
                          obscureText: true,
                        ),
                      ),
                    ElevatedButton(
                      onPressed: () => bloc?.add(SalesSubmit()),
                      child: Text('Continuar'),
                    ),
                  ] else
                    ElevatedButton(
                      onPressed: () => bloc?.add(ShowOrderTypeOptions()),
                      child: Text('Crear orden'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
