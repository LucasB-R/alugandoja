import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:static_translations/static_translations.dart';
import 'package:provider/provider.dart';

class AppWidget extends StatelessWidget {
  final Translator translator;
  const AppWidget({
    Key? key,
    required this.translator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<Translator>.value(
      value: translator,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: MaterialApp(
          title: 'AlugandoJá - Cálculo de Alugueis',
          theme: ThemeData(primarySwatch: Colors.blue),
          debugShowCheckedModeBanner: false,
        ).modular(),
      ),
    ); //added by extension
  }
}
