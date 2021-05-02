import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/caprinos/second_screen/reproducao/historico_parto_caprino_list.dart';

class HistoricoPartoCaprinoScreen extends StatefulWidget {
  @override
  _HistoricoPartoCaprinoScreenState createState() => _HistoricoPartoCaprinoScreenState();
}

class _HistoricoPartoCaprinoScreenState extends State<HistoricoPartoCaprinoScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ListaHistoricoPartoCaprino()));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "images/fundocinza.jpg",
                  height: 150.0,
                  width: 150.0,
                  color: Color.fromRGBO(255, 255, 255, 0.7),
                  colorBlendMode: BlendMode.modulate,
                ),
                Container(
                  height: 40.0,
                  color: Colors.white,
                  child: Row(
                    children: [
                      // Icon(
                      //   Icons.add,
                      //   size: 21.0,
                      // ),
                      Text(
                        "Histórico\nde Partos",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.5,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
