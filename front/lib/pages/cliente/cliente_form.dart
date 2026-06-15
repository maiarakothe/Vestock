import 'package:awidgets/fields/a_drop_option.dart';
import 'package:awidgets/fields/a_field_cpf.dart';
import 'package:awidgets/fields/a_field_drop_down.dart';
import 'package:awidgets/fields/a_field_email.dart';
import 'package:awidgets/fields/a_field_name.dart';
import 'package:awidgets/fields/a_field_phone.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/general/a_form_dialog.dart';
import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../models/cliente.dart';
import '../../services/api_service.dart';

class ClienteForm extends StatelessWidget {
  final Cliente? cliente;
  const ClienteForm({super.key, this.cliente});

  Future<String?> _save(dynamic data) async {
    try {
      final Map<String, dynamic> body = Cliente(
        lojaId: ApiService.lojaId,
        nome: data['nome'],
        cpf: data['cpf'],
        telefone: data['telefone'],
        email: data['email'],
        sexo: data['sexo'] ?? 'M',
        dataCadastro: cliente?.dataCadastro ?? DateTime.now().toIso8601String(),
        rua: data['rua'] ?? '',
        bairro: data['bairro'] ?? '',
        cidade: data['cidade'] ?? '',
        estado: data['estado'] ?? '',
      ).toJson();

      if (cliente?.id != null) {
        await ApiService.put('/api/clientes/${cliente!.id}', body);
      } else {
        await ApiService.post('/api/clientes', body);
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AFormDialog<dynamic>(
      title: cliente == null ? 'Novo Cliente' : 'Editar Cliente',
      persistent: false,
      width: 500,
      fields: <Widget>[
        Row(
          children: <Widget>[
            AFieldName(
              label: 'Nome',
              identifier: 'nome',
              value: cliente?.nome,
              required: true,
              expanded: true,
            ),
            const SizedBox(width: 10),
            AFieldCPF(
              label: 'CPF',
              identifier: 'cpf',
              value: cliente?.cpf,
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
              value: cliente?.telefone,
              required: true,
              expanded: true,
            ),
            const SizedBox(width: 10),
            AFieldEmail(
              label: 'Email',
              identifier: 'email',
              value: cliente?.email,
              required: true,
              expanded: true,
            ),
          ],
        ),
        AFieldDropDown<String>(
          value: cliente?.sexo.isEmpty == false ? cliente!.sexo : 'M',
          label: 'Sexo',
          identifier: 'sexo',
          options: <AOption<String>>[
            AOption<String>(value: 'M', label: 'Masculino'),
            AOption<String>(value: 'F', label: 'Feminino'),
          ],
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
              value: cliente?.rua,
              expanded: true,
            ),
            SizedBox(width: 10),
            AFieldText(
              label: 'Bairro',
              identifier: 'bairro',
              value: cliente?.bairro,
              expanded: true,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            AFieldText(
              label: 'Cidade',
              identifier: 'cidade',
              value: cliente?.cidade,
              expanded: true,
            ),
            const SizedBox(width: 10),
            AFieldText(
              label: 'Estado',
              identifier: 'estado',
              value: cliente?.estado,
              expanded: true,
            ),
          ],
        ),
      ],
      onSubmit: _save,
    );
  }
}
