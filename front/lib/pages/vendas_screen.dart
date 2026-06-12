// lib/screens/vendas_screen.dart
import 'package:flutter/material.dart';
import 'package:front/widgets/shred_widgets.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';

class VendasScreen extends StatefulWidget {
  const VendasScreen({super.key});
  @override
  State<VendasScreen> createState() => _VendasScreenState();
}

class _VendasScreenState extends State<VendasScreen> {
  List<Venda> _vendas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.get('/api/vendas');
      setState(() {
        _vendas = (data as List).map((j) => Venda.fromJson(j)).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) showError(context, e.toString());
    }
  }

  String _fmtData(String? s) {
    if (s == null) return '';
    try {
      final dt = DateTime.parse(s);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} '
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return s;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const LoadingWidget()
          : _vendas.isEmpty
              ? const EmptyWidget(message: 'Nenhuma venda registrada')
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _vendas.length,
                    itemBuilder: (ctx, i) {
                      final v = _vendas[i];
                      final itensStr = v.itens
                          .map((it) =>
                              '${it.quantidade}x ${it.nomeProduto ?? ''}')
                          .join(', ');
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 4),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green[50],
                            child: const Icon(Icons.receipt_long,
                                color: Colors.green),
                          ),
                          title: Text(v.clienteNome,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              '${_fmtData(v.dataVenda)}  •  ${v.formaPagamento}'),
                          trailing: Text(
                            'R\$ ${v.totalVenda.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 15),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _infoRow(
                                      Icons.badge_outlined,
                                      'Funcionário',
                                      v.funcionarioNome),
                                  if (v.descontoNome != null)
                                    _infoRow(
                                        Icons.local_offer_outlined,
                                        'Desconto',
                                        '${v.descontoNome} (–R\$ ${v.valorCupomDesconto.toStringAsFixed(2)})'),
                                  _infoRow(Icons.shopping_bag_outlined,
                                      'Produtos', itensStr),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final saved = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (_) => const _VendaForm(),
          );
          if (saved == true) _load();
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova Venda'),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 6),
          Text('$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 13)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

// ─── Formulário Nova Venda ────────────────────────────────────────────────────

class _VendaForm extends StatefulWidget {
  const _VendaForm();
  @override
  State<_VendaForm> createState() => _VendaFormState();
}

class _VendaFormState extends State<_VendaForm> {
  // Dados do servidor
  List<Cliente> _clientes = [];
  List<Funcionario> _funcionarios = [];
  List<Produto> _produtos = [];
  List<Desconto> _descontos = [];

  // Seleções
  int? _clienteId, _funcionarioId, _descontoId;
  String _formaPagamento = 'Dinheiro';
  String _dataVenda =
      DateTime.now().toIso8601String().substring(0, 16);

  // Itens da venda: lista de maps com produtoId, quantidade, valorUnitario
  final List<_ItemVendaTemp> _itens = [];

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadDados();
  }

  Future<void> _loadDados() async {
    try {
      final results = await Future.wait([
        ApiService.get('/api/clientes'),
        ApiService.get('/api/funcionarios'),
        ApiService.get('/api/produtos'),
        ApiService.get('/api/descontos'),
      ]);
      setState(() {
        _clientes =
            (results[0] as List).map((j) => Cliente.fromJson(j)).toList();
        _funcionarios =
            (results[1] as List).map((j) => Funcionario.fromJson(j)).toList();
        _produtos = (results[2] as List)
            .map((j) => Produto.fromJson(j))
            .where((p) => p.quantidadeEstoque > 0)
            .toList();
        _descontos =
            (results[3] as List).map((j) => Desconto.fromJson(j)).toList();
        _loading = false;
        // Adiciona uma linha vazia inicial
        _itens.add(_ItemVendaTemp());
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) showError(context, e.toString());
    }
  }

  double get _subtotal =>
      _itens.fold(0, (acc, it) => acc + it.subtotal);

  double get _desconto {
    if (_descontoId == null) return 0;
    final d = _descontos.firstWhere((d) => d.id == _descontoId,
        orElse: () => Desconto(nome: '', valor: 0));
    return _subtotal * (d.valor / 100);
  }

  double get _total => _subtotal - _desconto;

  Future<void> _submit() async {
    if (_clienteId == null || _funcionarioId == null) {
      showError(context, 'Selecione cliente e funcionário');
      return;
    }
    final itensValidos = _itens
        .where((it) => it.produtoId != null && it.quantidade > 0)
        .toList();
    if (itensValidos.isEmpty) {
      showError(context, 'Adicione pelo menos um produto');
      return;
    }

    setState(() => _saving = true);
    try {
      final body = {
        'cliente': {'id': _clienteId},
        'funcionario': {'id': _funcionarioId},
        'dataVenda': _dataVenda,
        'formaPagamento': _formaPagamento,
        if (_descontoId != null) 'desconto': {'id': _descontoId},
        'totalVenda': _total,
        'itens': itensValidos
            .map((it) => {
                  'produto': {'id': it.produtoId},
                  'quantidadeItem': it.quantidade,
                  'valorUnitario': it.valorUnitario,
                  'valorTotal': it.subtotal,
                })
            .toList(),
      };

      await ApiService.post('/api/vendas', body);
      if (mounted) {
        showSuccess(context, 'Venda registrada com sucesso!');
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) showError(context, e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16),
      child: _loading
          ? const SizedBox(
              height: 300,
              child: Center(child: CircularProgressIndicator()))
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nova Venda',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  // Cliente
                  DropdownButtonFormField<int>(
                    value: _clienteId,
                    decoration:
                        const InputDecoration(labelText: 'Cliente'),
                    items: _clientes
                        .map((c) => DropdownMenuItem(
                            value: c.id, child: Text(c.nome)))
                        .toList(),
                    onChanged: (v) => setState(() => _clienteId = v),
                  ),
                  const SizedBox(height: 12),

                  // Funcionário
                  DropdownButtonFormField<int>(
                    value: _funcionarioId,
                    decoration:
                        const InputDecoration(labelText: 'Funcionário'),
                    items: _funcionarios
                        .map((f) => DropdownMenuItem(
                            value: f.id, child: Text(f.nome)))
                        .toList(),
                    onChanged: (v) => setState(() => _funcionarioId = v),
                  ),
                  const SizedBox(height: 12),

                  // Forma de pagamento
                  DropdownButtonFormField<String>(
                    value: _formaPagamento,
                    decoration: const InputDecoration(
                        labelText: 'Forma de Pagamento'),
                    items: ['Dinheiro', 'Crédito', 'Débito', 'Pix']
                        .map((s) =>
                            DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _formaPagamento = v!),
                  ),
                  const SizedBox(height: 12),

                  // Cupom de desconto
                  DropdownButtonFormField<int?>(
                    value: _descontoId,
                    decoration: const InputDecoration(
                        labelText: 'Cupom de Desconto'),
                    items: [
                      const DropdownMenuItem<int?>(
                          value: null, child: Text('Sem cupom')),
                      ..._descontos.map((d) => DropdownMenuItem(
                          value: d.id,
                          child: Text(
                              '${d.nome} (${d.valor.toInt()}% off)'))),
                    ],
                    onChanged: (v) =>
                        setState(() => _descontoId = v),
                  ),
                  const SizedBox(height: 16),

                  // Itens
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Itens da Venda',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      TextButton.icon(
                        onPressed: () =>
                            setState(() => _itens.add(_ItemVendaTemp())),
                        icon: const Icon(Icons.add_circle_outline,
                            size: 18),
                        label: const Text('Adicionar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Linhas de itens
                  ..._itens.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final item = entry.value;
                    return _ItemRow(
                      key: ValueKey(idx),
                      item: item,
                      produtos: _produtos,
                      onRemove: () =>
                          setState(() => _itens.removeAt(idx)),
                      onChanged: () => setState(() {}),
                    );
                  }),

                  const Divider(height: 24),

                  // Totais
                  _totalRow('Subtotal',
                      'R\$ ${_subtotal.toStringAsFixed(2)}'),
                  if (_desconto > 0)
                    _totalRow('Desconto',
                        '–R\$ ${_desconto.toStringAsFixed(2)}',
                        color: Colors.red),
                  _totalRow(
                    'Total',
                    'R\$ ${_total.toStringAsFixed(2)}',
                    bold: true,
                    color: Colors.green[700],
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _submit,
                      child: _saving
                          ? const CircularProgressIndicator(
                              color: Colors.white)
                          : const Text('Salvar Venda'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }

  Widget _totalRow(String label, String value,
      {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight:
                      bold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontWeight:
                      bold ? FontWeight.bold : FontWeight.normal,
                  color: color,
                  fontSize: bold ? 16 : 14)),
        ],
      ),
    );
  }
}

