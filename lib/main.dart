import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:trabalho_faculdade/telas/login.dart';
import 'package:trabalho_faculdade/util/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TrabalhoFaculdade());
}

class TrabalhoFaculdade extends StatelessWidget {
  const TrabalhoFaculdade({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trabalho Faculdade',
      debugShowCheckedModeBanner: false,
      home: Login(),
      theme: ThemeData(
        scaffoldBackgroundColor: MyColors.neutralBackground,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt'),
      ],
    );
  }
}
