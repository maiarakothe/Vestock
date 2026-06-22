import 'package:front/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import 'package:front/widgets/shared_widgets.dart';
import 'package:front/widgets/modern_fab.dart';
import '../../../services/api_service.dart';
import '../../models/desconto.dart';
import '../../widgets/modern_card.dart';
import 'desconto_form.dart';

class DescontosScreen extends StatefulWidget {
  const DescontosScreen({super.key});

  @override
  State<DescontosScreen> createState() => _DescontosScreenState();
}

class _DescontosScreenState extends State<DescontosScreen> {
  List<Desconto> _items = <Desconto>[];
  bool _loading = true;
  bool get isMobile => MediaQuery.of(context).size.width < kMobileBreakpoint;

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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _loading
          ? const LoadingWidget()
          : _items.isEmpty
          ? const EmptyWidget(message: 'Nenhum desconto cadastrado')
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.all(20).copyWith(bottom: 100),
                itemCount: _items.length,
                itemBuilder: (BuildContext ctx, int i) {
                  final Desconto d = _items[i];
                  return ModernCard(
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            DefaultColors.primary,
                            DefaultColors.primary.withOpacity(.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: DefaultColors.primary.withOpacity(.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${d.valor.toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    title: d.nome,
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Válido até ${_fmtDate(d.dataValidade)}',
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      buildActionButton(
                        icon: Icons.edit_outlined,
                        color: DefaultColors.accent,
                        onTap: () => _openForm(d),
                      ),
                      const SizedBox(width: 8),
                      buildActionButton(
                        icon: Icons.delete_outline,
                        color: DefaultColors.error,
                        onTap: () => _delete(d),
                      ),
                    ],
                  );
                },
              ),
            ),
      floatingActionButton: ModernFloatingActionButton(
        icon: Icons.add,
        label: 'Novo Desconto',
        onPressed: _openForm,
      ),
    );
  }
}
