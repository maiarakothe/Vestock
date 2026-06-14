// lib/screens/funcionarios_screen.dart
import 'package:flutter/material.dart';
import 'package:front/widgets/shred_widgets.dart';
import '../../../services/api_service.dart';
import '../../models/funcionario.dart';
import 'funcionario_form.dart';

class FuncionariosScreen extends StatefulWidget {
  const FuncionariosScreen({super.key});
  @override
  State<FuncionariosScreen> createState() => _FuncionariosScreenState();
}

class _FuncionariosScreenState extends State<FuncionariosScreen> {
  List<Funcionario> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final dynamic data = await ApiService.get('/api/funcionarios');
      setState(() {
        _items = (data as List).map((j) => Funcionario.fromJson(j)).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) showError(context, e.toString());
    }
  }

  void _openForm([Funcionario? f]) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => FuncionarioForm(funcionario: f),
    );
    if (saved == true) _load();
  }

  Future<void> _delete(Funcionario f) async {
    final ok = await confirmDialog(context, 'Excluir ${f.nome}?');
    if (ok != true) return;
    try {
      await ApiService.delete('/api/funcionarios/${f.id}');
      _load();
    } catch (e) {
      if (mounted) showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const LoadingWidget()
          : _items.isEmpty
          ? const EmptyWidget(message: 'Nenhum funcionário')
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _items.length,
                itemBuilder: (ctx, i) {
                  final f = _items[i];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFEDE7FF),
                        child: Text(
                          f.nome[0].toUpperCase(),
                          style: const TextStyle(color: Color(0xFF6744CF)),
                        ),
                      ),
                      title: Text(
                        f.nome,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(f.cargo),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Novo Funcionário'),
      ),
    );
  }
}
