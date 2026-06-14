import 'package:flutter/material.dart';
import 'package:front/widgets/shred_widgets.dart';
import '../../../services/api_service.dart';
import '../../models/fornecedor.dart';
import 'fornecedor_form.dart';

class FornecedoresScreen extends StatefulWidget {
  const FornecedoresScreen({super.key});

  @override
  State<FornecedoresScreen> createState() => _FornecedoresScreenState();
}

class _FornecedoresScreenState extends State<FornecedoresScreen> {
  List<Fornecedor> _items = <Fornecedor>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final dynamic data = await ApiService.get('/api/fornecedores');
      setState(() {
        _items = (data as List).map((j) => Fornecedor.fromJson(j)).toList();
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
      await _load();
    }
  }

  Future<void> _delete(Fornecedor f) async {
    final bool? ok = await confirmDialog(context, 'Excluir ${f.nome}?');
    if (ok != true) {
      return;
    }
    try {
      await ApiService.delete('/api/fornecedores/${f.id}');
      await _load();
    } catch (e) {
      if (mounted) {
        showError(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const LoadingWidget()
          : _items.isEmpty
          ? const EmptyWidget(message: 'Nenhum fornecedor')
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _items.length,
                itemBuilder: (BuildContext ctx, int i) {
                  final Fornecedor f = _items[i];
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.local_shipping),
                      ),
                      title: Text(
                        f.nome,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${f.cnpj}\n${f.email} • ${f.telefone}\n${f.cidade ?? ''}',
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Colors.blue,
                            ),
                            onPressed: () => _openForm(f),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () => _delete(f),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openForm,
        icon: const Icon(Icons.add),
        label: const Text('Novo Fornecedor'),
      ),
    );
  }
}
