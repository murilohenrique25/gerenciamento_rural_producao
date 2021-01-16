import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/utilitarios/cadastrar_medicamentos.dart';

enum OrderOptions { orderaz, orderza }

class Medicamentos extends StatefulWidget {
  @override
  _MedicamentosState createState() => _MedicamentosState();
}

class _MedicamentosState extends State<Medicamentos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton<OrderOptions>(
              itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                const PopupMenuItem<OrderOptions>(
                  child: Text("Ordenar de A-Z"),
                  value: OrderOptions.orderaz,
                ),
                const PopupMenuItem<OrderOptions>(
                  child: Text("Ordenar de Z-A"),
                  value: OrderOptions.orderza,
                ),
              ],
            ),
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CadastrarMedicamento()));
                }),
          ],
          centerTitle: true,
          title: Text("Medicamentos"),
        ),
        body: Center(
          child: Container(
            child: Text("Aqui será apresentado os \nmedicamentos cadastrados"),
          ),
        ));
  }
}
