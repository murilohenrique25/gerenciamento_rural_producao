import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/screen/tratamentos/tratamento_suino_list.dart';

class TratamentoSuinoScreen extends StatefulWidget {
  @override
  _TratamentoSuinoScreenState createState() => _TratamentoSuinoScreenState();
}

class _TratamentoSuinoScreenState extends State<TratamentoSuinoScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TratamentoSuinoList()));
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
                  height: 20.0,
                  color: Colors.white,
                  child: Row(
                    children: [
                      // Icon(
                      //   Icons.add,
                      //   size: 21.0,
                      // ),
                      Text(
                        "Tratamento",
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
