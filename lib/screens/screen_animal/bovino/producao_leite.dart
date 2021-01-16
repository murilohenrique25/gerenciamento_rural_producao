import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/description_prod_leite.dart';

class ProducaoLeite extends StatefulWidget {
  @override
  _ProducaoLeiteState createState() => _ProducaoLeiteState();
}

class _ProducaoLeiteState extends State<ProducaoLeite> {
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
                          DescriptionProdLeite()));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "images/producaoleite.jpg",
                    width: 150.0,
                    height: 150.0,
                    color: Color.fromRGBO(255, 255, 255, 0.7),
                    colorBlendMode: BlendMode.modulate,
                  ),
                  Text(
                    "Produção de\nLeite",
                    style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 1.0,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.white),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
