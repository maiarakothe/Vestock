// lib/screens/produtos_screen.dart
import 'package:flutter/material.dart';
import 'package:front/widgets/shred_widgets.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';

class ProdutosScreen extends StatefulWidget {
  const ProdutosScreen({super.key});
  @override
  State<ProdutosScreen> createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  List<Produto> _produtos = [];
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
          ? '/api/produtos/search?q=${Uri.encodeComponent(termo)}'
          : '/api/produtos';
      final data = await ApiService.get(path);
      setState(() {
        _produtos = (data as List).map((j) => Produto.fromJson(j)).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) showError(context, e.toString());
    }
  }

  void _openForm([Produto? p]) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _ProdutoForm(produto: p),
    );
    if (saved == true) _load(_search);
  }

  Future<void> _delete(Produto p) async {
    final ok = await confirmDialog(context, 'Excluir ${p.nome}?');
    if (ok != true) return;
    try {
      await ApiService.delete('/api/produtos/${p.id}');
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
                hintText: 'Buscar produto...',
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
                : _produtos.isEmpty
                    ? const EmptyWidget(message: 'Nenhum produto encontrado')
                    : RefreshIndicator(
                        onRefresh: () => _load(_search),
                        child: ListView.builder(
                          itemCount: _produtos.length,
                          itemBuilder: (ctx, i) {
                            final p = _produtos[i];
                            final estoqueColor = p.quantidadeEstoque <= 5
                                ? Colors.red
                                : p.quantidadeEstoque <= 15
                                    ? Colors.orange
                                    : Colors.green;
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFFEDE7FF),
                                  child: Text(
                                    p.nome[0].toUpperCase(),
                                    style: const TextStyle(
                                        color: Color(0xFF6744CF)),
                                  ),
                                ),
                                title: Text(p.nome,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                  '${p.tipo ?? ''} • ${p.tamanho ?? ''} • ${p.cor ?? ''}\n'
                                  'Venda: R\$ ${p.venda.toStringAsFixed(2)}',
                                ),
                                isThreeLine: true,
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${p.quantidadeEstoque}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: estoqueColor,
                                              fontSize: 16),
                                        ),
                                        Text('estoque',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey[600])),
                                      ],
                                    ),
                                    const SizedBox(width: 4),
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined,
                                          color: Colors.blue),
                                      onPressed: () => _openForm(p),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.red),
                                      onPressed: () => _delete(p),
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
        label: const Text('Novo Produto'),
      ),
    );
  }
}

// ─── Formulário ───────────────────────────────────────────────────────────────

class _ProdutoForm extends StatefulWidget {
  final Produto? produto;
  const _ProdutoForm({this.produto});
  @override
  State<_ProdutoForm> createState() => _ProdutoFormState();
}

