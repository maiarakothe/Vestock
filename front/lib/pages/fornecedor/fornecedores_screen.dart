import 'package:flutter/material.dart';
import 'package:front/widgets/shared_widgets.dart';
import '../../../services/api_service.dart';
import '../../app_theme.dart';
import '../../models/fornecedor.dart';
import '../../widgets/modern_card.dart';
import '../../widgets/modern_fab.dart';
import 'fornecedor_form.dart';

class FornecedoresScreen extends StatefulWidget {
  const FornecedoresScreen({super.key});

  @override
  State<FornecedoresScreen> createState() => _FornecedoresScreenState();
}

class _FornecedoresScreenState extends State<FornecedoresScreen> {
  List<Fornecedor> _items = <Fornecedor>[];
  bool _loading = true;
  final String _search = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load([String termo = '']) async {
    setState(() => _loading = true);
    try {
      final String path = termo.isNotEmpty
          ? '/api/fornecedores?search=${Uri.encodeComponent(termo)}'
          : '/api/fornecedores';
      final dynamic data = await ApiService.get(path);
      setState(() {
        _items = (data as List)
            .map((dynamic j) => Fornecedor.fromJson(j))
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

  void _openForm([Fornecedor? f]) async {
    final bool? saved = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => FornecedorForm(fornecedor: f),
    );
    if (saved == true) {
      await _load(_search);
    }
  }

  Future<void> _delete(Fornecedor f) async {
    final bool? ok = await confirmDialog(context, 'Excluir ${f.nome}?');
    if (ok != true) {
      return;
    }
    try {
      await ApiService.delete('/api/fornecedores/${f.id}');
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Expanded(
              child: _loading
                  ? const LoadingWidget()
                  : _items.isEmpty
                  ? const EmptyWidget(message: 'Nenhum fornecedor encontrado')
                  : RefreshIndicator(
                      onRefresh: () => _load(_search),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ).copyWith(bottom: 100),
                        itemCount: _items.length,
                        itemBuilder: (BuildContext ctx, int i) {
                          final Fornecedor f = _items[i];
                          return ModernCard(
                            leading: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    DefaultColors.secondary,
                                    DefaultColors.primary,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: DefaultColors.secondary.withOpacity(
                                      .30,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.local_shipping_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            title: f.nome,
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.badge_outlined,
                                      size: 14,
                                      color: Colors.grey[500],
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        f.cnpj,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.email_outlined,
                                      size: 14,
                                      color: Colors.grey[500],
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        f.email,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 14,
                                      color: Colors.grey[500],
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        f.cidade ?? '-',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              buildActionButton(
                                icon: Icons.edit_outlined,
                                color: DefaultColors.accent,
                                onTap: () => _openForm(f),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: ModernFloatingActionButton(
        icon: Icons.add,
        label: 'Novo Fornecedor',
        onPressed: _openForm,
      ),
    );
  }
}
