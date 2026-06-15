import 'package:flutter/material.dart';
import 'package:front/models/item_venda.dart';
import 'package:front/pages/venda/venda_form.dart';
import 'package:front/widgets/shared_widgets.dart';
import '../../../services/api_service.dart';
import '../../models/venda.dart';

class VendasScreen extends StatefulWidget {
  const VendasScreen({super.key});

  @override
  State<VendasScreen> createState() => _VendasScreenState();
}

class _VendasScreenState extends State<VendasScreen> {
  List<Venda> _vendas = <Venda>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
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
                itemBuilder: (BuildContext ctx, int i) {
                  final Venda v = _vendas[i];
                  final String itensStr = v.itens
                      .map(
                        (ItemVenda it) =>
                            '${it.quantidade}x ${it.nomeProduto ?? ''}',
                      )
                      .join(', ');
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.withOpacity(0.1)),
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFE8F5E9),
                        child: const Icon(
                          Icons.receipt_long,
                          color: Colors.green,
                        ),
                      ),
                      title: Text(
                        v.clienteNome,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${_fmtData(v.dataVenda)}  •  ${v.formaPagamento}',
                      ),
                      trailing: Text(
                        'R\$ ${v.totalVenda.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 15,
                        ),
                      ),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
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
                              _infoRow(
                                Icons.shopping_bag_outlined,
                                'Produtos',
                                itensStr,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final bool? saved = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) => const VendaForm(),
          );
          if (saved == true) {
            await _load();
          }
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
        children: <Widget>[
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
