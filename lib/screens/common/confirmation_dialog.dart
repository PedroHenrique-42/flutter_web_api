import 'package:flutter/material.dart';

Future<dynamic> showConfirmationDialog(
  BuildContext context, {
  String title = "Atenção!",
  String content = "Você realmente deseja executar essa operação?",
  String affirmativeOption = "Confirmar",
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold),),
        content: Text(content),
        actions: [
          TextButton(onPressed: () {
            Navigator.pop(context, false);
          }, child: const Text("Cancelar")),
          TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                affirmativeOption.toUpperCase(),
                style: const TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                ),
              ))
        ],
      );
    },
  );
}
