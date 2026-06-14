import 'package:front/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:front/widgets/shred_widgets.dart';
import '../../../services/api_service.dart';
import '../../models/desconto.dart';
import 'desconto_form.dart';

class DescontosScreen extends StatefulWidget {
  const DescontosScreen({super.key});

  @override
  State<DescontosScreen> createState() => _DescontosScreenState();
}

class _DescontosScreenState extends State<DescontosScreen> {
  List<Desconto> _items = <Desconto>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final dynamic data = await ApiService.get('/api/descontos');
      setState(() {
        _items = (data as List)
            .map((dynamic j) => Desconto.fromJson(j))
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

  Future<void> _openForm([Desconto? d]) async {
    final bool? saved = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => DescontoForm(desconto: d),
    );

    if (saved == true) {
      await _load();
    }
  }

  Future<void> _delete(Desconto d) async {
    final bool? ok = await confirmDialog(context, 'Excluir ${d.nome}?');
    if (ok != true) {
      return;
    }
    try {
      await ApiService.delete('/api/descontos/${d.id}');
      await _load();
    } catch (e) {
      if (mounted) {
        showError(context, e.toString());
      }
    }
  }

  String _fmtDate(String? s) {
    if (s == null || s.isEmpty) {
      return '';
    }
    final List<String> parts = s.split('-');
    if (parts.length == 3) {
      return '${parts[2]}/${parts[1]}/${parts[0]}';
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: _loading
          ? const LoadingWidget()
          : _items.isEmpty
          ? const EmptyWidget(message: 'Nenhum desconto cadastrado')
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: _items.length,
                itemBuilder: (BuildContext ctx, int i) {
                  final Desconto d = _items[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.withOpacity(0.1)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: kPrimary.withOpacity(0.1),
                        child: Text(
                          '${d.valor.toInt()}%',
                          style: const TextStyle(
                            color: kPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      title: Text(
                        d.nome,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 4),
                          Text(
                            'Início: ${_fmtDate(d.dataCadastro?.substring(0, 10))}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'Validade: ${_fmtDate(d.dataValidade)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Colors.blue,
                            ),
                            onPressed: () => _openForm(d),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () => _delete(d),
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
        label: const Text('Novo Desconto'),
      ),
    );
  }
}
