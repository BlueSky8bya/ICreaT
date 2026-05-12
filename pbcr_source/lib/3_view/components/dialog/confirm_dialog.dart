import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final VoidCallback? onOk;
  final VoidCallback? onCancel;
  final String title;
  final String message;
  final String ok;
  final String cancel;

  const ConfirmDialog({
    super.key,
    this.title = '확실한가요?',
    this.message = '',
    this.ok = '확인',
    this.cancel = '취소',
    this.onOk,
    this.onCancel
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.white,
          width: 0,
        ),
        borderRadius: BorderRadius.circular(18.0),
      ),
      elevation: 3.0,
      shadowColor: Colors.black,
      title: Text(title, style: const TextStyle(fontSize: 18.0)),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            onCancel?.call();
            Navigator.pop(context);
          },
          child: Text(cancel),
        ),
        TextButton(
          onPressed: () {
            onOk?.call();
            Navigator.pop(context);
          },
          child: Text(ok),
        ),
      ],
    );
  }
}
