import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/caprinos/second_screen/nutricao/screen/nutricao_concentrado_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/caprinos/second_screen/nutricao/screen/nutricao_suplemento_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/caprinos/second_screen/nutricao/screen/nutricao_volumosa_screen.dart';

class CadastrarNutricaoBovinoCorte extends StatefulWidget {
  @override
  _CadastrarNutricaoBovinoCorteState createState() =>
      _CadastrarNutricaoBovinoCorteState();
}

class _CadastrarNutricaoBovinoCorteState
    extends State<CadastrarNutricaoBovinoCorte> {
  double _height = 130.0;
  double _width = 130.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar Nutrição"),
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
                          child: NutricaoConcentradoCaprinoScreen(),
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
                          child: NutricaoSuplementoCaprinoScreen(),
                        ),
                      ],
                    ),
                  ],
                ),
                //Segunda linha
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
                          child: NutricaoVolumosaCaprinoScreen(),
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
