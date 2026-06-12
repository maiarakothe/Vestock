// lib/screens/fornecedores_screen.dart
import 'package:flutter/material.dart';
import 'package:front/widgets/shred_widgets.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';

class FornecedoresScreen extends StatefulWidget {
  const FornecedoresScreen({super.key});
  @override
  State<FornecedoresScreen> createState() => _FornecedoresScreenState();
}

class _FornecedoresScreenState extends State<FornecedoresScreen> {
  List<Fornecedor> _items = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.get('/api/fornecedores');
      setState(() {
        _items = (data as List).map((j) => Fornecedor.fromJson(j)).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) showError(context, e.toString());
    }
  }

  void _openForm([Fornecedor? f]) async {
    final saved = await showModalBottomSheet<bool>(
      context: context, isScrollControlled: true, useSafeArea: true,
      builder: (_) => _FornecedorForm(fornecedor: f),
    );
    if (saved == true) _load();
  }

  Future<void> _delete(Fornecedor f) async {
    final ok = await confirmDialog(context, 'Excluir ${f.nome}?');
    if (ok != true) return;
    try {
      await ApiService.delete('/api/fornecedores/${f.id}');
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
              ? const EmptyWidget(message: 'Nenhum fornecedor')
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _items.length,
                    itemBuilder: (ctx, i) {
                      final f = _items[i];
                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.local_shipping)),
                          title: Text(f.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${f.cnpj}\n${f.email} • ${f.telefone}\n${f.cidade ?? ''}'),
                          isThreeLine: true,
                          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(icon: const Icon(Icons.edit_outlined, color: Colors.blue), onPressed: () => _openForm(f)),
                            IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _delete(f)),
                          ]),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Novo Fornecedor'),
      ),
    );
  }
}

class _FornecedorForm extends StatefulWidget {
  final Fornecedor? fornecedor;
  const _FornecedorForm({this.fornecedor});
  @override
  State<_FornecedorForm> createState() => _FornecedorFormState();
}

class _FornecedorFormState extends State<_FornecedorForm> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _c;
  String _sexo = 'M';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final f = widget.fornecedor;
    _c = {
      'nome': TextEditingController(text: f?.nome),
      'cnpj': TextEditingController(text: f?.cnpj),
      'telefone': TextEditingController(text: f?.telefone),
      'email': TextEditingController(text: f?.email),
      'nomeFantasia': TextEditingController(text: f?.nomeFantasia),
      'rua': TextEditingController(text: f?.rua),
      'bairro': TextEditingController(text: f?.bairro),
      'cidade': TextEditingController(text: f?.cidade),
      'estado': TextEditingController(text: f?.estado),
    };
    _sexo = f?.sexo ?? 'M';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final body = Fornecedor(
        nome: _c['nome']!.text, cnpj: _c['cnpj']!.text,
        telefone: _c['telefone']!.text, email: _c['email']!.text,
        nomeFantasia: _c['nomeFantasia']!.text, sexo: _sexo,
        rua: _c['rua']!.text, bairro: _c['bairro']!.text,
        cidade: _c['cidade']!.text, estado: _c['estado']!.text,
      ).toJson();

      if (widget.fornecedor?.id != null) {
        await ApiService.put('/api/fornecedores/${widget.fornecedor!.id}', body);
      } else {
        await ApiService.post('/api/fornecedores', body);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.fornecedor == null ? 'Novo Fornecedor' : 'Editar Fornecedor',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: FormField2(label: 'Nome', controller: _c['nome']!, required: true)),
                const SizedBox(width: 12),
                Expanded(child: FormField2(label: 'CNPJ', controller: _c['cnpj']!, required: true)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: FormField2(label: 'Telefone', controller: _c['telefone']!, required: true)),
                const SizedBox(width: 12),
                Expanded(child: FormField2(label: 'Email', controller: _c['email']!, required: true)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: FormField2(label: 'Nome Fantasia', controller: _c['nomeFantasia']!)),
                const SizedBox(width: 12),
                Expanded(child: DropdownButtonFormField<String>(
                  value: _sexo,
                  decoration: const InputDecoration(labelText: 'Sexo Contato'),
                  items: const [
                    DropdownMenuItem(value: 'M', child: Text('M')),
                    DropdownMenuItem(value: 'F', child: Text('F')),
                  ],
                  onChanged: (v) => setState(() => _sexo = v!),
                )),
              ]),
              buildAddressSection(_c),
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
