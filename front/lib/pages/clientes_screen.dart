// lib/screens/clientes_screen.dart
import 'package:flutter/material.dart';
import 'package:front/widgets/shred_widgets.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});
  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  List<Cliente> _clientes = [];
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
      final path = termo.isNotEmpty
          ? '/api/clientes?search=${Uri.encodeComponent(termo)}'
          : '/api/clientes';
      final data = await ApiService.get(path);
      setState(() {
        _clientes = (data as List).map((j) => Cliente.fromJson(j)).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) showError(context, e.toString());
    }
  }

  void _openForm([Cliente? c]) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _ClienteForm(cliente: c),
    );
    if (saved == true) _load(_search);
  }

  Future<void> _delete(Cliente c) async {
    final ok = await confirmDialog(context, 'Excluir ${c.nome}?');
    if (ok != true) return;
    try {
      await ApiService.delete('/api/clientes/${c.id}');
      _load(_search);
    } catch (e) {
      if (mounted) showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar clientes...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) {
                _search = v;
                _load(v);
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
                          itemBuilder: (ctx, i) {
                            final c = _clientes[i];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFFEDE7FF),
                                  child: Text(c.nome[0].toUpperCase(),
                                      style: const TextStyle(
                                          color: Color(0xFF6744CF))),
                                ),
                                title: Text(c.nome,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                subtitle:
                                    Text('${c.cpf} • ${c.telefone}\n${c.cidade}'),
                                isThreeLine: true,
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined,
                                          color: Colors.blue),
                                      onPressed: () => _openForm(c),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.red),
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
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Novo Cliente'),
      ),
    );
  }
}

class _ClienteForm extends StatefulWidget {
  final Cliente? cliente;
  const _ClienteForm({this.cliente});
  @override
  State<_ClienteForm> createState() => _ClienteFormState();
}

class _ClienteFormState extends State<_ClienteForm> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _c;
  String _sexo = 'M';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final cl = widget.cliente;
    _c = {
      'nome': TextEditingController(text: cl?.nome),
      'cpf': TextEditingController(text: cl?.cpf),
      'telefone': TextEditingController(text: cl?.telefone),
      'email': TextEditingController(text: cl?.email),
      'dataCadastro': TextEditingController(
          text: cl?.dataCadastro ?? DateTime.now().toIso8601String()),
      'rua': TextEditingController(text: cl?.rua),
      'bairro': TextEditingController(text: cl?.bairro),
      'cidade': TextEditingController(text: cl?.cidade),
      'estado': TextEditingController(text: cl?.estado),
    };
    _sexo = cl?.sexo.isEmpty == false ? cl!.sexo : 'M';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final body = Cliente(
        nome: _c['nome']!.text,
        cpf: _c['cpf']!.text,
        telefone: _c['telefone']!.text,
        email: _c['email']!.text,
        sexo: _sexo,
        dataCadastro: _c['dataCadastro']!.text,
        rua: _c['rua']!.text,
        bairro: _c['bairro']!.text,
        cidade: _c['cidade']!.text,
        estado: _c['estado']!.text,
      ).toJson();

      if (widget.cliente?.id != null) {
        await ApiService.put('/api/clientes/${widget.cliente!.id}', body);
      } else {
        await ApiService.post('/api/clientes', body);
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
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16, right: 16, top: 16),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.cliente == null ? 'Novo Cliente' : 'Editar Cliente',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: FormField2(label: 'Nome', controller: _c['nome']!, required: true)),
                const SizedBox(width: 12),
                Expanded(child: FormField2(label: 'CPF', controller: _c['cpf']!, required: true)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: FormField2(label: 'Telefone', controller: _c['telefone']!, required: true)),
                const SizedBox(width: 12),
                Expanded(child: FormField2(label: 'Email', controller: _c['email']!, required: true)),
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
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Salvar'),
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
