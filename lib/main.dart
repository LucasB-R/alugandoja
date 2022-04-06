import 'package:admob_flutter/admob_flutter.dart';
import 'package:alugandoja/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:alugandoja/app_module.dart';
import 'package:alugandoja/app_widget.dart';
import 'package:static_translations/static_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Admob.initialize(testDeviceIds: ['DD272EF229E7C7C2EBFB0EF759B95A3F']);

  Translator translator = Translator(
    language: 'pt_BR',
    loaders: {
      'pt_BR': [
        TranslationLoader.asset('assets/languages/pt_BR.json'),
      ],
    },
  );
  await translator.initialize();

  return runApp(ModularApp(
    module: AppModule(),
    child: AppWidget(translator: translator),
  ));
}
