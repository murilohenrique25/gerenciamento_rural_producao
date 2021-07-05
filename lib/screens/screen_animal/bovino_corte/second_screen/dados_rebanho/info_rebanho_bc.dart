import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/bezerra_corte_db.dart';
import 'package:gerenciamento_rural/helpers/bezerro_corte_db.dart';
import 'package:gerenciamento_rural/helpers/corte_abatidos_db.dart';
import 'package:gerenciamento_rural/helpers/garrote_corte_db.dart';
import 'package:gerenciamento_rural/helpers/novilha_corte_db.dart';
import 'package:gerenciamento_rural/helpers/touro_corte_db.dart';
import 'package:gerenciamento_rural/helpers/vaca_corte_db.dart';
import 'package:gerenciamento_rural/models/bezerra_corte.dart';
import 'package:gerenciamento_rural/models/bezerro_corte.dart';
import 'package:gerenciamento_rural/models/garrote_corte.dart';
import 'package:gerenciamento_rural/models/novilha_corte.dart';
import 'package:gerenciamento_rural/models/touro_corte.dart';
import 'package:gerenciamento_rural/models/vaca_corte.dart';

class InfoRebanhoBovinoCorte extends StatefulWidget {
  @override
  _InfoRebanhoBovinoCorteState createState() => _InfoRebanhoBovinoCorteState();
}

class _InfoRebanhoBovinoCorteState extends State<InfoRebanhoBovinoCorte> {
  TouroCorteDB touroDB = TouroCorteDB();
  VacaCorteDB vacaDB = VacaCorteDB();
  BezerraCorteDB bezerraDB = BezerraCorteDB();
  BezerroCorteDB bezerroDB = BezerroCorteDB();
  GarroteCorteDB garroteDB = GarroteCorteDB();
  NovilhaCorteDB novilhaDB = NovilhaCorteDB();
  CorteAbatidosDB corteAbatidosDB = CorteAbatidosDB();

  List<TouroCorte> touros = [];
  List<VacaCorte> vacas = [];
  List<BezerraCorte> bezerras = [];
  List<BezerroCorte> bezerros = [];
  List<GarroteCorte> garrotes = [];
  List<NovilhaCorte> novilhas = [];

  int totalVacasGestantes = 0;
  int totalVacasVazias = 0;
  int totalVacasInseminadas = 0;
  int totalnovilhaGestantes = 0;
  int totalnovilhaVazias = 0;
  int totalnovilhaInseminadas = 0;

  int totalAborto = 0;
  int partosDistocicosAnuais = 0;
  int partosNormaisAnuais = 0;
  int quantidadeAnimaisAbatidos = 0;
  int mortesAnuais = 0;
  int nascimentosAnuais = 0;
  double pesoMedioDesmama = 0;
  int quantPesoMedioDesmama = 0;
  double pesoMedioPrimeiraCobertura;
  int quantpesoMedioPrimeiraCobertura;
  int quantpesoMedioPrimeiroParto;
  double pesoMedioPrimeiroParto;

  int total8M = 0;
  int total12M = 0;
  int total24M = 0;
  int total36M = 0;
  int total37M = 0;

  int total8F = 0;
  int total12F = 0;
  int total24F = 0;
  int total36F = 0;
  int total37F = 0;

