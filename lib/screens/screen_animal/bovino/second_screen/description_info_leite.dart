import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/description_coleta_leite.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/description_prod_leite.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/description_receita_leite.dart';

class DescriptionInfoLeite extends StatefulWidget {
  @override
  _DescriptionInfoLeiteState createState() => _DescriptionInfoLeiteState();
}

class _DescriptionInfoLeiteState extends State<DescriptionInfoLeite> {
  double _height = 130.0;
  double _width = 130.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Produção Leite"),
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
                          child: DescriptionColetaLeite(),
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
                          child: DescriptionProdLeite(),
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
                          child: DescriptionReceitaLeite(),
                        ),
                      ],
                    ),
                  ],
                ),
                //Terceira linha
              ],
            )
          ],
        ),
      ),
    );
  }
}
