import 'package:awidgets/fields/a_field_cnpj.dart';
import 'package:awidgets/fields/a_field_email.dart';
import 'package:awidgets/fields/a_field_phone.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/general/a_form_dialog.dart';
import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../models/fornecedor.dart';
import '../../services/api_service.dart';

class FornecedorForm extends StatelessWidget {
  final Fornecedor? fornecedor;

  const FornecedorForm({super.key, this.fornecedor});

  Future<String?> _save(dynamic data) async {
    try {
      final Map<String, dynamic> body = Fornecedor(
        nome: data['nome'],
        cnpj: data['cnpj'],
        telefone: data['telefone'],
        email: data['email'],
        nomeFantasia: data['nomeFantasia'],
        sexo: data['sexo'] ?? 'M',
        rua: data['rua'],
        bairro: data['bairro'],
        cidade: data['cidade'],
        estado: data['estado'],
        lojaId: ApiService.lojaId,
      ).toJson();

      if (fornecedor?.id != null) {
        await ApiService.put('/api/fornecedores/${fornecedor!.id}', body);
      } else {
        await ApiService.post('/api/fornecedores', body);
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AFormDialog<dynamic>(
      title: fornecedor == null ? 'Novo Fornecedor' : 'Editar Fornecedor',
      persistent: false,
      width: 500,
      fields: <Widget>[
        Row(
          children: <Widget>[
            AFieldText(
              label: 'Nome',
              identifier: 'nome',
              value: fornecedor?.nome,
              required: true,
              expanded: true,
            ),
            const SizedBox(width: 10),
            AFieldCNPJ(
              label: 'CNPJ',
              identifier: 'cnpj',
              value: fornecedor?.cnpj,
              required: true,
              expanded: true,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            AFieldPhone(
              label: 'Telefone',
              identifier: 'telefone',
              value: fornecedor?.telefone,
              required: true,
              expanded: true,
            ),
            const SizedBox(width: 10),
            AFieldEmail(
              label: 'Email',
              identifier: 'email',
              value: fornecedor?.email,
              required: true,
              expanded: true,
            ),
          ],
        ),
        AFieldText(
          label: 'Nome Fantasia',
          identifier: 'nomeFantasia',
          value: fornecedor?.nomeFantasia,
        ),
        const SizedBox(height: 16),
        const Text(
          'Endereço',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: DefaultColors.primary,
          ),
        ),
        const Divider(),
        Row(
          children: <Widget>[
            AFieldText(
              label: 'Rua',
              identifier: 'rua',
              value: fornecedor?.rua,
              expanded: true,
            ),
            const SizedBox(width: 10),
            AFieldText(
              label: 'Bairro',
              identifier: 'bairro',
              value: fornecedor?.bairro,
              expanded: true,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            AFieldText(
              label: 'Cidade',
              identifier: 'cidade',
              value: fornecedor?.cidade,
              expanded: true,
            ),
            const SizedBox(width: 10),
            AFieldText(
              label: 'Estado',
              identifier: 'estado',
              value: fornecedor?.estado,
              expanded: true,
            ),
          ],
        ),
      ],
      onSubmit: _save,
    );
  }
}
