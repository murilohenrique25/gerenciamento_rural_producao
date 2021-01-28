import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/utilitarios/cadastrar_economia_gastos.dart';

enum OrderOptions { orderaz, orderza }

class Economia extends StatefulWidget {
  @override
  _EconomiaState createState() => _EconomiaState();
}

class _EconomiaState extends State<Economia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CadastroEconomiaGasto()));
                }),
          ],
          centerTitle: true,
          title: Text("Medicamentos"),
        ),
        body: Center(
          child: Container(
            child: Text(
              "Aqui será apresentado todas as economias da fazenda\n" +
                  "Como gasto com mão de obra, com medicamentos, entre outros.",
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }
}
