import 'package:awidgets/fields/a_field_search.dart';
import 'package:flutter/material.dart';
import 'package:front/pages/produto/produto_form.dart';
import 'package:front/widgets/shred_widgets.dart';
import '../../../services/api_service.dart';
import '../../models/produto.dart';

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
      backgroundColor: const Color(0xFFF8F9FE),
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
                    child: ListView.builder(
                      itemCount: _produtos.length,
                      itemBuilder: (BuildContext ctx, int i) {
                        final Produto p = _produtos[i];
                        final MaterialColor estoqueColor =
                            p.quantidadeEstoque <= 5
                            ? Colors.red
                            : p.quantidadeEstoque <= 15
                            ? Colors.orange
                            : Colors.green;
                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: Colors.grey.withOpacity(0.1),
                            ),
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFFEDE7FF),
                              child: Text(
                                p.nome[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF6744CF),
                                ),
                              ),
                            ),
                            title: Text(
                              p.nome,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${p.tipo ?? ''} • ${p.tamanho ?? ''} • ${p.cor ?? ''}\n'
                              'Venda: R\$ ${p.venda.toStringAsFixed(2)}',
                            ),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '${p.quantidadeEstoque}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: estoqueColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'estoque',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => _openForm(p),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _delete(p),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