// ─── Item temporário ──────────────────────────────────────────────────────────

class _ItemVendaTemp {
  int? produtoId;
  int quantidade;
  double valorUnitario;

  _ItemVendaTemp({this.produtoId, this.quantidade = 1, this.valorUnitario = 0});

  double get subtotal => quantidade * valorUnitario;
}

// ─── Widget de linha de item ──────────────────────────────────────────────────

class _ItemRow extends StatefulWidget {
  final _ItemVendaTemp item;
  final List<Produto> produtos;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  const _ItemRow({
    super.key,
    required this.item,
    required this.produtos,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  State<_ItemRow> createState() => _ItemRowState();
}

class _ItemRowState extends State<_ItemRow> {
  late final TextEditingController _qtdCtrl;

  @override
  void initState() {
    super.initState();
    _qtdCtrl =
        TextEditingController(text: widget.item.quantidade.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[50],
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Produto select
            Expanded(
              flex: 5,
              child: DropdownButtonFormField<int>(
                value: widget.item.produtoId,
                isExpanded: true,
                decoration:
                    const InputDecoration(labelText: 'Produto', isDense: true),
                items: widget.produtos
                    .map((p) => DropdownMenuItem(
                          value: p.id,
                          child: Text(
                            '${p.nome} (${p.tamanho ?? ''}) – R\$${p.venda.toStringAsFixed(2)}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    widget.item.produtoId = v;
                    final prod = widget.produtos
                        .firstWhere((p) => p.id == v);
                    widget.item.valorUnitario = prod.venda;
                  });
                  widget.onChanged();
                },
              ),
            ),
            const SizedBox(width: 8),
            // Quantidade
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _qtdCtrl,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Qtd', isDense: true),
                onChanged: (v) {
                  final qtd = int.tryParse(v) ?? 1;
                  // Validar estoque
                  if (widget.item.produtoId != null) {
                    final prod = widget.produtos.firstWhere(
                        (p) => p.id == widget.item.produtoId);
                    if (qtd > prod.quantidadeEstoque) {
                      _qtdCtrl.text =
                          prod.quantidadeEstoque.toString();
                      widget.item.quantidade = prod.quantidadeEstoque;
                      showError(context,
                          'Estoque disponível: ${prod.quantidadeEstoque}');
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
