import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/description_bl.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino_corte/description_bc.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/description_suinos.dart';
import 'package:gerenciamento_rural/screens/screen_animal/touros/description_touro.dart';
import 'package:gerenciamento_rural/screens/utilitarios/lote.dart';
import 'package:gerenciamento_rural/screens/utilitarios/medicamentos.dart';
import 'package:gerenciamento_rural/tiles/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color.fromARGB(255, 203, 236, 241), Colors.white],
                begin: Alignment.bottomCenter,
                end: Alignment.topRight),
          ),
        );
    return Drawer(
      child: Stack(
        children: [
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(top: 16.0),
            children: [
              UserAccountsDrawerHeader(
                accountName: Text("Gestão Rural"),
                accountEmail: Text("gestaorural@gest.com"),
                currentAccountPicture: CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqkmw7aMpKaPkg1DJJoZLYi7FucZ-3M-ExHA&usqp=CAU'),
                ),
              ),
              DrawerTile(
                  Icons.home, "Bovino de Leite", DescriptionBovinoLeite()),
              DrawerTile(
                  Icons.list, "Bovino de Corte", DescriptionBovinoCorte()),
              DrawerTile(Icons.all_inclusive, "Suínos", DescriptionSuinos()),
              DrawerTile(Icons.text_fields, "Touros", DescriptionTouro()),
              DrawerTile(Icons.apps, "Lotes", Lotes()),
              DrawerTile(Icons.library_add, "Medicamentos", Medicamentos())
            ],
          ),
        ],
      ),
    );
  }
}
