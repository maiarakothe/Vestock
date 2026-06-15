import 'package:awidgets/fields/a_field_search.dart';
import 'package:flutter/material.dart';
import 'package:front/widgets/shred_widgets.dart';
import '../../../services/api_service.dart';
import '../../models/cliente.dart';
import 'cliente_form.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});
  
  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  List<Cliente> _clientes = <Cliente>[];
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
          ? '/api/clientes?search=${Uri.encodeComponent(termo)}'
          : '/api/clientes';
      final dynamic data = await ApiService.get(path);
      setState(() {
        _clientes = (data as List<dynamic>)
            .map((dynamic j) => Cliente.fromJson(j))
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

  void _openForm([Cliente? c]) async {
    final bool? saved = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => ClienteForm(cliente: c),
    );
    if (saved == true) {
      await _load(_search);
    }
  }

  Future<void> _delete(Cliente c) async {
    final bool? ok = await confirmDialog(context, 'Excluir ${c.nome}?');
    if (ok != true) {
      return;
    }
    try {
      await ApiService.delete('/api/clientes/${c.id}');
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

      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12),
            child: AFieldSearch(
              label: 'Pesquisar clientes...',
              value: _search,
              onChanged: (String? p1) {
                setState(() => _search = p1 ?? '');
                _load(_search);
              },
            ),
          ),
          Expanded(
            child: _loading
                ? const LoadingWidget()
                : _clientes.isEmpty
                ? const EmptyWidget(message: 'Nenhum cliente encontrado')
                : RefreshIndicator(
                    onRefresh: () => _load(_search),
                    child: ListView.builder(
                      itemCount: _clientes.length,
                      itemBuilder: (BuildContext ctx, int i) {
                        final Cliente c = _clientes[i];
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
                                c.nome[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF6744CF),
                                ),
                              ),
                            ),
                            title: Text(
                              c.nome,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${c.cpf} • ${c.telefone}\n${c.cidade}',
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
                                  onPressed: () => _openForm(c),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _delete(c),
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
        label: const Text('Novo Cliente'),
      ),
    );
  }
}
