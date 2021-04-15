import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/equinos/second_screen/medicamentos_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/equinos/second_screen/nutricao_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/equinos/second_screen/plantel_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/equinos/second_screen/reproducao_equino_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/equinos/second_screen/tratamentos_screen.dart';

class DescriptionCaprinos extends StatefulWidget {
  @override
  _DescriptionCaprinosState createState() => _DescriptionCaprinosState();
}

class _DescriptionCaprinosState extends State<DescriptionCaprinos> {
  double _height = 130.0;
  double _width = 130.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestão"),
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
                          child: PlantelEquinosScreen(),
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
                          child: ReproducaoEquinoScreen(),
                        ),
                      ],
                    ),
                  ],
                ),
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
                          child: TratamentoEquinoScreen(),
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
                          child: MedicamentoEquinoScreen(),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                        child: NutricaoEquinoScreen(),
                      ),
                    ],
                  ),
                ])
              ],
            ),
          ],
        ),
      ),
    );
  }
}
