import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/caprinos/second_screen/producao_carne/description_producao.dart';

class ProducaoCarneCaprinoScreen extends StatefulWidget {
  @override
  _ProducaoCarneCaprinoScreenState createState() =>
      _ProducaoCarneCaprinoScreenState();
}

class _ProducaoCarneCaprinoScreenState
    extends State<ProducaoCarneCaprinoScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DescriptionProducaoCaprino()));
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
                        "Produção\nCarne",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.5,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold,
                        ),
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
