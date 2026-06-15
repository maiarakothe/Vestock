import 'package:awidgets/fields/a_drop_option.dart';
import 'package:awidgets/fields/a_field_date_hour.dart';
import 'package:awidgets/fields/a_field_drop_down.dart';
import 'package:awidgets/fields/a_field_drop_down_with_counts.dart';
import 'package:awidgets/fields/a_field_number.dart';
import 'package:awidgets/general/a_button.dart';
import 'package:awidgets/general/a_form_dialog.dart';
import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../models/cliente.dart';
import '../../models/desconto.dart';
import '../../models/funcionario.dart';
import '../../models/produto.dart';
import '../../services/api_service.dart';
import '../../widgets/shared_widgets.dart';

class VendaForm extends StatefulWidget {
  const VendaForm({super.key});

  @override
  State<VendaForm> createState() => VendaFormState();
}

class VendaFormState extends State<VendaForm> {
  List<Cliente> _clientes = <Cliente>[];
  List<Funcionario> _funcionarios = <Funcionario>[];
  List<Produto> _produtos = <Produto>[];
  List<Desconto> _descontos = <Desconto>[];
  int? _descontoId;

  final List<ItemVendaTemp> _itens = <ItemVendaTemp>[];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDados();
  }

  Future<void> _loadDados() async {
    try {
      final List<dynamic> results = await Future.wait(<Future<dynamic>>[
        ApiService.get('/api/clientes'),
        ApiService.get('/api/funcionarios'),
        ApiService.get('/api/produtos'),
        ApiService.get('/api/descontos'),
      ]);
      setState(() {
        _clientes = (results[0] as List<dynamic>)
            .map((dynamic j) => Cliente.fromJson(j as Map<String, dynamic>))
            .toList();
        _funcionarios = (results[1] as List<dynamic>)
            .map((dynamic j) => Funcionario.fromJson(j as Map<String, dynamic>))
            .toList();
        _produtos = (results[2] as List<dynamic>)
            .map((dynamic j) => Produto.fromJson(j as Map<String, dynamic>))
            .where((Produto p) => p.quantidadeEstoque > 0)
            .toList();
        _descontos = (results[3] as List<dynamic>)
            .map((dynamic j) => Desconto.fromJson(j as Map<String, dynamic>))
            .toList();
        _loading = false;
        if (_itens.isEmpty) {
          _itens.add(ItemVendaTemp());
        }
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        showError(context, e.toString());
      }
    }
  }

  double get _subtotal =>
      _itens.fold(0, (double acc, ItemVendaTemp it) => acc + it.subtotal);

  // Calculamos o desconto baseado no ID que vem do form via identificador
  double _getValorDesconto(int? descontoId) {
    if (descontoId == null) {
      return 0;
    }
    if (_descontos.isEmpty) {
      return 0;
    }
    final Desconto d = _descontos.firstWhere(
      (Desconto element) => element.id == descontoId,
      orElse: () => Desconto(nome: '', valor: 0),
    );
    return _subtotal * (d.valor / 100);
  }

  Future<String?> _submit(dynamic data) async {
    if (data['cliente'] == null || data['funcionario'] == null) {
      return 'Selecione cliente e funcionário';
    }
    final List<ItemVendaTemp> itensValidos = _itens
        .where((ItemVendaTemp it) => it.produtoId != null && it.quantidade > 0)
        .toList();
    if (itensValidos.isEmpty) {
      return 'Adicione pelo menos um produto';
    }

    try {
      String? dateToString(dynamic d) {
        if (d is DateTime) {
          return d.toIso8601String().substring(0, 19);
        }
        return d?.toString();
      }

      final double valorDesc = _getValorDesconto(data['desconto']);
      final double vTotal = _subtotal - valorDesc;

      final Map<String, dynamic> body = <String, dynamic>{
        'cliente': <String, dynamic>{'id': data['cliente']},
        'funcionario': <String, dynamic>{'id': data['funcionario']},
        'dataVenda': dateToString(data['dataVenda']),
        'formaPagamento': data['formaPagamento'],
        if (data['desconto'] != null)
          'desconto': <String, dynamic>{'id': data['desconto']},
        'totalVenda': vTotal,
        'itens': itensValidos
            .map(
              (ItemVendaTemp it) => <String, Object>{
                'produto': <String, int?>{'id': it.produtoId},
                'quantidadeItem': it.quantidade,
                'valorUnitario': it.valorUnitario,
                'valorTotal': it.subtotal,
              },
            )
            .toList(),
        'loja': {'id': ApiService.lojaId},
      };

      await ApiService.post('/api/vendas', body);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final double valorDesconto = _getValorDesconto(_descontoId);
    final double valorTotal = _subtotal - valorDesconto;

    return AFormDialog<dynamic>(
      title: 'Nova Venda',
      width: 700,
      persistent: false,
      fields: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: AFieldDropDown<int?>(
                label: 'Cliente',
                identifier: 'cliente',
                searchable: true,
                required: true,
                options: _clientes
                    .map(
                      (Cliente c) => AOption<int?>(value: c.id, label: c.nome),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AFieldDropDown<int?>(
                label: 'Funcionário',
                identifier: 'funcionario',
                searchable: true,
                required: true,
                options: _funcionarios
                    .map(
                      (Funcionario f) =>
                          AOption<int?>(value: f.id, label: f.nome),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: AFieldDropDown<String>(
                label: 'Pagamento',
                identifier: 'formaPagamento',
                value: 'Dinheiro',
                options: const <AOption<String>>[
                  AOption<String>(value: 'Dinheiro', label: 'Dinheiro'),
                  AOption<String>(value: 'Crédito', label: 'Crédito'),
                  AOption<String>(value: 'Débito', label: 'Débito'),
                  AOption<String>(value: 'Pix', label: 'Pix'),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AFieldDateHour(
                label: 'Data da Venda',
                identifier: 'dataVenda',
                value: DateTime.now(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AFieldDropDown<int?>(
          label: 'Cupom de Desconto',
          identifier: 'desconto',
          value: _descontoId,
          options: <AOption<int?>>[
            const AOption<int?>(value: null, label: 'Sem cupom'),
            ..._descontos.map<AOption<int?>>(
              (Desconto d) => AOption<int?>(
                value: d.id,
                label: '${d.nome} (${d.valor.toInt()}% off)',
              ),
            ),
          ],
          onChanged: (int? v) => setState(() => _descontoId = v),
        ),
        const Divider(height: 32),
        const Text(
          'Itens da Venda',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ..._itens.asMap().entries.map((MapEntry<int, ItemVendaTemp> entry) {
          return ItemRow(
            key: ValueKey<int>(entry.key),
            item: entry.value,
            produtos: _produtos,
            onRemove: () => setState(() => _itens.removeAt(entry.key)),
            onChanged: () => setState(() {}),
          );
        }),
        const SizedBox(height: 8),
        AButton(
          onPressed: () => setState(() => _itens.add(ItemVendaTemp())),
          text: 'Adicionar Item',
          icon: Icons.add_shopping_cart,
        ),
        const Divider(height: 32),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: <Widget>[
              _totalRow('Subtotal', 'R\$ ${_subtotal.toStringAsFixed(2)}'),
              if (valorDesconto > 0)
                _totalRow(
                  'Desconto',
                  '- R\$ ${valorDesconto.toStringAsFixed(2)}',
                  color: Colors.red,
                ),
              const Divider(),
              _totalRow(
                'Total',
                'R\$ ${valorTotal.toStringAsFixed(2)}',
                bold: true,
                color: DefaultColors.primary,
              ),
            ],
          ),
        ),
      ],
      onSubmit: _submit,
    );
  }

  Widget _totalRow(
    String label,
    String value, {
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: color,
              fontSize: bold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

class ItemVendaTemp {
  int? produtoId;
  int quantidade;
  double valorUnitario;

  ItemVendaTemp({this.produtoId, this.quantidade = 1, this.valorUnitario = 0});

  double get subtotal => quantidade * valorUnitario;
}

class ItemRow extends StatefulWidget {
  final ItemVendaTemp item;
  final List<Produto> produtos;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  const ItemRow({
    super.key,
    required this.item,
    required this.produtos,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  State<ItemRow> createState() => ItemRowState();
}

class ItemRowState extends State<ItemRow> {
  late final TextEditingController _qtdCtrl;

  @override
  void initState() {
    super.initState();
    _qtdCtrl = TextEditingController(text: widget.item.quantidade.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[50],
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            // Produce select
            Expanded(
              flex: 5,
              child: AFieldDropDownWithCounts<int?>(
                label: 'Produto',
                identifier: 'produto',
                required: true,
                getCount: (int? v) {
                  if (v == null) {
                    return 0;
                  }
                  final Produto prod = widget.produtos.firstWhere(
                    (Produto p) => p.id == v,
                  );
                  return prod.quantidadeEstoque;
                },
                value: widget.item.produtoId,
                options: widget.produtos
                    .map(
                      (Produto p) => AOption<int?>(
                        value: p.id,
                        label:
                            '${p.nome} (${p.tamanho ?? ''}) – R\$${p.venda.toStringAsFixed(2)}',
                      ),
                    )
                    .toList(),
                onChanged: (int? v) {
                  setState(() {
                    widget.item.produtoId = v;
                    final Produto prod = widget.produtos.firstWhere(
                      (Produto p) => p.id == v,
                    );
                    widget.item.valorUnitario = prod.venda;
                  });
                  widget.onChanged();
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: AFieldNumber(
                label: 'Quantidade',
                identifier: 'quantidade',
                required: true,
                onChanged: (String? v) {
                  final int qtd = int.tryParse(v!) ?? 1;
                  // Validar estoque
                  if (widget.item.produtoId != null) {
                    final Produto prod = widget.produtos.firstWhere(
                      (Produto p) => p.id == widget.item.produtoId,
                    );
                    if (qtd > prod.quantidadeEstoque) {
                      _qtdCtrl.text = prod.quantidadeEstoque.toString();
                      widget.item.quantidade = prod.quantidadeEstoque;
                      showError(
                        context,
                        'Estoque disponível: ${prod.quantidadeEstoque}',
                      );
                    } else {
                      widget.item.quantidade = qtd;
                    }
                  } else {
                    widget.item.quantidade = qtd;
                  }
                  widget.onChanged();
                },
              ),
            ),
            const SizedBox(width: 8),
            // Subtotal
            Expanded(
              flex: 3,
              child: Text(
                'R\$ ${widget.item.subtotal.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red, size: 18),
              onPressed: widget.onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
