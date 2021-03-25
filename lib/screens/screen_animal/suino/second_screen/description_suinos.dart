import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/screen/dados_rebanho_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/screen/economia_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/screen/medicamentos_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/screen/nutricao_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/screen/plantel_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/screen/producao_carne_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/screen/reproducao_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/screen/tratamentos_screen.dart';

class DescriptionSuinos extends StatefulWidget {
  @override
  _DescriptionSuinosState createState() => _DescriptionSuinosState();
}

class _DescriptionSuinosState extends State<DescriptionSuinos> {
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
                          child: PlantelSuinoScreen(),
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
                          child: ReproducaoSuinoScreen(),
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
                          child: EconomiaSuinoScreen(),
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
                          child: NutricaoSuinoScreen(),
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
                          child: TratamentoSuinoScreen(),
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
                            child: MedicamentoSuinoScreen()),
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
                          child: ProducaoCarneSuinoScreen(),
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
                          child: DadosRebanhoSuinoScreen(),
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
