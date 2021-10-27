import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/cadastro_animal.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/nutricao.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/producao_leite.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/rebanho.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/saude_tratamento.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/touro.dart';

class DescriptionBovinoLeite extends StatefulWidget {
  @override
  _DescriptionBovinoLeiteState createState() => _DescriptionBovinoLeiteState();
}

class _DescriptionBovinoLeiteState extends State<DescriptionBovinoLeite> {
  double _height = 130.0;
  double _width = 130.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bovino de Leite"),
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
                          child: CadastrarAnimal(),
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
                          child: SaudeTratamento(),
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
                          child: Nutricao(),
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
                          child: ProducaoLeite(),
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
                          child: Rebanho(),
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
                          child: TouroBL(),
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
