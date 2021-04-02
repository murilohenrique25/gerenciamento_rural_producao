import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/tree_screen/description_plantel.dart';
import 'package:gerenciamento_rural/widgets/intro_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Control IF Goiano",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color.fromARGB(255, 4, 125, 141),
      ),
      debugShowCheckedModeBanner: false,
      routes: {'plantel': (context) => DescriptionPlantelSuinos()},
      home: MyHomePageScreen(),
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [
        const Locale('pt', 'BR'),
      ],
    );
  }
}

class MyHomePageScreen extends StatefulWidget {
  MyHomePageScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageScreenState createState() => _MyHomePageScreenState();
}

class _MyHomePageScreenState extends State<MyHomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return introScreen();
  }
}

// void main() {
//   runApp(
//     MaterialApp(
//         title: "Controle de Gestão Animal",
//         theme: ThemeData(
//             primaryColor: Color.fromARGB(255, 4, 125, 141),
//             primarySwatch: Colors.blue),
//         debugShowCheckedModeBanner: false,
//         home: new SplashScreen(),
//         routes: {
//           '/home': (context) => Home(),
//         }),
//   );
// }
