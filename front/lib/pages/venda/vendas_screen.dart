import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import 'package:front/models/item_venda.dart';
import 'package:front/pages/venda/venda_card.dart';
import 'package:front/pages/venda/venda_form.dart';
import 'package:front/widgets/shared_widgets.dart';
import 'package:front/widgets/modern_fab.dart';
import '../../../services/api_service.dart';
import '../../app_theme.dart';
import '../../models/venda.dart';

class VendasScreen extends StatefulWidget {
  const VendasScreen({super.key});

  @override
  State<VendasScreen> createState() => _VendasScreenState();
}

class _VendasScreenState extends State<VendasScreen> {
  List<Venda> _vendas = <Venda>[];
  bool _loading = true;
  final String _query = '';
  String _filtroPagamento = 'Todos';
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final dynamic data = await ApiService.get('/api/vendas');
      setState(() {
        _vendas = (data as List<dynamic>)
            .map((dynamic j) => Venda.fromJson(j))
            .toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        showError(context, e.toString());
      }
    }
  }

  void _openForm([Venda? v]) async {
    final bool? saved = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => VendaForm(),
    );
    if (saved == true) {
      await _load();
    }
  }

  String _fmtData(String? s) {
    if (s == null) {
      return '';
    }
    try {
      final DateTime dt = DateTime.parse(s);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} '
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return s;
    }
  }

  List<Venda> get _vendasFiltradas {
    final String q = _query.trim().toLowerCase();
    return _vendas.where((Venda v) {
      final bool matchQuery =
          q.isEmpty ||
          v.clienteNome.toLowerCase().contains(q) ||
          v.funcionarioNome.toLowerCase().contains(q) ||
          v.itens.any(
            (ItemVenda it) => (it.nomeProduto ?? '').toLowerCase().contains(q),
          );
      final bool matchPag =
          _filtroPagamento == 'Todos' || v.formaPagamento == _filtroPagamento;
      return matchQuery && matchPag;
    }).toList();
  }

  double get _totalFiltrado =>
      _vendasFiltradas.fold<double>(0, (double s, Venda v) => s + v.totalVenda);

  List<String> get _formasPagamento {
    final Set<String> s = <String>{'Todos'};
    for (final Venda v in _vendas) {
      s.add(v.formaPagamento);
    }
    return s.toList();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final bool isMobile = MediaQuery.of(context).size.width < kMobileBreakpoint;
    final int crossAxisCount = !isMobile ? 3 : 1;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: _loading
            ? const LoadingWidget()
            : RefreshIndicator(
                onRefresh: _load,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(child: _buildHeader(cs)),
                    SliverToBoxAdapter(child: _buildToolbar(cs)),
                    if (_vendasFiltradas.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: EmptyWidget(message: 'Nenhuma venda encontrada'),
                      )
                    else
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          !isMobile ? 24 : 12,
                          8,
                          !isMobile ? 24 : 12,
                          100,
                        ),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                mainAxisExtent: 172,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext ctx, int i) =>
                                _buildVendaCard(_vendasFiltradas[i], cs),
                            childCount: _vendasFiltradas.length,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
      floatingActionButton: ModernFloatingActionButton(
        icon: Icons.add,
        label: 'Nova Venda',
        onPressed: _openForm,
      ),
    );
  }

  Widget _buildHeader(ColorScheme cs) {
    final double w = MediaQuery.of(context).size.width;
    final bool isMobile = w < 850;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            DefaultColors.primary,
            DefaultColors.primary.withOpacity(0.75),
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: DefaultColors.primary.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.point_of_sale_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Vendas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_vendasFiltradas.length} registro(s)',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isMobile) ...<Widget>[
                const SizedBox(width: 24),
                _buildTotalDisplay(),
              ],
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (isMobile) ...<Widget>[
                const SizedBox(width: 16),
                _buildTotalDisplay(),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          'Total',
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          'R\$ ${_totalFiltrado.toStringAsFixed(2)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildToolbar(ColorScheme cs) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: LayoutBuilder(
        builder: (BuildContext ctx, BoxConstraints c) {
          final bool wide = c.maxWidth > 560;
          final Widget filtro = SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _formasPagamento.map((String f) {
                final bool sel = _filtroPagamento == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(f),
                    selected: sel,
                    selectedColor: DefaultColors.secondary,
                    onSelected: (_) => setState(() => _filtroPagamento = f),
                  ),
                );
              }).toList(),
            ),
          );
          if (wide) {
            return Row(children: <Widget>[Flexible(child: filtro)]);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[filtro],
          );
        },
      ),
    );
  }

  Widget _buildVendaCard(Venda v, ColorScheme cs) {
    return VendaCard(venda: v, onTap: () => _showDetalhes(v));
  }

  void _showDetalhes(Venda v) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (BuildContext ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          expand: false,
          builder: (BuildContext c, ScrollController sc) {
            return SingleChildScrollView(
              controller: sc,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: cs.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    v.clienteNome,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _fmtData(v.dataVenda),
                    style: TextStyle(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),
                  _infoRow(
                    Icons.payments_outlined,
                    'Pagamento',
                    v.formaPagamento,
                  ),
                  _infoRow(
                    Icons.badge_outlined,
                    'Funcionário',
                    v.funcionarioNome,
                  ),
                  if (v.descontoNome != null)
                    _infoRow(
                      Icons.local_offer_outlined,
                      'Desconto',
                      '${v.descontoNome} (–R\$ ${v.valorCupomDesconto.toStringAsFixed(2)})',
                    ),
                  const SizedBox(height: 12),
                  const Text(
                    'Itens',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  ...v.itens.map(
                    (ItemVenda it) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: cs.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${it.quantidade}x',
                              style: TextStyle(
                                color: cs.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(it.nomeProduto ?? '')),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'R\$ ${v.totalVenda.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: DefaultColors.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
