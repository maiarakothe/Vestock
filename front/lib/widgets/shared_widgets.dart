// lib/widgets/shared_widgets.dart
import 'package:awidgets/fields/a_field.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:flutter/material.dart';
import '../../app_theme.dart';

class VestockScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? fab;
  final List<Widget>? actions;

  const VestockScaffold({
    super.key,
    required this.title,
    required this.body,
    this.fab,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: body,
      floatingActionButton: fab,
    );
  }
}

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
    builder: (ctx) => AlertDialog(
      title: const Text('Confirmação'),
      content: Text(message),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar')),
        ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirmar')),
      ],
    ),
  );
}

void showError(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), backgroundColor: Colors.red),
  );
}

void showSuccess(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), backgroundColor: DefaultColors.accent),
  );
}

class FormField2 extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool required;
  final bool readOnly;
  final int maxLines;

  const FormField2({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.required = false,
    this.readOnly = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label),
      validator: required
          ? (v) => (v == null || v.isEmpty) ? 'Campo obrigatório' : null
          : null,
    );
  }
}

Widget buildAddressSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Divider(height: 32),
      const Text('Endereço',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 12),
      Row(children: [
       AFieldText(label: 'Rua', identifier: 'street', required: true, expanded: true,),
        const SizedBox(width: 12),
        AFieldText(label: 'Bairro', identifier: 'neighborhood', required: true, expanded: true,),
      ]),
      const SizedBox(height: 12),
      Row(children: [
       AFieldText(label: 'Cidade', identifier: 'city', required: true, expanded: true,),
        const SizedBox(width: 12),
        AFieldText(label: 'Estado', identifier: 'state', required: true, expanded: true, ),
      ]),
    ],
  );
}