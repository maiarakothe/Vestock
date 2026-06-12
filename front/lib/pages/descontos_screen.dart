// lib/screens/descontos_screen.dart
import 'package:awidgets/fields/a_field_date.dart';
import 'package:awidgets/fields/a_field_number.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/general/a_button.dart';
import 'package:flutter/material.dart';
import 'package:front/widgets/shred_widgets.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';

class DescontosScreen extends StatefulWidget {
  const DescontosScreen({super.key});
  @override
  State<DescontosScreen> createState() => _DescontosScreenState();
}

class _DescontosScreenState extends State<DescontosScreen> {
  List<Desconto> _items = <Desconto>[];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.get('/api/descontos');
      setState(() {
        _items = (data as List).map((j) => Desconto.fromJson(j)).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) showError(context, e.toString());
    }
  }

  void _openForm([Desconto? d]) async {
    final saved = await showModalBottomSheet<bool>(
      context: context, isScrollControlled: true, useSafeArea: true,
      builder: (_) => _DescontoForm(desconto: d),
    );
    if (saved == true) _load();
  }

  Future<void> _delete(Desconto d) async {
    final ok = await confirmDialog(context, 'Excluir ${d.nome}?');
    if (ok != true) return;
    try {
      await ApiService.delete('/api/descontos/${d.id}');
      _load();
    } catch (e) {
      if (mounted) showError(context, e.toString());
    }
  }

  String _fmtDate(String? s) {
    if (s == null || s.isEmpty) return '';
    final parts = s.split('-');
    if (parts.length == 3) return '${parts[2]}/${parts[1]}/${parts[0]}';
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const LoadingWidget()
          : _items.isEmpty
              ? const EmptyWidget(message: 'Nenhum desconto cadastrado')
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _items.length,
                    itemBuilder: (ctx, i) {
                      final d = _items[i];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green[50],
                            child: Text('${d.valor.toInt()}%',
                                style: TextStyle(
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                          ),
                          title: Text(d.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              'Início: ${_fmtDate(d.dataCadastro?.substring(0, 10))}  •  Validade: ${_fmtDate(d.dataValidade)}'),
                          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(icon: const Icon(Icons.edit_outlined, color: Colors.blue), onPressed: () => _openForm(d)),
                            IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _delete(d)),
                          ]),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Novo Desconto'),
      ),
    );
  }
}

class _DescontoForm extends StatefulWidget {
  final Desconto? desconto;
  const _DescontoForm({this.desconto});
  @override
  State<_DescontoForm> createState() => _DescontoFormState();
}

class _DescontoFormState extends State<_DescontoForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nome, _valor, _dataInicio, _dataValidade;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final d = widget.desconto;
    _nome = TextEditingController(text: d?.nome);
    _valor = TextEditingController(text: d?.valor.toString());
    _dataInicio = TextEditingController(
        text: d?.dataCadastro?.substring(0, 10) ??
            DateTime.now().toIso8601String().substring(0, 10));
    _dataValidade = TextEditingController(text: d?.dataValidade);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final body = Desconto(
        nome: _nome.text,
        valor: double.parse(_valor.text),
        dataCadastro: _dataInicio.text,
        dataValidade: _dataValidade.text,
      ).toJson();

      if (widget.desconto?.id != null) {
        await ApiService.put('/api/descontos/${widget.desconto!.id}', body);
      } else {
        await ApiService.post('/api/descontos', body);
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
              Text(widget.desconto == null ? 'Novo Desconto' : 'Editar Desconto',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: AFieldText(
                  label: 'Nome',
                  identifier: 'name',
                  required: true,
                ),),
                const SizedBox(width: 12),
                Expanded(child: AFieldNumber(
                  label: 'Desconto (%)',
                  identifier: 'value',
                  required: true,
                 suffix: Text('%'),
                )),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child:AFieldDate(
                    label: 'Data de Início',
                    required: true,
                ),),
                const SizedBox(width: 12),
                Expanded(child: AFieldDate(
                    label: 'Data de Validade',
                    required: true,),
                ),
              ]),
              const SizedBox(height: 20),
              Row(
                children: [
                  AButton(
                      onPressed: _loading ? null : _submit,
                      expanded: true,
                      height: 39,
                      text: 'Salvar',
                    ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
