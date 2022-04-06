import 'package:admob_flutter/admob_flutter.dart';
import 'package:alugandoja/modules/calculate/domain/entities/calculation_params.dart';
import 'package:alugandoja/modules/calculate/presenter/bloc/calculate_bloc.dart';
import 'package:alugandoja/modules/calculate/presenter/events/calculate_events.dart';
import 'package:alugandoja/modules/calculate/presenter/states/calculate_states.dart';
import 'package:alugandoja/modules/calculate/presenter/widgets/submit_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:form_validation/form_validation.dart';

class CalculatePage extends StatefulWidget {
  const CalculatePage({Key? key}) : super(key: key);

  @override
  _CalculatePageState createState() => _CalculatePageState();
}

class _CalculatePageState extends State<CalculatePage> {
  final valueController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');
  final expectedValueController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');
  final bedRoomsController = TextEditingController();
  final bloc = Modular.get<CalculateBloc>();

  late final bannerSize;
  late final interstitialAd;
  @override
  void initState() {
    super.initState();

    // You should execute `Admob.requestTrackingAuthorization()` here before showing any ad.

    bannerSize = AdmobBannerSize.BANNER;

    interstitialAd = AdmobInterstitial(
      adUnitId: 'ca-app-pub-5185198542099712/6220919103',
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        print(event);
      },
    );

