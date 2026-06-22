// lib/screens/funcionarios_screen.dart
import 'package:flutter/material.dart';
import 'package:front/widgets/shared_widgets.dart';
import 'package:front/widgets/modern_fab.dart';
import '../../../services/api_service.dart';
import '../../app_theme.dart';
import '../../models/funcionario.dart';
import '../../widgets/modern_card.dart';
import 'funcionario_form.dart';

class FuncionariosScreen extends StatefulWidget {
  const FuncionariosScreen({super.key});
  @override
  State<FuncionariosScreen> createState() => _FuncionariosScreenState();
}

class _FuncionariosScreenState extends State<FuncionariosScreen> {
  List<Funcionario> _items = <Funcionario>[];
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
        _items = (data as List<dynamic>)
            .map((dynamic j) => Funcionario.fromJson(j))
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

  void _openForm([Funcionario? f]) async {
    final bool? saved = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => FuncionarioForm(funcionario: f),
    );
    if (saved == true) {
      await _load();
    }
  }

  Future<void> _delete(Funcionario f) async {
    final bool? ok = await confirmDialog(context, 'Excluir ${f.nome}?');
    if (ok != true) {
      return;
    }
    try {
      await ApiService.delete('/api/funcionarios/${f.id}');
      await _load();
    } catch (e) {
      if (mounted) {
        showError(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _loading
          ? const LoadingWidget()
          : _items.isEmpty
          ? const EmptyWidget(message: 'Nenhum funcionário')
          : Padding(
              padding: const EdgeInsets.all(20),
              child: RefreshIndicator(
                onRefresh: _load,
                child: ListView.builder(
                  padding: const EdgeInsets.all(8).copyWith(bottom: 100),
                  itemCount: _items.length,
                  itemBuilder: (BuildContext ctx, int i) {
                    final Funcionario f = _items[i];
                    return ModernCard(
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              DefaultColors.primary,
                              DefaultColors.secondary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: DefaultColors.primary.withValues(
                                alpha: .30,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            f.nome.isNotEmpty ? f.nome[0].toUpperCase() : '?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      title: f.nome,
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.badge_outlined,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                f.cargo,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.credit_card_outlined,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  f.cpf,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (f.email.isNotEmpty) ...<Widget>[
                            const SizedBox(height: 6),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.email_outlined,
                                  size: 14,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    f.email,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (f.telefone.isNotEmpty) ...<Widget>[
                            const SizedBox(height: 6),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.phone_outlined,
                                  size: 14,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  f.telefone,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                      actions: <Widget>[
                        buildActionButton(
                          icon: Icons.edit_outlined,
                          color: DefaultColors.accent,
                          onTap: () => _openForm(f),
                        ),
                        const SizedBox(width: 8),
                        buildActionButton(
                          icon: Icons.delete_outline,
                          color: DefaultColors.error,
                          onTap: () => _delete(f),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
      floatingActionButton: ModernFloatingActionButton(
        icon: Icons.add,
        label: 'Novo Funcionário',
        onPressed: _openForm,
      ),
    );
  }
}
