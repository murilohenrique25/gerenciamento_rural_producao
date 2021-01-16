import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino_corte/cadastrar_animal.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino_corte/listar_animais.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino_corte/nutricao.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino_corte/rebanho.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino_corte/reproducao.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino_corte/saude_tratamento.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino_corte/touro_e_inseminacao.dart';

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
            // Image.asset(
            //   "images/telainicial.png",
            //   fit: BoxFit.cover,
            //   height: 600.0,
            // ),
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
                          child: ListarAnimais(),
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
                          child: Reproducao(),
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
                          child: SaudeTratamento(),
                        ),
                      ],
                    ),
                  ],
                ),
                //Quarta linha
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
                          child: TouroInseminacao(),
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
