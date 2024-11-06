import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageDialog extends ConsumerWidget {
  static const int responseCodePositive = 1;

  static const int responseCodeNegative = -1;

  final String? _title;

  final String? _body;

  final String? _negativeButtonText;

  final String? _positiveButtonText;

  const MessageDialog({
    String? title,
    String? body,
    String? negativeButtonText,
    String? positiveButtonText,
    super.key,
  })  : _title = title,
        _body = body,
        _negativeButtonText = negativeButtonText,
        _positiveButtonText = positiveButtonText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: _title != null ? Text(_title) : null,
      content: _body != null ? Text(_body) : null,
      actions: <Widget>[
        if (_negativeButtonText != null)
          TextButton(
            child: Text(_negativeButtonText),
            onPressed: () {
              Navigator.of(context).pop(responseCodeNegative);
            },
          ),
        if (_positiveButtonText != null)
          TextButton(
            child: Text(_positiveButtonText),
            onPressed: () {
              Navigator.of(context).pop(responseCodePositive);
            },
          ),
      ],
    );
  }
}
