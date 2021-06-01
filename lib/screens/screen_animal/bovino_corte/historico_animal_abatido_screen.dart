import 'dart:ui';
import 'package:flutter/material.dart';

class HistoricoAnimalAbatidoScreen extends StatefulWidget {
  @override
  _HistoricoAnimalAbatidoScreenState createState() =>
      _HistoricoAnimalAbatidoScreenState();
}

class _HistoricoAnimalAbatidoScreenState
    extends State<HistoricoAnimalAbatidoScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => DescriptionPlantelCaprinos()),
            // );
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
                      Text(
                        "Histórico\nAnimais\nAnatidos",
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
