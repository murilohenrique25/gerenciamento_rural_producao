import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino_corte/dados_rebanho_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino_corte/historico_animal_abatido_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino_corte/nutricao_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino_corte/rebanho_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino_corte/reproducao_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino_corte/saude_tratamento_screen.dart';

class DescriptionBovinoCorte extends StatefulWidget {
  @override
  _DescriptionBovinoCorteState createState() => _DescriptionBovinoCorteState();
}

class _DescriptionBovinoCorteState extends State<DescriptionBovinoCorte> {
  double _height = 130.0;
  double _width = 130.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bovino de Corte"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              "images/telainicial.png",
              fit: BoxFit.cover,
              height: 800.0,
            ),
            Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 60)),
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
                          child: RebanhoScreen(),
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
                          child: DadosRebanhoScreen(),
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
                          child: SaudeTratamentoScreen(),
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
                          child: HistoricoAnimalAbatidoScreen(),
                        ),
                      ],
                    ),
                  ],
                ),
                //Terceira linha
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
                          child: NutricaoScreen(),
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
                          child: ReproducaoScreen(),
                        ),
                      ],
                    ),
                  ],
                ),
                //Quarta linha
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       // Stack(
                //       //   alignment: Alignment.center,
                //       //   children: [
                //       //     Container(
                //       //       width: _width,
                //       //       height: _height,
                //       //       color: Colors.grey[50],
                //       //     ),
                //       //     Padding(
                //       //       padding: EdgeInsets.all(10.0),
                //       //       child: SaudeTratamentoScreen(),
                //       //     ),
                //       //   ],
                //       // ),
                //       Stack(
                //         alignment: Alignment.center,
                //         children: [
                //           Container(
                //             width: _width,
                //             height: _height,
                //             color: Colors.grey[50],
                //           ),
                //           Padding(
                //             padding: EdgeInsets.all(10.0),
                //             child: EconomiaScreen(),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
