import 'package:flutter/material.dart';

showDialogBox(BuildContext context,
    {String title = 'Atenção!',
    String content = 'Você deseja realmente executar essa operação?',
    String affirmativeOption = 'Confirmar'}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              MaterialButton(
                onPressed: () => Navigator.pop(context, true),
                color: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0)),
                child: Text(
                  affirmativeOption.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              MaterialButton(
                onPressed: () => Navigator.pop(context, false),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0)),
                child: const Text('Cancelar'),
              )
            ]);
      });
}
