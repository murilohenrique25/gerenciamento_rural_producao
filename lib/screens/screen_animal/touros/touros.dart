import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/touros/reproducao.dart';

class ManejoGeral extends StatefulWidget {
  @override
  _ManejoGeralState createState() => _ManejoGeralState();
}

class _ManejoGeralState extends State<ManejoGeral> {
  String _teste = "False";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (_teste == "False") {
                _teste = "True";
              } else {
                _teste = "False";
              }
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Reproducao()));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              "images/gadoleite.jpg",
              height: 100.0,
              width: 100.0,
            ),
          ),
        ),
        Text(
          "Gado de Leite",
          style: TextStyle(
              color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.bold),
        ),
        Text(_teste),
      ],
    );
  }
}
