import 'package:awidgets/general/a_button.dart';
import 'package:awidgets/general/a_dialog.dart';
import 'package:flutter/material.dart';
import '../../app_theme.dart';


class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class ErrorWidget2 extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorWidget2({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  final String message;
  const EmptyWidget({super.key, required this.message});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
        const SizedBox(height: 8),
        Text(message, style: TextStyle(color: Colors.grey[600])),
      ],
    ),
  );
}

Future<bool?> confirmDialog(BuildContext context, String message) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext ctx) => ADialogV2<dynamic>(
      title: 'Confirmação',
      content: <Widget>[
        Text(message),
        SizedBox(height: 12),
        Row(
          children: [
            AButton(
              text: 'Cancelar',
              onPressed: () => Navigator.pop(ctx, false),
            ),
            AButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Confirmar'),
            ),
          ],
        ),
      ],
    ),
  );
}

void showError(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), backgroundColor: DefaultColors.error),
  );
}

void showSuccess(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), backgroundColor: DefaultColors.success),
  );
}
