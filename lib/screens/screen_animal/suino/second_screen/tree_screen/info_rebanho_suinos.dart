import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/bezerra_db.dart';
import 'package:gerenciamento_rural/helpers/novilha_db.dart';
import 'package:gerenciamento_rural/helpers/touro_db.dart';
import 'package:gerenciamento_rural/helpers/vaca_db.dart';
import 'package:gerenciamento_rural/models/bezerra.dart';
import 'package:gerenciamento_rural/models/novilha.dart';
import 'package:gerenciamento_rural/models/touro.dart';
import 'package:gerenciamento_rural/models/vaca.dart';

class InfoRebanhoSuinos extends StatefulWidget {
  @override
  _InfoRebanhoSuinosState createState() => _InfoRebanhoSuinosState();
}

class _InfoRebanhoSuinosState extends State<InfoRebanhoSuinos> {
  TouroDB touroDB = TouroDB();
  VacaDB vacaDB = VacaDB();
  NovilhaDB novilhaDB = NovilhaDB();
  BezerraDB bezerraDB = BezerraDB();

  List<Touro> listTouro = List();
  List<Vaca> listVaca = List();
  List<Novilha> listNovilha = List();
  List<Novilha> listNovilhaInseminada = List();
  List<Bezerra> listBezerra = List();
  int totalVacas = 0;
  int totalNovilhas = 0;
  int totalBezerras = 0;
  int totalTouro = 0;
  int quantVacasInseminadadas = 0;
  int quantVacasGestantes = 0;
  int quantVacasVazias = 0;
  double porcentVacaInseminada = 0.0;
  double porcentVacaGestantes = 0.0;
  double porcentVacaVazias = 0.0;

  @override
  void initState() {
    super.initState();
    listTouro = List();
    listVaca = List();
    listNovilha = List();
    listBezerra = List();
    listNovilhaInseminada = List();
    _carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rebanho"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.blue,
                  height: 80.0,
                  child: Center(
                    child: Text(
                      "Matrizes\n$totalTouro",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              Expanded(
                child: Container(
                  height: 80.0,
                  color: Colors.green,
                  child: Center(
                    child: Text(
                      "Cachaços\n$totalVacas",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              Expanded(
                child: Container(
                  height: 80.0,
                  color: Colors.yellow,
                  child: Center(
                    child: Text(
                      "Aleitamento\n$totalNovilhas",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.brown,
                  height: 80.0,
                  child: Center(
                    child: Text(
                      "Creche\n$totalBezerras",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              Expanded(
                child: Container(
                  height: 80.0,
                  color: Colors.indigo,
                  child: Center(
                    child: Text(
                      "Terminação\n0",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              Expanded(
                child: Container(
                  height: 80.0,
                  color: Colors.teal,
                  child: Center(
                    child: Text(
                      "Abatidos\n0",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 35.0,
          ),
        ],
      ),
    );
  }

  void _carregarDados() {
    touroDB.getAllVivos().then((value) {
      setState(() {
        listTouro = (value);
        totalTouro = listTouro.length;
      });
    });
    vacaDB.getAllItems().then((value) {
      setState(() {
        listVaca = value;
        totalVacas = listVaca.length;
        listVaca.forEach((element) {
          if (element.diagnosticoGestacao == "Gestante") {
            quantVacasGestantes += 1;
          }
          if (element.diagnosticoGestacao == "Vazia" ||
              element.diagnosticoGestacao == "Aborto") {
            quantVacasVazias += 1;
          }
          if (element.ultimaInseminacao != null) {
            quantVacasInseminadadas += 1;
          }
        });
      });
    });
    novilhaDB.getAllItems().then((value) {
      setState(() {
        listNovilha = value;
        totalNovilhas = listNovilha.length;
        listNovilha.forEach((element) {
          if (element.dataCobertura != null) {
            quantVacasInseminadadas += 1;
          }
        });
      });
    });
    bezerraDB.getAllItems().then((value) {
      setState(() {
        listBezerra = value;
        totalBezerras = listBezerra.length;
      });
    });
    vacaDB.getNumber().then((value) {
      totalVacas = value;

      novilhaDB.getNumber().then((value) {
        totalNovilhas = value;
        porcentVacaGestantes = (quantVacasGestantes / totalVacas) * 100;
        porcentVacaInseminada = (quantVacasInseminadadas / totalVacas) * 100;
        porcentVacaVazias = (quantVacasVazias / totalVacas) * 100;
        if (porcentVacaGestantes.isNaN) {
          porcentVacaGestantes = 0;
        }
        if (porcentVacaInseminada.isNaN) {
          porcentVacaInseminada = 0;
        }
        if (porcentVacaVazias.isNaN) {
          porcentVacaVazias = 0;
        }
      });
    });
  }
}
