import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/equinos/second_screen/tree_screen/plantel/screen/cavalos_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/equinos/second_screen/tree_screen/plantel/screen/eguas_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/equinos/second_screen/tree_screen/plantel/screen/potros_screen.dart';

class DescriptionPlantelEquinos extends StatefulWidget {
  @override
  _DescriptionPlantelEquinosState createState() =>
      _DescriptionPlantelEquinosState();
}

class _DescriptionPlantelEquinosState extends State<DescriptionPlantelEquinos> {
  double _height = 130.0;
  double _width = 130.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Plantel"),
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
                          child: CavalosScreen(),
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
                          child: EguaScreen(),
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
                          child: PotroScreen(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
