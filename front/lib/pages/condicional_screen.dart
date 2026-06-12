// lib/screens/condicional_screen.dart
import 'package:flutter/material.dart';
import 'package:front/widgets/shred_widgets.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';

class CondicionalScreen extends StatefulWidget {
  const CondicionalScreen({super.key});
  @override
  State<CondicionalScreen> createState() => _CondicionalScreenState();
}

class _CondicionalScreenState extends State<CondicionalScreen> {
  List<Condicional> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.get('/api/condicionais');
      setState(() {
        _items =
            (data as List).map((j) => Condicional.fromJson(j)).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) showError(context, e.toString());
    }
  }

  void _openForm([Condicional? c]) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _CondicionalForm(condicional: c),
    );
    if (saved == true) _load();
  }

  Future<void> _delete(Condicional c) async {
    final ok =
        await confirmDialog(context, 'Excluir condicional #${c.id}?');
    if (ok != true) return;
    try {
      await ApiService.delete('/api/condicionais/${c.id}');
      _load();
    } catch (e) {
      if (mounted) showError(context, e.toString());
    }
  }

  Future<void> _marcarDevolvido(Condicional c) async {
    final ok = await confirmDialog(
        context, 'Confirmar devolução da condicional #${c.id}?');
    if (ok != true) return;
    try {
      await ApiService.patch('/api/condicionais/${c.id}/devolver');
      _load();
    } catch (e) {
      if (mounted) showError(context, e.toString());
    }
  }

  String _fmtData(String? s) {
    if (s == null) return '–';
    try {
      final dt = DateTime.parse(s);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} '
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return s;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const LoadingWidget()
          : _items.isEmpty
              ? const EmptyWidget(message: 'Nenhuma condicional registrada')
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _items.length,
                    itemBuilder: (ctx, i) {
                      final c = _items[i];
                      return _CondicionalCard(
                        condicional: c,
                        fmtData: _fmtData,
                        onEdit: () => _openForm(c),
                        onDelete: () => _delete(c),
                        onDevolver: () => _marcarDevolvido(c),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Novo Condicional'),
      ),
    );
  }
}

// ─── Card de condicional ──────────────────────────────────────────────────────

class _CondicionalCard extends StatelessWidget {
  final Condicional condicional;
  final String Function(String?) fmtData;
  final VoidCallback onEdit, onDelete, onDevolver;

  const _CondicionalCard({
    required this.condicional,
    required this.fmtData,
    required this.onEdit,
    required this.onDelete,
    required this.onDevolver,
  });

