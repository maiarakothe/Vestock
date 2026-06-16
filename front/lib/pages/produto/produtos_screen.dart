import 'package:awidgets/fields/a_field_search.dart';
import 'package:flutter/material.dart';
import 'package:front/pages/produto/produto_form.dart';
import 'package:front/widgets/shared_widgets.dart';
import 'package:front/widgets/app_table.dart';
import '../../../services/api_service.dart';
import '../../app_theme.dart';
import '../../models/produto.dart';
import '../../widgets/modern_card.dart';

class ProdutosScreen extends StatefulWidget {
  const ProdutosScreen({super.key});

  @override
  State<ProdutosScreen> createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  List<Produto> _produtos = <Produto>[];
  bool _loading = true;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load([String termo = '']) async {
    setState(() => _loading = true);
    try {
      final String path = termo.isNotEmpty
          ? '/api/produtos/search?q=${Uri.encodeComponent(termo)}'
          : '/api/produtos';
      final dynamic data = await ApiService.get(path);
      setState(() {
        _produtos = (data as List<dynamic>)
            .map((dynamic j) => Produto.fromJson(j))
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

  void _openForm([Produto? p]) async {
    final bool? saved = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => ProdutoForm(produto: p),
    );
    if (saved == true) {
      await _load(_search);
    }
  }

  Future<void> _delete(Produto p) async {
    final bool? ok = await confirmDialog(context, 'Excluir ${p.nome}?');
    if (ok != true) {
      return;
    }
    try {
      await ApiService.delete('/api/produtos/${p.id}');
      await _load(_search);
    } catch (e) {
      if (mounted) {
        showError(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12),
            child: AFieldSearch(
              label: 'Pesquisar produto',
              onChanged: (String? v) {
                setState(() => _search = v!);
                _load(v!);
              },
            ),
          ),
          Expanded(
            child: _loading
                ? const LoadingWidget()
                : _produtos.isEmpty
                ? const EmptyWidget(message: 'Nenhum produto encontrado')
                : RefreshIndicator(
                    onRefresh: () => _load(_search),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: AppTable<Produto>(
                        columns: const <String>[
                          'Nome',
                          'Tipo',
                          'Estoque',
                          'Preço',
                          'Ações',
                        ],
                        items: _produtos,
                        onTap: _openForm,
                        rowBuilder: (Produto p) => <DataCell>[
                          DataCell(
                            Text(
                              p.nome,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          DataCell(Text(p.tipo ?? '-')),
                          DataCell(
                            Text(
                              '${p.quantidadeEstoque}',
                              style: TextStyle(
                                color: p.quantidadeEstoque <= 5
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataCell(Text('R\$ ${p.venda.toStringAsFixed(2)}')),
                          DataCell(
                            Row(
                              children: <Widget>[
                                buildActionButton(
                                  icon: Icons.edit_outlined,
                                  color: DefaultColors.accent,
                                  onTap: () => _openForm(p),
                                ),
                                const SizedBox(width: 8),
                                buildActionButton(
                                  icon: Icons.delete_outline,
                                  color: DefaultColors.error,
                                  onTap: () => _delete(p),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openForm,
        icon: const Icon(Icons.add),
        label: const Text('Novo Produto'),
      ),
    );
  }
}
