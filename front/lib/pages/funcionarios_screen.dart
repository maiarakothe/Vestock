// lib/screens/funcionarios_screen.dart
import 'package:flutter/material.dart';
import 'package:front/widgets/shred_widgets.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';

class FuncionariosScreen extends StatefulWidget {
  const FuncionariosScreen({super.key});
  @override
  State<FuncionariosScreen> createState() => _FuncionariosScreenState();
}

class _FuncionariosScreenState extends State<FuncionariosScreen> {
  List<Funcionario> _items = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.get('/api/funcionarios');
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
    final saved = await showModalBottomSheet<bool>(
      context: context, isScrollControlled: true, useSafeArea: true,
      builder: (_) => _FuncionarioForm(funcionario: f),
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
                            child: Text(f.nome[0].toUpperCase(),
                                style: const TextStyle(color: Color(0xFF6744CF))),
                          ),
                          title: Text(f.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(f.cargo),
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
        label: const Text('Novo Funcionário'),
      ),
    );
  }
}

class _FuncionarioForm extends StatefulWidget {
  final Funcionario? funcionario;
  const _FuncionarioForm({this.funcionario});
  @override
  State<_FuncionarioForm> createState() => _FuncionarioFormState();
}

class _FuncionarioFormState extends State<_FuncionarioForm> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _c;
  String _sexo = 'M';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final f = widget.funcionario;
    _c = {
      'nome': TextEditingController(text: f?.nome),
      'cpf': TextEditingController(text: f?.cpf),
      'cargo': TextEditingController(text: f?.cargo),
      'telefone': TextEditingController(text: f?.telefone),
      'email': TextEditingController(text: f?.email),
      'dataAdmissao': TextEditingController(
          text: f?.dataAdmissao?.substring(0, 10) ??
              DateTime.now().toIso8601String().substring(0, 10)),
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
      final body = Funcionario(
        nome: _c['nome']!.text, cpf: _c['cpf']!.text,
        cargo: _c['cargo']!.text, telefone: _c['telefone']!.text,
        email: _c['email']!.text, sexo: _sexo,
        dataAdmissao: _c['dataAdmissao']!.text,
        rua: _c['rua']!.text, bairro: _c['bairro']!.text,
        cidade: _c['cidade']!.text, estado: _c['estado']!.text,
      ).toJson();

      if (widget.funcionario?.id != null) {
        await ApiService.put('/api/funcionarios/${widget.funcionario!.id}', body);
      } else {
        await ApiService.post('/api/funcionarios', body);
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
              Text(widget.funcionario == null ? 'Novo Funcionário' : 'Editar Funcionário',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: FormField2(label: 'Nome', controller: _c['nome']!, required: true)),
                const SizedBox(width: 12),
                Expanded(child: FormField2(label: 'CPF', controller: _c['cpf']!, required: true)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: FormField2(label: 'Cargo', controller: _c['cargo']!, required: true)),
                const SizedBox(width: 12),
                Expanded(child: FormField2(label: 'Telefone', controller: _c['telefone']!, required: true)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: FormField2(label: 'Email', controller: _c['email']!, required: true)),
                const SizedBox(width: 12),
                Expanded(child: FormField2(label: 'Admissão (AAAA-MM-DD)', controller: _c['dataAdmissao']!, required: true)),
              ]),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _sexo,
                decoration: const InputDecoration(labelText: 'Sexo'),
                items: const [
                  DropdownMenuItem(value: 'M', child: Text('M')),
                  DropdownMenuItem(value: 'F', child: Text('F')),
                ],
                onChanged: (v) => setState(() => _sexo = v!),
              ),
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