class _ProdutoFormState extends State<_ProdutoForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nome, _tamanho, _cor, _tipo,
      _custo, _venda, _estoque, _descricao, _dataCadastro;

  List<Fornecedor> _fornecedores = [];
  List<Loja> _lojas = [];
  int? _fornecedorId, _lojaId;
  bool _ativo = true;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.produto;
    _nome = TextEditingController(text: p?.nome);
    _tamanho = TextEditingController(text: p?.tamanho);
    _cor = TextEditingController(text: p?.cor);
    _tipo = TextEditingController(text: p?.tipo);
    _custo = TextEditingController(text: p?.custo.toString());
    _venda = TextEditingController(text: p?.venda.toString());
    _estoque =
        TextEditingController(text: p?.quantidadeEstoque.toString() ?? '0');
    _descricao = TextEditingController(text: p?.descricao);
    _dataCadastro = TextEditingController(
        text: p?.dataCadastro ??
            DateTime.now().toIso8601String().substring(0, 16));
    _ativo = p?.ativo ?? true;
    _fornecedorId = p?.fornecedor?.id;
    _lojaId = p?.loja?.id;
    _loadSelects();
  }

  Future<void> _loadSelects() async {
    try {
      final results = await Future.wait([
        ApiService.get('/api/fornecedores'),
        ApiService.get('/api/lojas'),
      ]);
      setState(() {
        _fornecedores =
            (results[0] as List).map((j) => Fornecedor.fromJson(j)).toList();
        _lojas = (results[1] as List).map((j) => Loja.fromJson(j)).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) showError(context, e.toString());
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fornecedorId == null || _lojaId == null) {
      showError(context, 'Selecione fornecedor e loja');
      return;
    }
    setState(() => _saving = true);
    try {
      final body = Produto(
        nome: _nome.text,
        tamanho: _tamanho.text,
        cor: _cor.text,
        tipo: _tipo.text,
        custo: double.tryParse(_custo.text) ?? 0,
        venda: double.tryParse(_venda.text) ?? 0,
        quantidadeEstoque: int.tryParse(_estoque.text) ?? 0,
        descricao: _descricao.text,
        ativo: _ativo,
        dataCadastro: _dataCadastro.text.length == 16
            ? '${_dataCadastro.text}:00'
            : _dataCadastro.text,
        fornecedor: Fornecedor(
            id: _fornecedorId,
            nome: '',
            cnpj: '',
            telefone: '',
            email: ''),
        loja: Loja(id: _lojaId, nome: '', cnpj: '', telefone: ''),
      ).toJson();

      if (widget.produto?.id != null) {
        await ApiService.put('/api/produtos/${widget.produto!.id}', body);
      } else {
        await ApiService.post('/api/produtos', body);
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
              height: 200, child: Center(child: CircularProgressIndicator()))
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.produto == null
                          ? 'Novo Produto'
                          : 'Editar Produto',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Nome
                    FormField2(
                        label: 'Nome do Produto',
                        controller: _nome,
                        required: true),
                    const SizedBox(height: 12),

                    // Tamanho / Cor
                    Row(children: [
                      Expanded(
                          child: FormField2(
                              label: 'Tamanho',
                              controller: _tamanho,
                              required: true)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: FormField2(
                              label: 'Cor',
                              controller: _cor,
                              required: true)),
                    ]),
                    const SizedBox(height: 12),

                    // Tipo
                    FormField2(
                        label: 'Tipo', controller: _tipo, required: true),
                    const SizedBox(height: 12),

                    // Preços
                    Row(children: [
                      Expanded(
                          child: TextFormField(
                        controller: _custo,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                            labelText: 'Preço de Custo',
                            prefixText: 'R\$ '),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Obrigatório' : null,
                      )),
                      const SizedBox(width: 12),
                      Expanded(
                          child: TextFormField(
                        controller: _venda,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                            labelText: 'Preço de Venda',
                            prefixText: 'R\$ '),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Obrigatório' : null,
                      )),
                    ]),
                    const SizedBox(height: 12),

                    // Estoque / Data
                    Row(children: [
                      Expanded(
                          child: TextFormField(
                        controller: _estoque,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: 'Estoque'),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Obrigatório' : null,
                      )),
                      const SizedBox(width: 12),
                      Expanded(
                          child: FormField2(
                              label: 'Data Cadastro',
                              controller: _dataCadastro,
                              readOnly: true)),
                    ]),
                    const SizedBox(height: 12),

                    // Descrição
                    FormField2(
                        label: 'Descrição',
                        controller: _descricao,
                        maxLines: 2),
                    const SizedBox(height: 12),

                    // Fornecedor
                    DropdownButtonFormField<int>(
                      value: _fornecedorId,
                      decoration:
                          const InputDecoration(labelText: 'Fornecedor'),
                      items: _fornecedores
                          .map((f) => DropdownMenuItem(
                              value: f.id, child: Text(f.nome)))
                          .toList(),
                      onChanged: (v) => setState(() => _fornecedorId = v),
                      validator: (v) =>
                          v == null ? 'Selecione um fornecedor' : null,
                    ),
                    const SizedBox(height: 12),

                    // Loja
                    DropdownButtonFormField<int>(
                      value: _lojaId,
                      decoration: const InputDecoration(labelText: 'Loja'),
                      items: _lojas
                          .map((l) => DropdownMenuItem(
                              value: l.id, child: Text(l.nome)))
                          .toList(),
                      onChanged: (v) => setState(() => _lojaId = v),
                      validator: (v) =>
                          v == null ? 'Selecione uma loja' : null,
                    ),
                    const SizedBox(height: 12),

                    // Ativo
                    SwitchListTile(
                      value: _ativo,
                      onChanged: (v) => setState(() => _ativo = v),
                      title: const Text('Produto Ativo'),
                      contentPadding: EdgeInsets.zero,
                    ),
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
            ),
    );
  }
}
