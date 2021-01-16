import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget widget;
  //Construtor
  DrawerTile(this.icon, this.text, this.widget);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
              // ignore: non_constant_identifier_names
              context,
              MaterialPageRoute(builder: (BuildContext context) => widget));
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: [
              Icon(
                icon,
                size: 32.0,
                color: Colors.black,
              ),
              SizedBox(
                width: 32.0,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
