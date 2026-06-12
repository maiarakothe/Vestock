// lib/screens/lojas_screen.dart
import 'package:flutter/material.dart';
import 'package:front/widgets/shred_widgets.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';

class LojasScreen extends StatefulWidget {
  const LojasScreen({super.key});
  @override
  State<LojasScreen> createState() => _LojasScreenState();
}

class _LojasScreenState extends State<LojasScreen> {
  List<Loja> _lojas = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.get('/api/lojas');
      setState(() {
        _lojas = (data as List).map((j) => Loja.fromJson(j)).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) showError(context, e.toString());
    }
  }

  void _openForm([Loja? l]) async {
    final saved = await showModalBottomSheet<bool>(
      context: context, isScrollControlled: true, useSafeArea: true,
      builder: (_) => _LojaForm(loja: l),
    );
    if (saved == true) _load();
  }

  Future<void> _delete(Loja l) async {
    final ok = await confirmDialog(context, 'Excluir ${l.nome}?');
    if (ok != true) return;
    try {
      await ApiService.delete('/api/lojas/${l.id}');
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
          : _lojas.isEmpty
              ? const EmptyWidget(message: 'Nenhuma loja cadastrada')
              : RefreshIndicator(
                  onRefresh: _load,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _lojas.length,
                    itemBuilder: (ctx, i) {
                      final l = _lojas[i];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.blue[50],
                                    child: const Icon(Icons.store, color: Colors.blue),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(l.nome,
                                        style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text('CNPJ: ${l.cnpj}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 4),
                              Row(children: [
                                const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(child: Text('${l.cidade ?? ''} - ${l.bairro ?? ''}', style: const TextStyle(fontSize: 12))),
                              ]),
                              Row(children: [
                                const Icon(Icons.phone_outlined, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(l.telefone, style: const TextStyle(fontSize: 12)),
                              ]),
                              const Spacer(),
                              Row(children: [
                                Expanded(child: OutlinedButton.icon(
                                  onPressed: () => _openForm(l),
                                  icon: const Icon(Icons.edit, size: 14),
                                  label: const Text('Editar'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                  ),
                                )),
                                const SizedBox(width: 8),
                                Expanded(child: OutlinedButton.icon(
                                  onPressed: () => _delete(l),
                                  icon: const Icon(Icons.delete, size: 14),
                                  label: const Text('Excluir'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                  ),
                                )),
                              ]),
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
        label: const Text('Nova Loja'),
      ),
    );
  }
}

class _LojaForm extends StatefulWidget {
  final Loja? loja;
  const _LojaForm({this.loja});
  @override
  State<_LojaForm> createState() => _LojaFormState();
}

class _LojaFormState extends State<_LojaForm> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _c;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final l = widget.loja;
    _c = {
      'nome': TextEditingController(text: l?.nome),
      'cnpj': TextEditingController(text: l?.cnpj),
      'telefone': TextEditingController(text: l?.telefone),
      'rua': TextEditingController(text: l?.rua),
      'bairro': TextEditingController(text: l?.bairro),
      'cidade': TextEditingController(text: l?.cidade),
    };
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final body = Loja(
        nome: _c['nome']!.text, cnpj: _c['cnpj']!.text,
        telefone: _c['telefone']!.text, rua: _c['rua']!.text,
        bairro: _c['bairro']!.text, cidade: _c['cidade']!.text,
      ).toJson();

      if (widget.loja?.id != null) {
        await ApiService.put('/api/lojas/${widget.loja!.id}', body);
      } else {
        await ApiService.post('/api/lojas', body);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) showError(context, e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.loja == null ? 'Nova Loja' : 'Editar Loja',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: FormField2(label: 'Nome', controller: _c['nome']!, required: true)),
                const SizedBox(width: 12),
                Expanded(child: FormField2(label: 'CNPJ', controller: _c['cnpj']!, required: true)),
              ]),
              const SizedBox(height: 12),
              FormField2(label: 'Telefone', controller: _c['telefone']!, required: true),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: FormField2(label: 'Rua', controller: _c['rua']!, required: true)),
                const SizedBox(width: 12),
                Expanded(child: FormField2(label: 'Bairro', controller: _c['bairro']!, required: true)),
              ]),
              const SizedBox(height: 12),
              FormField2(label: 'Cidade', controller: _c['cidade']!, required: true),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Salvar'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
