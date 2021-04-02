import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/abatidos_db.dart';
import 'package:gerenciamento_rural/helpers/aleitamento_db.dart';
import 'package:gerenciamento_rural/helpers/cachaco_db.dart';
import 'package:gerenciamento_rural/helpers/creche_db.dart';
import 'package:gerenciamento_rural/helpers/matriz_db.dart';
import 'package:gerenciamento_rural/helpers/terminacao_db.dart';
import 'package:gerenciamento_rural/models/abatidos.dart';
import 'package:gerenciamento_rural/models/aleitamento.dart';
import 'package:gerenciamento_rural/models/cachaco.dart';
import 'package:gerenciamento_rural/models/creche.dart';
import 'package:gerenciamento_rural/models/matriz.dart';
import 'package:gerenciamento_rural/models/terminacao.dart';

class InfoRebanhoSuinos extends StatefulWidget {
  @override
  _InfoRebanhoSuinosState createState() => _InfoRebanhoSuinosState();
}

class _InfoRebanhoSuinosState extends State<InfoRebanhoSuinos> {
  CachacoDB cachacoDB = CachacoDB();
  MatrizDB matrizDB = MatrizDB();
  AleitamentoDB aleitamentoDB = AleitamentoDB();
  CrecheDB crecheDB = CrecheDB();
  TerminacaoDB terminacaoDB = TerminacaoDB();
  AbatidosDB abatidosDB = AbatidosDB();

  List<Cachaco> listCachaco = List();
  List<Matriz> listMatriz = List();
  List<Aleitamento> listAleitamento = List();
  List<Creche> listCreche = List();
  List<Terminacao> listTerminacao = List();
  List<Abatido> listAbatido = List();

  int totalCachaco = 0;
  int totalMatriz = 0;
  int totalAleitamento = 0;
  int totalCreche = 0;
  int totalTerminacao = 0;
  int totalAbatidos = 0;

  @override
  void initState() {
    super.initState();
    listCachaco = List();
    listMatriz = List();
    listAleitamento = List();
    listCreche = List();
    listTerminacao = List();
    listAbatido = List();
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
          Padding(
            padding: EdgeInsets.only(top: 15.0),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.blue,
                  height: 80.0,
                  child: Center(
                    child: Text(
                      "Matrizes\n$totalMatriz",
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
                      "Cachaços\n$totalCachaco",
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
                      "Aleitamento\n$totalAleitamento",
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
                      "Creche\n$totalCreche",
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
                      "Terminação\n$totalTerminacao",
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
                      "Abatidos\n$totalAbatidos",
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
    cachacoDB.getAllItems().then((value) {
      setState(() {
        listCachaco = (value);
        totalCachaco = listCachaco.length;
      });
    });
    matrizDB.getAllItems().then((value) {
      setState(() {
        listMatriz = value;
        totalMatriz = listMatriz.length;
      });
    });
    aleitamentoDB.getAllItems().then((value) {
      setState(() {
        listAleitamento = value;
        totalAleitamento = listAleitamento.length;
      });
    });
    crecheDB.getAllItems().then((value) {
      setState(() {
        listCreche = value;
        totalCreche = listCreche.length;
      });
    });
    terminacaoDB.getAllItems().then((value) {
      setState(() {
        listTerminacao = value;
        totalTerminacao = listTerminacao.length;
      });
    });
    abatidosDB.getAllItems().then((value) {
      setState(() {
        listAbatido = value;
        totalAbatidos = listAbatido.length;
      });
    });
  }
}
