import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/screen/dados_rebanho_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/screen/economia_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/screen/nutricao_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/screen/plantel_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/screen/producao_carne_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/screen/reproducao_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/screen/tratamentos_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/tree_screen/screen/aleitamento_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/tree_screen/screen/cachacos_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/tree_screen/screen/creche_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/tree_screen/screen/lotes_abatidos_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/tree_screen/screen/matrizes_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/tree_screen/screen/terminacao_screen.dart';

class DescriptionPlantelSuinos extends StatefulWidget {
  @override
  _DescriptionPlantelSuinosState createState() =>
      _DescriptionPlantelSuinosState();
}

class _DescriptionPlantelSuinosState extends State<DescriptionPlantelSuinos> {
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
                          child: CachacoSuinoScreen(),
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
                          child: MatrizesSuinoScreen(),
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
                          child: AleitamentoSuinoScreen(),
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
                          child: CrecheSuinoScreen(),
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
                          child: TerminacaoSuinoScreen(),
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
                            child: LoteAbatidosSuinoScreen()),
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
