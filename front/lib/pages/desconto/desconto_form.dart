import 'package:awidgets/fields/a_field_date.dart';
import 'package:awidgets/fields/a_field_number.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/general/a_form_dialog.dart';
import 'package:flutter/cupertino.dart';

import '../../models/desconto.dart';
import '../../services/api_service.dart';

class DescontoForm extends StatelessWidget {
  final Desconto? desconto;

  const DescontoForm({super.key, this.desconto});

  Future<String?> _save(dynamic data) async {
    try {
      String? dateToString(dynamic d) {
        if (d is DateTime) {
          return d.toIso8601String().substring(0, 10);
        }
        return d?.toString();
      }

      final Map<String, dynamic> body = Desconto(
        nome: data['nome'],
        valor: double.tryParse(data['valor'].toString()) ?? 0,
        dataCadastro: dateToString(data['dataCadastro']),
        dataValidade: dateToString(data['dataValidade']),
        lojaId: ApiService.lojaId,
      ).toJson();

      if (desconto?.id != null) {
        await ApiService.put('/api/descontos/${desconto!.id}', body);
      } else {
        await ApiService.post('/api/descontos', body);
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AFormDialog<dynamic>(
      title: desconto == null ? 'Novo Desconto' : 'Editar Desconto',
      width: 450,
      persistent: false,
      fields: <Widget>[
        AFieldText(
          label: 'Nome',
          identifier: 'nome',
          value: desconto?.nome,
          required: true,
        ),
        AFieldNumber(
          label: 'Valor do Desconto (%)',
          identifier: 'valor',
          value: desconto?.valor.toString(),
          required: true,
          suffix: const Text('%'),
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            AFieldDate(
              label: 'Data de Início',
              identifier: 'dataCadastro',
              value:
                  DateTime.tryParse(desconto?.dataCadastro ?? '') ??
                  DateTime.now(),
              required: true,
              expanded: true,
            ),
            const SizedBox(width: 12),
            AFieldDate(
              label: 'Data de Validade',
              identifier: 'dataValidade',
              value: DateTime.tryParse(desconto?.dataValidade ?? ''),
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