  @override
  Widget build(BuildContext context) {
    final c = condicional;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor:
              c.devolvido ? Colors.green[50] : Colors.orange[50],
          child: Icon(
            c.devolvido ? Icons.check_circle : Icons.loop,
            color: c.devolvido ? Colors.green : Colors.orange,
          ),
        ),
        title: Text(c.clienteNome,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(c.nomeItem ?? ''),
        trailing: c.devolvido
            ? const Chip(
                label: Text('Devolvido',
                    style: TextStyle(
                        color: Colors.white, fontSize: 11)),
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 4),
              )
            : null,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row(Icons.calendar_today_outlined, 'Retirada',
                    fmtData(c.dataRetirada)),
                _row(Icons.event_available_outlined, 'Devolução',
                    fmtData(c.dataDevolucao)),
                if (c.observacao?.isNotEmpty == true)
                  _row(Icons.notes, 'Obs', c.observacao!),
                const Divider(height: 16),
                const Text('Itens:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                ...c.itens.map((it) => Text(
                    '  • ${it.quantidade}x ${it.nomeProduto ?? ''}',
                    style: const TextStyle(fontSize: 13))),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!c.devolvido)
                      OutlinedButton.icon(
                        onPressed: onDevolver,
                        icon: const Icon(Icons.check_circle_outline,
                            size: 16),
                        label: const Text('Devolvido'),
                        style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green),
                      ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          color: Colors.blue),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.red),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 15, color: Colors.grey),
          const SizedBox(width: 6),
          Text('$label: ',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 13)),
          Expanded(
              child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

// ─── Formulário ───────────────────────────────────────────────────────────────

class _CondicionalForm extends StatefulWidget {
  final Condicional? condicional;
  const _CondicionalForm({this.condicional});
  @override
  State<_CondicionalForm> createState() => _CondicionalFormState();
}

class _CondicionalFormState extends State<_CondicionalForm> {
  List<Cliente> _clientes = [];
  List<Produto> _produtos = [];

  int? _clienteId;
  late final TextEditingController _nomeItem, _dataRetirada,
      _dataDevolucao, _obs;

  final List<ItemCondicional> _itens = [];
  int? _produtoSelecionadoId;
  int _qtdSelecionada = 1;

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final c = widget.condicional;
    _clienteId = c?.clienteId;
    _nomeItem = TextEditingController(text: c?.nomeItem);
    _dataRetirada = TextEditingController(
        text: c?.dataRetirada?.substring(0, 16) ??
            DateTime.now().toIso8601String().substring(0, 16));
    _dataDevolucao =
        TextEditingController(text: c?.dataDevolucao?.substring(0, 16));
    _obs = TextEditingController(text: c?.observacao);

    if (c != null) {
      _itens.addAll(c.itens);
    }
    _loadDados();
  }

  Future<void> _loadDados() async {
    try {
      final results = await Future.wait([
        ApiService.get('/api/clientes'),
        ApiService.get('/api/produtos/com-estoque'),
      ]);
      setState(() {
        _clientes =
            (results[0] as List).map((j) => Cliente.fromJson(j)).toList();
        _produtos = (results[1] as List)
            .map((j) => Produto.fromJson(j))
            .toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) showError(context, e.toString());
    }
  }

  void _adicionarItem() {
    if (_produtoSelecionadoId == null) {
      showError(context, 'Selecione um produto');
      return;
    }
    final prod =
        _produtos.firstWhere((p) => p.id == _produtoSelecionadoId);
    setState(() {
      _itens.add(ItemCondicional(
        produtoId: prod.id,
        nomeProduto: prod.nome,
        quantidade: _qtdSelecionada,
      ));
      _produtoSelecionadoId = null;
      _qtdSelecionada = 1;
    });
  }

  Future<void> _submit() async {
    if (_clienteId == null) {
      showError(context, 'Selecione o cliente');
      return;
    }
    if (_itens.isEmpty) {
      showError(context, 'Adicione pelo menos um item');
      return;
    }
    setState(() => _saving = true);
    try {
      final body = Condicional(
        clienteId: _clienteId!,
        clienteNome: '',
        nomeItem: _nomeItem.text,
        dataRetirada: _dataRetirada.text,
        dataDevolucao:
            _dataDevolucao.text.isNotEmpty ? _dataDevolucao.text : null,
        observacao: _obs.text,
        devolvido: false,
        itens: _itens,
      ).toJson();

      if (widget.condicional?.id != null) {
        await ApiService.put(
            '/api/condicionais/${widget.condicional!.id}', body);
      } else {
        await ApiService.post('/api/condicionais', body);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) showError(context, e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16),
      child: _loading
          ? const SizedBox(
              height: 300,
              child: Center(child: CircularProgressIndicator()))
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.condicional == null
                        ? 'Novo Condicional'
                        : 'Editar Condicional',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Cliente
                  DropdownButtonFormField<int>(
                    value: _clienteId,
                    decoration:
                        const InputDecoration(labelText: 'Cliente'),
                    items: _clientes
                        .map((c) => DropdownMenuItem(
                            value: c.id, child: Text(c.nome)))
                        .toList(),
                    onChanged: (v) => setState(() => _clienteId = v),
                  ),
                  const SizedBox(height: 12),

                  // Nome
                  FormField2(
                      label: 'Nome da Condicional',
                      controller: _nomeItem,
                      required: true),
                  const SizedBox(height: 12),

                  // Datas
                  Row(children: [
                    Expanded(
                        child: FormField2(
                            label: 'Retirada (AAAA-MM-DDTHH:mm)',
                            controller: _dataRetirada,
                            required: true)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: FormField2(
                            label: 'Devolução (opcional)',
                            controller: _dataDevolucao)),
                  ]),
                  const SizedBox(height: 12),

                  // Observação
                  FormField2(
                      label: 'Observações',
                      controller: _obs,
                      maxLines: 2),
                  const SizedBox(height: 16),

                  // Adicionar item
                  const Text('Itens',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                      flex: 5,
                      child: DropdownButtonFormField<int>(
                        value: _produtoSelecionadoId,
                        isExpanded: true,
                        decoration: const InputDecoration(
                            labelText: 'Produto', isDense: true),
                        items: _produtos
                            .map((p) => DropdownMenuItem(
                                  value: p.id,
                                  child: Text(
                                    '${p.nome} (est: ${p.quantidadeEstoque})',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _produtoSelecionadoId = v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 64,
                      child: TextFormField(
                        initialValue: _qtdSelecionada.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Qtd', isDense: true),
                        onChanged: (v) =>
                            _qtdSelecionada = int.tryParse(v) ?? 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _adicionarItem,
                      child: const Text('Add'),
                    ),
                  ]),
                  const SizedBox(height: 8),

                  // Lista de itens adicionados
                  if (_itens.isEmpty)
                    const Text('Nenhum item adicionado.',
                        style: TextStyle(color: Colors.grey))
                  else
                    ..._itens.asMap().entries.map((e) => Card(
                          color: Colors.grey[50],
                          margin: const EdgeInsets.only(bottom: 4),
                          child: ListTile(
                            dense: true,
                            title: Text(
                                '${e.value.quantidade}x  ${e.value.nomeProduto ?? ''}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.close,
                                  size: 18, color: Colors.red),
                              onPressed: () =>
                                  setState(() => _itens.removeAt(e.key)),
                            ),
                          ),
                        )),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _submit,
                      child: _saving
                          ? const CircularProgressIndicator(
                              color: Colors.white)
                          : const Text('Salvar'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}
