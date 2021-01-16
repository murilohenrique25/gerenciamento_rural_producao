import 'package:flutter/material.dart';

class ProducaoLeite extends StatefulWidget {
  @override
  _ProducaoLeiteState createState() => _ProducaoLeiteState();
}

class _ProducaoLeiteState extends State<ProducaoLeite> {
  String _teste = "False L";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
            onTap: () {
              setState(() {
                if (_teste == "False L") {
                  _teste = "True L";
                } else {
                  _teste = "False L";
                }
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                "images/producaoleite.jpg",
                width: 100.0,
                height: 100.0,
              ),
            )),
        Text("Produção de Leite",
            style: TextStyle(
              color: Colors.black,
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
            )),
        Text(_teste),
      ],
    );
  }
}
