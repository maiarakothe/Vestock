import 'package:flutter/material.dart';
import 'package:front/app_theme.dart';
import 'package:front/widgets/shred_widgets.dart';
import '../../../services/api_service.dart';
import '../../models/loja.dart';
import 'loja_form.dart';

class LojasScreen extends StatefulWidget {
  const LojasScreen({super.key});
  @override
  State<LojasScreen> createState() => _LojasScreenState();
}

class _LojasScreenState extends State<LojasScreen> {
  List<Loja> _lojas = <Loja>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final dynamic data = await ApiService.get('/api/lojas');
      setState(() {
        final List<Loja> allItems = (data as List)
            .map((dynamic j) => Loja.fromJson(j))
            .toList();
        // Filtra apenas a loja logada
        _lojas = allItems.where((Loja l) => l.id == ApiService.lojaId).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        showError(context, e.toString());
      }
    }
  }

  void _openForm([Loja? l]) async {
    final bool? saved = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => LojaForm(loja: l),
    );
    if (saved == true) {
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const LoadingWidget()
          : _lojas.isEmpty
          ? const EmptyWidget(message: 'Nenhuma loja encontrada')
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                itemCount: _lojas.length,
                itemBuilder: (BuildContext ctx, int i) {
                  final Loja l = _lojas[i];
                  return Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: <Widget>[
                              _buildHeader(l),
                              const Divider(
                                height: 40,
                                thickness: 1,
                                color: Color(0xFFF1F1F1),
                              ),
                              _buildInfoRow(
                                Icons.badge_outlined,
                                'CNPJ',
                                l.cnpj,
                              ),
                              _buildInfoRow(
                                Icons.phone_outlined,
                                'Telefone',
                                l.telefone,
                              ),
                              _buildInfoRow(
                                Icons.location_on_outlined,
                                'Endereço',
                                '${l.rua}, ${l.bairro}\n${l.cidade}',
                              ),
                              const SizedBox(height: 32),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => _openForm(l),
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        size: 18,
                                      ),
                                      label: const Text('Editar Dados'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: DefaultColors.primary,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }

  Widget _buildHeader(Loja l) {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: DefaultColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.storefront_rounded, color: DefaultColors.primary, size: 32),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Minha Unidade',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                l.nome,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1C1E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 20, color: Colors.grey[400]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF44474E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
