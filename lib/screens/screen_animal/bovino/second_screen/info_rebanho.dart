import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/bezerra_db.dart';
import 'package:gerenciamento_rural/helpers/novilha_db.dart';
import 'package:gerenciamento_rural/helpers/touro_db.dart';
import 'package:gerenciamento_rural/helpers/vaca_db.dart';
import 'package:gerenciamento_rural/models/bezerra.dart';
import 'package:gerenciamento_rural/models/novilha.dart';
import 'package:gerenciamento_rural/models/touro.dart';
import 'package:gerenciamento_rural/models/vaca.dart';

class InfoRebanho extends StatefulWidget {
  @override
  _InfoRebanhoState createState() => _InfoRebanhoState();
}

class _InfoRebanhoState extends State<InfoRebanho> {
  TouroDB touroDB = TouroDB();
  VacaDB vacaDB = VacaDB();
  NovilhaDB novilhaDB = NovilhaDB();
  BezerraDB bezerraDB = BezerraDB();

  List<Touro> listTouro = [];
  List<Vaca> listVaca = [];
  List<Novilha> listNovilha = [];
  List<Novilha> listNovilhaInseminada = [];
  List<Bezerra> listBezerra = [];
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
    listTouro = [];
    listVaca = [];
    listNovilha = [];
    listBezerra = [];
    listNovilhaInseminada = [];
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
                      "Touros\n$totalTouro",
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
                      "Vacas\n$totalVacas",
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
                      "Novilhas\n$totalNovilhas",
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
                      "Bezerras\n$totalBezerras",
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
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      "",
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
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      "",
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
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 80.0,
                  color: Colors.deepPurple,
                  child: Center(
                    child: Text(
                      "Vacas Inseminadas\n$quantVacasInseminadadas\n${porcentVacaInseminada.toStringAsFixed(2)}%",
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
                  color: Colors.indigo,
                  height: 80.0,
                  child: Center(
                    child: Text(
                      "Vacas\nVazias\n$quantVacasVazias\n${porcentVacaVazias.toStringAsFixed(2)}%",
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
                      "Vacas\nGestantes\n$quantVacasGestantes\n${porcentVacaGestantes.toStringAsFixed(2)}%",
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
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 80.0,
                  color: Colors.deepOrange,
                  child: Center(
                    child: Text(
                      "Taxa\nde ${quantVacasGestantes / quantVacasInseminadadas} \nConcepção\n",
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
                  color: Colors.indigoAccent[700],
                  height: 80.0,
                  child: Center(
                    child: Text(
                      "Taxa\nde ${(quantVacasGestantes * 100) / quantVacasInseminadadas}\nPrenhez\n",
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
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      "",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
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
