import 'package:awidgets/fields/a_field_cnpj.dart';
import 'package:awidgets/fields/a_field_phone.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/general/a_form_dialog.dart';
import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../models/loja.dart';
import '../../services/api_service.dart';

class LojaForm extends StatelessWidget {
  final Loja? loja;
  const LojaForm({super.key, this.loja});

  Future<String?> _save(dynamic data) async {
    try {
      final Map<String, dynamic> body = Loja(
        nome: data['nome'],
        cnpj: data['cnpj'],
        telefone: data['telefone'],
        rua: data['rua'],
        bairro: data['bairro'],
        cidade: data['cidade'],
        email: loja?.email ?? '',
        senha: '',
      ).toJson();

      if (loja?.id != null) {
        await ApiService.put('/api/lojas/${loja!.id}', body);
      } else {
        await ApiService.post('/api/lojas', body);
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AFormDialog<dynamic>(
      title: 'Editar Loja',
      width: 500,
      persistent: false,
      fields: <Widget>[
        AFieldText(
          label: 'Nome',
          identifier: 'nome',
          value: loja?.nome,
          required: true,
        ),
        AFieldCNPJ(
          label: 'CNPJ',
          identifier: 'cnpj',
          value: loja?.cnpj,
          required: true,
        ),
        AFieldPhone(
          label: 'Telefone',
          identifier: 'telefone',
          value: loja?.telefone,
          required: true,
        ),
        const SizedBox(height: 8),
        const Text(
          'Endereço',
          style: TextStyle(fontWeight: FontWeight.bold, color: kPrimary),
        ),
        const Divider(),
        AFieldText(
          label: 'Rua',
          identifier: 'rua',
          value: loja?.rua,
          required: true,
        ),
        Row(
          children: <Widget>[
            AFieldText(
              label: 'Bairro',
              identifier: 'bairro',
              value: loja?.bairro,
              required: true,
              expanded: true,
            ),
            const SizedBox(width: 12),
            AFieldText(
              label: 'Cidade',
              identifier: 'cidade',
              value: loja?.cidade,
              required: true,
              expanded: true,
            ),
          ],
        ),
      ],
      onSubmit: _save,
    );
  }
}
