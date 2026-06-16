import 'package:awidgets/fields/a_field_search.dart';
import 'package:flutter/material.dart';
import 'package:front/widgets/shared_widgets.dart';
import '../../app_theme.dart';
import '../../widgets/modern_card.dart';
import '../../constants.dart';
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
    final bool isMobile = MediaQuery.of(context).size.width < kMobileBreakpoint;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                    child: isMobile ? _buildMobileList() : _buildDesktopTable(),
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

  Widget _buildMobileList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _clientes.length,
      itemBuilder: (BuildContext ctx, int i) {
        final Cliente c = _clientes[i];
        return ModernCard(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: DefaultColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                c.nome.isNotEmpty ? c.nome[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: DefaultColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          title: c.nome,
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('CPF: ${c.cpf}'),
              Text('Telefone: ${c.telefone}'),
              if (c.cidade.isNotEmpty) Text('Cidade: ${c.cidade}'),
            ],
          ),
          actions: <Widget>[
            buildActionButton(
              icon: Icons.edit_outlined,
              color: DefaultColors.accent,
              onTap: () => _openForm(c),
            ),
            const SizedBox(width: 8),
            buildActionButton(
              icon: Icons.delete_outline,
              color: DefaultColors.error,
              onTap: () => _delete(c),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDesktopTable() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth - 40,
                ),
                child: DataTable(
                  columnSpacing: 40,
                  headingRowColor: WidgetStateProperty.all(
                    Colors.grey.withOpacity(0.05),
                  ),
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text(
                        'Nome',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'CPF',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Telefone',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Cidade',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Ações',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: _clientes.map((Cliente c) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(c.nome)),
                        DataCell(Text(c.cpf)),
                        DataCell(Text(c.telefone)),
                        DataCell(Text(c.cidade.isNotEmpty ? c.cidade : '-')),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              buildActionButton(
                                icon: Icons.edit_outlined,
                                color: DefaultColors.accent,
                                onTap: () => _openForm(c),
                              ),
                              const SizedBox(width: 8),
                              buildActionButton(
                                icon: Icons.delete_outline,
                                color: DefaultColors.error,
                                onTap: () => _delete(c),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
