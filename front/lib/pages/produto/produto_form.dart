import 'package:awidgets/fields/a_drop_option.dart';
import 'package:awidgets/fields/a_field_date.dart';
import 'package:awidgets/fields/a_field_drop_down.dart';
import 'package:awidgets/fields/a_field_money.dart';
import 'package:awidgets/fields/a_field_number.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/fields/a_field_text_expandable.dart';
import 'package:awidgets/general/a_form_dialog.dart';
import 'package:flutter/cupertino.dart';

import '../../models/fornecedor.dart';
import '../../models/loja.dart';
import '../../models/produto.dart';
import '../../services/api_service.dart';
import '../../widgets/shared_widgets.dart';

class ProdutoForm extends StatefulWidget {
  final Produto? produto;

  const ProdutoForm({super.key, this.produto});

  @override
  State<ProdutoForm> createState() => ProdutoFormState();
}

class ProdutoFormState extends State<ProdutoForm> {
  List<Fornecedor> _fornecedores = <Fornecedor>[];
  int? _fornecedorId, _lojaId;
  bool _ativo = true;

  @override
  void initState() {
    super.initState();
    final Produto? p = widget.produto;
    _ativo = p?.ativo ?? true;
    _fornecedorId = p?.fornecedor?.id;
    _lojaId = p?.loja?.id ?? ApiService.lojaId;
    _loadSelects();
  }

  Future<void> _loadSelects() async {
    try {
      final dynamic results = await Future.wait(<Future<dynamic>>[
        ApiService.get('/api/fornecedores'),
      ]);
      setState(() {
        _fornecedores = (results[0] as List<dynamic>)
            .map((dynamic j) => Fornecedor.fromJson(j))
            .toList();
      });
    } catch (e) {
      if (mounted) {
        showError(context, e.toString());
      }
    }
  }

  double _parseCurrency(dynamic v) {
    if (v == null) {
      return 0;
    }
    if (v is num) {
      return v.toDouble();
    }
    // Remove o símbolo R$, espaços e pontos de milhar, depois troca a vírgula decimal por ponto
    String s = v.toString().replaceAll('R\$', '').replaceAll(' ', '');
    if (s.contains(',')) {
      s = s.replaceAll('.', '').replaceAll(',', '.');
    }
    return double.tryParse(s) ?? 0;
  }

  int _parseInt(dynamic v) {
    if (v == null) {
      return 0;
    }
    if (v is int) {
      return v;
    }
    return int.tryParse(v.toString().replaceAll('.', '')) ?? 0;
  }

  Future<String?> _submit(dynamic data) async {
    if (_fornecedorId == null) {
      return 'Selecione um fornecedor';
    }
    if (_lojaId == null) {
      return 'Erro: Loja não identificada. Tente logar novamente.';
    }

    try {
      String? dateToString(dynamic d) {
        if (d is DateTime) {
          return d.toIso8601String().substring(0, 19);
        }
        return d?.toString();
      }

      final Map<String, dynamic> body = Produto(
        nome: data['nome'],
        tamanho: data['tamanho'],
        cor: data['cor'],
        tipo: data['tipo'],
        custo: _parseCurrency(data['custo']),
        venda: _parseCurrency(data['venda']),
        quantidadeEstoque: _parseInt(data['quantidadeEstoque']),
        descricao: data['descricao'],
        ativo: data['ativo'] ?? true,
        dataCadastro: dateToString(data['dataCadastro']),
        lojaId: _lojaId,
        fornecedor: Fornecedor(
          id: _fornecedorId,
          nome: '',
          cnpj: '',
          telefone: '',
          email: '',
        ),
        loja: Loja(
          id: _lojaId,
          nome: '',
          cnpj: '',
          telefone: '',
          email: '',
          senha: '',
        ),
      ).toJson();

      if (widget.produto?.id != null) {
        await ApiService.put('/api/produtos/${widget.produto!.id}', body);
      } else {
        await ApiService.post('/api/produtos', body);
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Widget form() {
    return AFormDialog<dynamic>(
      title: widget.produto == null ? 'Novo Produto' : 'Editar Produto',
      persistent: false,
      width: 600,
      fields: <Widget>[
        AFieldText(
          label: 'Nome do Produto',
          identifier: 'nome',
          value: widget.produto?.nome,
          required: true,
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            AFieldText(
              label: 'Tamanho',
              identifier: 'tamanho',
              value: widget.produto?.tamanho,
              required: true,
              expanded: true,
            ),
            const SizedBox(width: 12),
            AFieldText(
              label: 'Cor',
              identifier: 'cor',
              value: widget.produto?.cor,
              required: true,
              expanded: true,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            AFieldText(
              label: 'Tipo',
              identifier: 'tipo',
              value: widget.produto?.tipo,
              required: true,
              expanded: true,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            AFieldMoney(
              label: 'Preço de Custo',
              identifier: 'custo',
              value: widget.produto?.custo.toString(),
              required: true,
              expanded: true,
            ),
            const SizedBox(width: 12),
            AFieldMoney(
              label: 'Preço de Venda',
              identifier: 'venda',
              value: widget.produto?.venda.toString(),
              required: true,
              expanded: true,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            AFieldNumber(
              label: 'Estoque',
              identifier: 'quantidadeEstoque',
              value: widget.produto?.quantidadeEstoque.toString() ?? '0',
              required: true,
              expanded: true,
            ),
            const SizedBox(width: 12),
            AFieldDate(
              label: 'Data Cadastro',
              identifier: 'dataCadastro',
              value:
                  DateTime.tryParse(widget.produto?.dataCadastro ?? '') ??
                  DateTime.now(),
              expanded: true,
            ),
          ],
        ),
        const SizedBox(height: 12),
        AFieldTextExpandable(
          label: 'Descrição',
          identifier: 'descricao',
          value: widget.produto?.descricao,
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        AFieldDropDown<int?>(
          value: _fornecedorId,
          label: 'Fornecedor',
          identifier: 'fornecedorId',
          searchable: true,
          options: _fornecedores
              .map((Fornecedor f) => AOption<int?>(value: f.id, label: f.nome))
              .toList(),
          onChanged: (int? v) => setState(() => _fornecedorId = v),
          required: true,
        ),
        const SizedBox(height: 12),
        AFieldDropDown<bool>(
          label: 'Status do Produto',
          identifier: 'ativo',
          value: _ativo,
          options: <AOption<bool>>[
            AOption<bool>(value: true, label: 'Ativo'),
            AOption<bool>(value: false, label: 'Inativo'),
          ],
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
