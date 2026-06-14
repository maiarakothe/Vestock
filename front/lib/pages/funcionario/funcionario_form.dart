import 'package:awidgets/fields/a_drop_option.dart';
import 'package:awidgets/fields/a_field_drop_down.dart';
import 'package:awidgets/fields/a_field_email.dart';
import 'package:awidgets/fields/a_field_phone.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/general/a_dialog.dart';
import 'package:awidgets/general/a_form.dart';
import 'package:awidgets/general/a_form_dialog.dart';
import 'package:flutter/material.dart';
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
      final activeLojaId = lojaId ?? ApiService.lojaId;
      if (activeLojaId == null) {
        return 'Erro: Não foi possível identificar a loja. Tente refazer o login.';
      }

      final body = Funcionario(
        nome: data['nome'],
        cpf: data['cpf'],
        cargo: data['cargo'],
        telefone: data['telefone'] ?? '',
        email: data['email'] ?? '',
        sexo: data['sexo'] ?? 'M',
        dataAdmissao: data['dataAdmissao'],
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
    return AFormDialog(
      title: funcionario == null ? 'Novo Funcionário' : 'Editar Funcionário',
      width: 500,
      fields: [
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
          options: const [
            AOption(value: 'M', label: 'Masculino'),
            AOption(value: 'F', label: 'Feminino'),
          ],
        ),
        AFieldText(
          label: 'Admissão (AAAA-MM-DD)',
          identifier: 'dataAdmissao',
          value:
              funcionario?.dataAdmissao?.substring(0, 10) ??
              DateTime.now().toIso8601String().substring(0, 10),
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
