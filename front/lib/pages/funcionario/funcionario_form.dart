import 'package:awidgets/fields/a_drop_option.dart';
import 'package:awidgets/fields/a_field_date.dart';
import 'package:awidgets/fields/a_field_drop_down.dart';
import 'package:awidgets/fields/a_field_email.dart';
import 'package:awidgets/fields/a_field_phone.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/general/a_form_dialog.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../services/api_service.dart';
import '../../models/funcionario.dart';

class FuncionarioForm extends StatelessWidget {
  final Funcionario? funcionario;
  final int? lojaId;
  final bool persistent;

  const FuncionarioForm({
    super.key,
    this.funcionario,
    this.lojaId,
    this.persistent = false,
  });

  Future<String?> _save(dynamic data) async {
    try {
      final int? activeLojaId = lojaId ?? ApiService.lojaId;
      if (activeLojaId == null) {
        return 'Erro: Não foi possível identificar a loja. Tente refazer o login.';
      }

      String? dateToString(dynamic d) {
        if (d is DateTime) {
          return d.toIso8601String().substring(0, 10);
        }
        return d?.toString();
      }

      final Map<String, dynamic> body = Funcionario(
        nome: data['nome'],
        cpf: data['cpf'],
        cargo: data['cargo'],
        telefone: data['telefone'] ?? '',
        email: data['email'] ?? '',
        sexo: data['sexo'] ?? 'M',
        dataAdmissao: dateToString(data['dataAdmissao']),
        rua: data['rua'] ?? '',
        bairro: data['bairro'] ?? '',
        cidade: data['cidade'] ?? '',
        estado: data['estado'] ?? '',
        lojaId: activeLojaId,
      ).toJson();

      if (funcionario?.id != null) {
        await ApiService.put('/api/funcionarios/${funcionario!.id}', body);
      } else {
        await ApiService.post('/api/funcionarios', body);
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AFormDialog<dynamic>(
      title: funcionario == null ? 'Novo Funcionário' : 'Editar Funcionário',
      width: 500,
      fullscreen: MediaQuery.of(context).size.width < kMobileBreakpoint,
      fields: <Widget>[
        AFieldText(
          label: 'Nome',
          identifier: 'nome',
          value: funcionario?.nome,
          required: true,
        ),
        AFieldText(
          label: 'CPF',
          identifier: 'cpf',
          value: funcionario?.cpf,
          required: true,
        ),
        AFieldText(
          label: 'Cargo',
          identifier: 'cargo',
          value: funcionario?.cargo,
          required: true,
        ),
        AFieldPhone(
          label: 'Telefone',
          identifier: 'telefone',
          value: funcionario?.telefone,
        ),
        AFieldEmail(
          label: 'Email',
          identifier: 'email',
          value: funcionario?.email,
          required: true,
        ),
        AFieldDropDown<String>(
          label: 'Sexo',
          identifier: 'sexo',
          value: funcionario?.sexo ?? 'M',
          options: const <AOption<String>>[
            AOption<String>(value: 'M', label: 'Masculino'),
            AOption<String>(value: 'F', label: 'Feminino'),
          ],
        ),
        AFieldDate(
          label: 'Admissão',
          identifier: 'dataAdmissao',
          value:
              DateTime.tryParse(funcionario?.dataAdmissao ?? '') ??
              DateTime.now(),
          required: true,
        ),
        AFieldText(label: 'Rua', identifier: 'rua', value: funcionario?.rua),
        AFieldText(
          label: 'Bairro',
          identifier: 'bairro',
          value: funcionario?.bairro,
        ),
        AFieldText(
          label: 'Cidade',
          identifier: 'cidade',
          value: funcionario?.cidade,
        ),
        AFieldText(
          label: 'Estado',
          identifier: 'estado',
          value: funcionario?.estado,
        ),
      ],
      onSubmit: _save,
      persistent: persistent,
    );
  }
}