    interstitialAd.load();
  }

  @override
  void dispose() {
    interstitialAd.dispose();
    bloc.close();
    super.dispose();
  }

  final List<String> _locations = [
    'Classe Alta',
    'Classe Média',
    'Classe Baixa'
  ]; // Option 2
  late dynamic _selectedLocation = 'Classe Alta'; // Option 2

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double fullWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            child: Builder(builder: (context) {
              return StreamBuilder(
                  stream: bloc.stream,
                  builder: (context, snapshot) {
                    final state = bloc.state;

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(top: 30),
                            width: fullWidth,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text('Alugando',
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w300)),
                                    Text(
                                      'Já',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                      'Calcule o valor de aluguel de forma simples rápida e segura',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: fullHeight * 0.05),
                          if (state is CalculateError)
                            Column(
                              children: [
                                const Text(
                                  'Tente novamente, parece que ocorreu um erro!',
                                  style: TextStyle(color: Colors.red),
                                ),
                                SizedBox(height: fullHeight * 0.05),
                                SubmitButtonWidget(
                                  label: 'Tentar novamente',
                                  loading: false,
                                  onSubmit: () async {
                                    final isLoaded =
                                        await interstitialAd.isLoaded;
                                    if (isLoaded ?? false) {
                                      interstitialAd.show();
                                    }
                                    bloc.add(ResetResult());
                                  },
                                  onValidate: () async {
                                    return true;
                                  },
                                )
                              ],
                            ),
                          if (state is CalculateResult)
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                width: fullWidth,
                                height: fullHeight * 0.75,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color(0xFFD6E0EB)),
                                child: Center(
                                  child: Container(
                                    child: Column(children: [
                                      SizedBox(height: fullHeight * 0.2),
                                      Text(
                                          "Preço mínimo: R\$ ${state.result.minValue.toStringAsFixed(2).replaceAll('.', ',')}",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w300)),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                          "Preço máximo: R\$ ${state.result.maxValue.toStringAsFixed(2).replaceAll('.', ',')}",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w300)),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(state.result.complementsText,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300)),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      const Spacer(),
                                      SubmitButtonWidget(
                                        label: 'Calcular novamente',
                                        loading: false,
                                        onSubmit: () async {
                                          final isLoaded =
                                              await interstitialAd.isLoaded;
                                          if (isLoaded ?? false) {
                                            interstitialAd.show();
                                          }
                                          bloc.add(ResetResult());
                                        },
                                        onValidate: () async {
                                          return true;
                                        },
                                      )
                                    ]),
                                  ),
                                )),
                          if (state is Calculating)
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                width: fullWidth,
                                height: fullHeight * 0.75,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color(0xFFD6E0EB)),
                                child: const Center(
                                    child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: CircularProgressIndicator()))),
                          if (state is CalculationStart) ...{
                            const Text(
                              'Insira as informações abaixo:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              width: fullWidth,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color(0xFFD6E0EB)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Valor do ímovel:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: valueController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        var validator = Validator(
                                          validators: [
                                            RequiredValidator(),
                                          ],
                                        );

                                        return validator.validate(
                                          context: context,
                                          label: 'O Valor',
                                          value: value,
                                        );
                                      },
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '',
                                        hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.4),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  const Text(
                                    'Número de quartos:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Material(
                                    elevation: 10,
                                    color: const Color(0xFFD6E0EB),
                                    borderRadius: BorderRadius.circular(8),
                                    shadowColor: Colors.grey.withOpacity(0.5),
                                    child: TextFormField(
                                      controller: bedRoomsController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        var validator = Validator(
                                          validators: [
                                            RequiredValidator(),
                                          ],
                                        );

                                        return validator.validate(
                                          context: context,
                                          label: 'O nº de quartos',
                                          value: value,
                                        );
                                      },
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                              color: Colors.white, width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                              color: Colors.white, width: 1.0),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                              color: Colors.white, width: 1.0),
                                        ),
                                        hintText: '2',
                                        hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.15),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  const Text(
                                    'O Bairro é do tipo:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    width: fullWidth,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value: _selectedLocation,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _selectedLocation = newValue;
                                        });
                                      },
                                      underline: const SizedBox(),
                                      alignment: Alignment.topRight,
                                      items: _locations.map((location) {
                                        return DropdownMenuItem(
                                          child: Container(
                                            alignment:
                                                AlignmentDirectional.center,
                                            child: Text(location),
                                          ),
                                          value: location,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Row(children: <Widget>[
                                    SizedBox(
                                        width: fullWidth * 0.1,
                                        child: Divider(
                                          color: Colors.black.withOpacity(0.2),
                                          thickness: 1,
                                        )),
                                    const Text("opcionais",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w100)),
                                    Expanded(
                                        child: Divider(
                                      color: Colors.black.withOpacity(0.2),
                                      thickness: 1,
                                    )),
                                  ]),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Por quanto gostaria que fosse alugado?',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: expectedValueController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        var validator = Validator(
                                          validators: [
                                            RequiredValidator(),
                                          ],
                                        );

                                        return validator.validate(
                                          context: context,
                                          label: 'O Valor',
                                          value: value,
                                        );
                                      },
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '',
                                        hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.4),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  SubmitButtonWidget(
                                    label: "Realizar Cálculo",
                                    loading: false,
                                    onSubmit: () async {
                                      final isLoaded =
                                          await interstitialAd.isLoaded;
                                      if (isLoaded ?? false) {
                                        interstitialAd.show();
                                      }
                                      submit();
                                    },
                                    onValidate: () async {
                                      var error = Form.of(context)?.validate();
                                      return error ?? false;
                                    },
                                  )
                                ],
                              ),
                            ),
                          },
                          const SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: AdmobBanner(
                              adUnitId:
                                  'ca-app-pub-5185198542099712/6771814951',
                              adSize: bannerSize!,
                              listener: (AdmobAdEvent event,
                                  Map<String, dynamic>? args) {
                                print(event);
                              },
                              onBannerCreated:
                                  (AdmobBannerController controller) {
                                // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
                                // Normally you don't need to worry about disposing this yourself, it's handled.
                                // If you need direct access to dispose, this is your guy!
                                // controller.dispose();
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }),
          ),
        ),
      ),
    );
  }

  submit() async {
    CalculationParams params = CalculationParams(
        residenceValue: valueController.numberValue,
        expectedValue: expectedValueController.numberValue == 0.0
            ? null
            : expectedValueController.numberValue,
        bedroomsNumber: int.parse(bedRoomsController.text),
        region: _getRegionId(_selectedLocation));

    bloc.add(Calculate(params));
  }

  _getRegionId(selectedLocation) {
    if (selectedLocation == "Classe Alta") {
      return 1;
    }

    if (selectedLocation == "Classe Média") {
      return 2;
    }

    if (selectedLocation == "Classe Baixa") {
      return 3;
    }
  }
}
