import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/equinos/second_screen/reproducao_screen/estoque_semen_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/equinos/second_screen/reproducao_screen/inseminacao_monta_screen.dart';

class DescriptionReproducaoEquinos extends StatefulWidget {
  @override
  _DescriptionReproducaoEquinosState createState() =>
      _DescriptionReproducaoEquinosState();
}

class _DescriptionReproducaoEquinosState
    extends State<DescriptionReproducaoEquinos> {
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
                          child: EstoqueSemenScreen(),
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
                          child: InseminacaoMontaScreen(),
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
