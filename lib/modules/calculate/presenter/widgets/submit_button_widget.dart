import 'package:flutter/material.dart';

class SubmitButtonWidget extends StatelessWidget {
  final bool loading;
  final dynamic onSubmit;
  final String label;
  final ValueGetter<Future<bool>>? onValidate;
  const SubmitButtonWidget({
    Key? key,
    required this.loading,
    required this.onSubmit,
    required this.onValidate,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFF6D80E5)),
      child: MaterialButton(
        height: 50,
        hoverColor: const Color(0xFF6D80E5).withRed(1),
        highlightColor: const Color(0xFF6D80E5).withRed(1),
        splashColor: const Color(0xFF6D80E5).withRed(1),
        focusColor: const Color(0xFF6D80E5).withRed(1),
        onPressed: () {
          if (loading == false) {
            _buttonPressed(context);
          }
        },
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Future<void> _buttonPressed(BuildContext context) async {
    var valid = true;
    if (onValidate != null) {
      valid = await onValidate!();
      print(valid);
    } else {
      var formState = Form.of(context);
      if (formState != null) {
        valid = formState.validate();
      }
    }

    if (valid == true) {
      onSubmit!();
    } else {
      null;
    }
  }
}
