import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/medicamentos.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/tratamentos.dart';

class CadastroMedicamentosTratamentos extends StatefulWidget {
  @override
  _CadastroMedicamentosTratamentosState createState() =>
      _CadastroMedicamentosTratamentosState();
}

class _CadastroMedicamentosTratamentosState
    extends State<CadastroMedicamentosTratamentos> {
  double _height = 130.0;
  double _width = 130.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sáude e Tratamento"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              "images/telainicial.png",
              fit: BoxFit.cover,
              height: 1000.0,
            ),
            Column(
              children: [
                //Primeira linha
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: _width,
                          height: _height,
                          color: Colors.grey[50],
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Medicamentos(),
                        ),
                      ],
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: _width,
                          height: _height,
                          color: Colors.grey[50],
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Tratamentos(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
