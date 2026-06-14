import 'package:awidgets/fields/a_drop_option.dart';
import 'package:awidgets/fields/a_field_date_hour.dart';
import 'package:awidgets/fields/a_field_drop_down.dart';
import 'package:awidgets/fields/a_field_number.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/fields/a_field_text_expandable.dart';
import 'package:awidgets/general/a_button.dart';
import 'package:awidgets/general/a_form_dialog.dart';
import 'package:flutter/material.dart';

import '../../models/cliente.dart';
import '../../models/condicional.dart';
import '../../models/item_condicional.dart';
import '../../models/produto.dart';
import '../../services/api_service.dart';
import '../../widgets/shred_widgets.dart';

class CondicionalForm extends StatefulWidget {
  final Condicional? condicional;

  const CondicionalForm({super.key, this.condicional});

  @override
  State<CondicionalForm> createState() => _CondicionalFormState();
}

class _CondicionalFormState extends State<CondicionalForm> {
  List<Cliente> _clientes = <Cliente>[];
  List<Produto> _produtos = <Produto>[];

  final List<ItemCondicional> _itens = <ItemCondicional>[];
  int? _produtoSelecionadoId;
  int _qtdSelecionada = 1;

  @override
  void initState() {
    super.initState();
    final Condicional? c = widget.condicional;

    if (c != null) {
      _itens.addAll(c.itens);
    }
    _loadDados();
  }

  Future<void> _loadDados() async {
    try {
      final List<dynamic> results = await Future.wait(<Future<dynamic>>[
        ApiService.get('/api/clientes'),
        ApiService.get('/api/produtos/com-estoque'),
      ]);
      setState(() {
        _clientes = (results[0] as List<dynamic>)
            .map((dynamic j) => Cliente.fromJson(j))
            .toList();
        _produtos = (results[1] as List<dynamic>)
            .map((dynamic j) => Produto.fromJson(j))
            .toList();
      });
    } catch (e) {
      if (mounted) {
        showError(context, e.toString());
      }
    }
  }

  void _adicionarItem() {
    if (_produtoSelecionadoId == null) {
      showError(context, 'Selecione um produto');
      return;
    }
    final Produto prod = _produtos.firstWhere(
      (Produto p) => p.id == _produtoSelecionadoId,
    );
    setState(() {
      _itens.add(
        ItemCondicional(
          produtoId: prod.id,
          nomeProduto: prod.nome,
          quantidade: _qtdSelecionada,
        ),
      );
      _produtoSelecionadoId = null;
      _qtdSelecionada = 1;
    });
  }

  Future<String?> _submit(dynamic data) async {
    if (data['cliente'] == null) {
      showError(context, 'Selecione o cliente');
      return 'Selecione o cliente';
    }
    if (_itens.isEmpty) {
      showError(context, 'Adicione pelo menos um item');
      return 'Adicione pelo menos um item';
    }

    try {
      String? dateToString(dynamic d) {
        if (d is DateTime) {
          return d.toIso8601String().substring(0, 16);
        }
        return d?.toString();
      }

      final Map<String, dynamic> body = Condicional(
        clienteId: data['cliente'],
        clienteNome: '',
        nomeItem: data['nome'],
        dataRetirada: dateToString(data['dataRetirada']),
        dataDevolucao: dateToString(data['dataDevolucao']),
        observacao: data['obs'],
        devolvido: false,
        itens: _itens,
        lojaId: ApiService.lojaId,
      ).toJson();

      if (widget.condicional?.id != null) {
        await ApiService.put(
          '/api/condicionais/${widget.condicional!.id}',
          body,
        );
      } else {
        await ApiService.post('/api/condicionais', body);
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Widget form() {
    return AFormDialog<dynamic>(
      title: widget.condicional == null
          ? 'Novo Condicional'
          : 'Editar Condicional',
      persistent: false,
      width: 600,
      fields: <Widget>[
        AFieldDropDown<int?>(
          label: 'Cliente',
          identifier: 'cliente',
          value: widget.condicional?.clienteId,
          searchable: true,
          options: _clientes
              .map((Cliente c) => AOption<int?>(value: c.id, label: c.nome))
              .toList(),
        ),
        const SizedBox(height: 12),
        AFieldText(
          label: 'Nome da Condicional',
          identifier: 'nome',
          value: widget.condicional?.nomeItem,
          required: true,
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: AFieldDateHour(
                identifier: 'dataRetirada',
                label: 'Retirada',
                value:
                    DateTime.tryParse(widget.condicional?.dataRetirada ?? '') ??
                    DateTime.now(),
                required: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AFieldDateHour(
                identifier: 'dataDevolucao',
                value: DateTime.tryParse(
                  widget.condicional?.dataDevolucao ?? '',
                ),
                label: 'Data prevista devolução',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AFieldTextExpandable(
          label: 'Observações',
          identifier: 'obs',
          value: widget.condicional?.observacao,
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        const Text(
          'Itens',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: AFieldDropDown<int?>(
                value: _produtoSelecionadoId,
                label: 'Produto',
                expanded: true,
                searchable: true,
                identifier: 'product',
                options: _produtos
                    .map(
                      (Produto p) => AOption<int?>(
                        value: p.id,
                        label: '${p.nome} (est: ${p.quantidadeEstoque})',
                      ),
                    )
                    .toList(),
                onChanged: (int? v) =>
                    setState(() => _produtoSelecionadoId = v),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 90,
              child: AFieldNumber(
                initialValue: _qtdSelecionada.toString(),
                identifier: 'qtd',
                label: 'Quantidade',
                onChanged: (String? v) =>
                    _qtdSelecionada = int.tryParse(v!) ?? 1,
              ),
            ),
            const SizedBox(width: 8),
            AButton(onPressed: _adicionarItem, text: 'Adicionar'),
          ],
        ),
        const SizedBox(height: 8),
        if (_itens.isEmpty)
          const Text(
            'Nenhum item adicionado.',
            style: TextStyle(color: Colors.grey),
          )
        else
          ..._itens.asMap().entries.map(
            (MapEntry<int, ItemCondicional> e) => Card(
              color: Colors.grey[50],
              margin: const EdgeInsets.only(bottom: 4),
              child: ListTile(
                dense: true,
                title: Text(
                  '${e.value.quantidade}x  ${e.value.nomeProduto ?? ''}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Colors.red),
                  onPressed: () => setState(() => _itens.removeAt(e.key)),
                ),
              ),
            ),
          ),
      ],
      onSubmit: _submit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return form();
  }
}
