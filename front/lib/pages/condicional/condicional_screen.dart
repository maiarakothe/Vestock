import 'package:flutter/material.dart';
import 'package:front/widgets/shared_widgets.dart';
import 'package:front/widgets/modern_fab.dart';
import '../../../services/api_service.dart';
import '../../models/condicional.dart';
import 'condicional_card.dart';
import 'condicional_form.dart';

class CondicionalScreen extends StatefulWidget {
  const CondicionalScreen({super.key});

  @override
  State<CondicionalScreen> createState() => _CondicionalScreenState();
}

class _CondicionalScreenState extends State<CondicionalScreen> {
  List<Condicional> _items = <Condicional>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final dynamic data = await ApiService.get('/api/condicionais');
      setState(() {
        _items = (data as List<dynamic>)
            .map((dynamic j) => Condicional.fromJson(j))
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

  void _openForm([Condicional? c]) async {
    final bool? saved = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => CondicionalForm(condicional: c),
    );
    if (saved == true) {
      await _load();
    }
  }

  Future<void> _delete(Condicional c) async {
    final bool? ok = await confirmDialog(
      context,
      'Excluir condicional #${c.id}?',
    );
    if (ok != true) {
      return;
    }
    try {
      await ApiService.delete('/api/condicionais/${c.id}');
      await _load();
    } catch (e) {
      if (mounted) {
        showError(context, e.toString());
      }
    }
  }

  Future<void> _marcarDevolvido(Condicional c) async {
    final bool? ok = await confirmDialog(
      context,
      'Confirmar devolução da condicional #${c.id}?',
    );
    if (ok != true) {
      return;
    }
    try {
      await ApiService.patch('/api/condicionais/${c.id}/devolver');
      await _load();
    } catch (e) {
      if (mounted) {
        showError(context, e.toString());
      }
    }
  }

  String _fmtData(String? s) {
    if (s == null) {
      return '–';
    }
    try {
      final DateTime dt = DateTime.parse(s);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} '
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return s;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _loading
          ? const LoadingWidget()
          : _items.isEmpty
          ? const EmptyWidget(message: 'Nenhuma condicional registrada')
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: _items.length,
                itemBuilder: (BuildContext ctx, int i) {
                  final Condicional c = _items[i];
                  return CondicionalCard(
                    condicional: c,
                    fmtData: _fmtData,
                    onEdit: () => _openForm(c),
                    onDelete: () => _delete(c),
                    onDevolver: () => _marcarDevolvido(c),
                  );
                },
              ),
            ),
      floatingActionButton: ModernFloatingActionButton(
        icon: Icons.add,
        label: 'Novo Condicional',
        onPressed: _openForm,
      ),
    );
  }
}
