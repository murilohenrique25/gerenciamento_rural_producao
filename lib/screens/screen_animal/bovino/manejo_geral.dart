import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/description_bl.dart';

class ManejoGeral extends StatefulWidget {
  @override
  _ManejoGeralState createState() => _ManejoGeralState();
}

class _ManejoGeralState extends State<ManejoGeral> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        DescriptionBovinoLeite()));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "images/gadoleite.jpg",
                  height: 150.0,
                  width: 150.0,
                  color: Color.fromRGBO(255, 255, 255, 0.7),
                  colorBlendMode: BlendMode.modulate,
                ),
                Text(
                  "Bovino de Leite",
                  style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 1.0,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
