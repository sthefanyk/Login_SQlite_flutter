import 'package:flutter/material.dart';

class InputFieldLogin extends StatelessWidget {
  final String hintName;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType inputType;
  final bool isObscured;
  final bool enableField;
  final Stream<String> stream;
  final Function(String) onChanged;

  const InputFieldLogin({
    super.key,
    required this.hintName,
    required this.icon,
    required this.controller,
    this.isObscured = false,
    this.inputType = TextInputType.text,
    this.enableField = true,
    required this.stream,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
      ),
      child: StreamBuilder<String>(
          stream: stream,
          builder: (context, snapshot) {
            return TextFormField(
              onChanged: onChanged,
              controller: controller,
              keyboardType: inputType,
              obscureText: isObscured,
              enabled: enableField,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                // errorBorder: OutlineInputBorder(
                //   borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                // ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.error),
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: hintName,
                labelText: hintName,
                prefixIcon: Icon(icon),
                errorText: snapshot.hasError ? snapshot.error.toString() : null,
              ),
            );
          }),
    );
  }
}