  @override
  void initState() {
    super.initState();
    touros = [];
    vacas = [];
    bezerras = [];
    bezerros = [];
    novilhas = [];
    garrotes = [];
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                    'Idade por Meses\n0 - 8\n9 - 12\n13 - 24\n25 - 36\n36+'),
              ),
              Expanded(
                child: Text(
                    'Macho\n$total8M\n$total12M\n$total24M\n$total36M\n$total37M'),
              ),
              Expanded(
                child: Text(
                    'Fêmea\n$total8F\n$total12F\n$total24F\n$total36F\n$total37F'),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.indigo,
                  height: 80.0,
                  child: Center(
                    child: Text(
                      "Vacas Gestantes\n$totalVacasGestantes",
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
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      "Vacas Vazias\n$totalVacasVazias",
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
                      "Vacas Inseminadas\n$totalVacasInseminadas",
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
                  color: Colors.teal,
                  height: 80.0,
                  child: Center(
                    child: Text(
                      "Novilhas Gestantes\n$totalnovilhaGestantes",
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
                      "Novilhas Vazias\n$totalnovilhaVazias",
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
                  color: Colors.brown,
                  child: Center(
                    child: Text(
                      "Novilhas Inseminadas\n$totalnovilhaInseminadas",
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
                  color: Colors.teal,
                  height: 80.0,
                  child: Center(
                    child: Text(
                      "Peso Médio Primeira\nCobertura Novilhas\n${pesoMedioPrimeiraCobertura / quantpesoMedioPrimeiraCobertura}",
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
                      "Peso Médio Primeiro\Parto Novilhas\n${pesoMedioPrimeiroParto / quantpesoMedioPrimeiroParto}",
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
                      "Peso Médio Desmama\n${pesoMedioDesmama / quantPesoMedioDesmama}",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.teal,
                  height: 80.0,
                  child: Center(
                    child: Text(
                      "Abortos Anuais\n$totalAborto",
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
                      "Partos Distócicos\n$partosDistocicosAnuais",
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
                  color: Colors.brown,
                  child: Center(
                    child: Text(
                      "Partos Normais\n$partosNormaisAnuais",
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
                  color: Colors.teal,
                  height: 80.0,
                  child: Center(
                    child: Text(
                      "Animais Abatidos\n$quantidadeAnimaisAbatidos",
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
                      "Mortes Anuais\n$mortesAnuais",
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
                  color: Colors.brown,
                  child: Center(
                    child: Text(
                      "Nascimentos Anuais\n$nascimentosAnuais",
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
                  color: Colors.brown,
                  child: Center(
                    child: Text(
                      "Taxa de Prenhez\n Anual\n${(totalVacasGestantes * 100) / totalVacasInseminadas}%",
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
          SizedBox(
            height: 35.0,
          ),
        ],
      ),
    );
  }

  int differenceDate(String data) {
    String num = "";
    DateTime dt = DateTime.now();
    num = data.split('-').reversed.join();

    DateTime date = DateTime.parse(num);
    int quant = dt.difference(date).inDays;

    return quant;
  }

  void _carregarDados() {
    touroDB.getAllItems().then((value) {
      setState(() {
        touros = (value);
        touros.forEach((element) {
          int dias = differenceDate(element.dataNascimento);
          if (dias < 244) {
            total8M += 1;
          } else if (dias < 365) {
            total12M += 1;
          } else if (dias < 730) {
            total24M += 1;
          } else if (dias < 1095) {
            total36M += 1;
          } else {
            total37M += 1;
          }
        });
      });
    });
    vacaDB.getAllItems().then((value) {
      setState(() {
        vacas = value;
        vacas.forEach((element) {
          if (element.diagnosticoGestacao == "Gestante") {
            totalVacasGestantes += 1;
          } else if (element.diagnosticoGestacao == "Inseminada") {
            totalVacasInseminadas += 1;
          } else if (element.diagnosticoGestacao == "Vazia") {
            totalVacasVazias += 1;
          } else {
            totalAborto += 1;
          }
          if (element.tipoParto == "Parto Normal") {
            partosNormaisAnuais += 1;
          } else {
            partosDistocicosAnuais += 1;
          }
          int dias = differenceDate(element.dataNascimento);
          if (dias < 244) {
            total8F += 1;
          } else if (dias < 365) {
            total12F += 1;
          } else if (dias < 730) {
            total24F += 1;
          } else if (dias < 1095) {
            total36F += 1;
          } else {
            total37F += 1;
          }
        });
      });
    });
    novilhaDB.getAllItems().then((value) {
      setState(() {
        novilhas = value;

        novilhas.forEach((element) {
          if (element.pesoPrimeiraCobertura != null) {
            quantpesoMedioPrimeiraCobertura += 1;
            pesoMedioPrimeiraCobertura += element.pesoPrimeiraCobertura;
          }
          if (element.pesoPrimeiroParto != null) {
            quantpesoMedioPrimeiroParto += 1;
            pesoMedioPrimeiroParto += element.pesoPrimeiroParto;
          }

          if (element.diagnosticoGestacao == "Gestante") {
            totalnovilhaGestantes += 1;
          } else if (element.diagnosticoGestacao == "Inseminada") {
            totalnovilhaInseminadas += 1;
          } else if (element.diagnosticoGestacao == "Vazia") {
            totalnovilhaVazias += 1;
          } else {
            totalAborto += 1;
          }
          if (element.tipoParto == "Parto Normal") {
            partosNormaisAnuais += 1;
          } else {
            partosDistocicosAnuais += 1;
          }
          int dias = differenceDate(element.dataNascimento);
          if (dias < 244) {
            total8F += 1;
          } else if (dias < 365) {
            total12F += 1;
          } else if (dias < 730) {
            total24F += 1;
          } else if (dias < 1095) {
            total36F += 1;
          } else {
            total37F += 1;
          }
        });
      });
    });
    garroteDB.getAllItems().then((value) {
      setState(() {
        garrotes = value;
        garrotes.forEach((element) {
          if (element.pesoDesmama != null) {
            pesoMedioDesmama += element.pesoDesmama;
            quantPesoMedioDesmama += 1;
          }
          int dias = differenceDate(element.dataNascimento);
          if (dias < 244) {
            total8M += 1;
          } else if (dias < 365) {
            total12M += 1;
          } else if (dias < 730) {
            total24M += 1;
          } else if (dias < 1095) {
            total36M += 1;
          } else {
            total37M += 1;
          }
        });
      });
    });
    bezerraDB.getAllItems().then((value) {
      setState(() {
        bezerras = value;
        bezerras.forEach((element) {
          if (element.pesoDesmama != null) {
            pesoMedioDesmama += element.pesoDesmama;
            quantPesoMedioDesmama += 1;
          }
          int dias = differenceDate(element.dataNascimento);
          if (dias < 244) {
            total8F += 1;
          } else if (dias < 365) {
            total12F += 1;
          } else if (dias < 730) {
            total24F += 1;
          } else if (dias < 1095) {
            total36F += 1;
          } else {
            total37F += 1;
          }
        });
      });
    });
    bezerroDB.getAllItems().then((value) {
      setState(() {
        bezerros = value;
        bezerros.forEach((element) {
          if (element.pesoDesmama != null) {
            pesoMedioDesmama += element.pesoDesmama;
            quantPesoMedioDesmama += 1;
          }
          int dias = differenceDate(element.dataNascimento);
          if (dias < 244) {
            total8M += 1;
          } else if (dias < 365) {
            total12M += 1;
          } else if (dias < 730) {
            total24M += 1;
          } else if (dias < 1095) {
            total36M += 1;
          } else {
            total37M += 1;
          }
        });
      });
    });

    corteAbatidosDB.getNumber().then((value) {
      quantidadeAnimaisAbatidos = value;
    });
  }
}
