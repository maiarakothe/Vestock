// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:front/widgets/shred_widgets.dart';
import '../../services/api_service.dart';
import '../../app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _totalClientes = 0;
  int _totalEstoque = 0;
  int _condicionaisAtivas = 0;
  List _estoqueBaixo = [];
  List _alertasCondicionais = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        ApiService.get('/api/clientes/total'),
        ApiService.get('/api/condicionais/total-ativas'),
        ApiService.get('/api/produtos/total'),
        ApiService.get('/api/condicionais/vencendo-hoje'),
      ]);

      setState(() {
        _totalClientes = results[0]['totalClientes'] ?? 0;
        _condicionaisAtivas = results[1]['totalAtivas'] ?? 0;
        _totalEstoque = results[2]['totalEstoque'] ?? 0;
        _estoqueBaixo = results[2]['estoqueBaixo'] ?? [];
        _alertasCondicionais = results[3] ?? [];
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const LoadingWidget();

    return RefreshIndicator(
      onRefresh: _load,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dashboard',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            // KPI Cards
            LayoutBuilder(builder: (ctx, constraints) {
              final w = constraints.maxWidth;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _KpiCard(
                    icon: Icons.people,
                    color: Colors.blue,
                    title: 'Clientes Cadastrados',
                    value: _totalClientes.toString(),
                    subtitle: 'Base ativa',
                    width: w > 600 ? (w - 36) / 3 : w,
                  ),
                  _KpiCard(
                    icon: Icons.inventory_2,
                    color: Colors.cyan,
                    title: 'Produtos em Estoque',
                    value: _totalEstoque.toString(),
                    subtitle: 'Itens disponíveis',
                    width: w > 600 ? (w - 36) / 3 : w,
                  ),
                  _KpiCard(
                    icon: Icons.loop,
                    color: Colors.orange,
                    title: 'Condicionais Ativas',
                    value: _condicionaisAtivas.toString(),
                    subtitle: 'Pendentes',
                    width: w > 600 ? (w - 36) / 3 : w,
                  ),
                ],
              );
            }),
            const SizedBox(height: 20),
            if (_alertasCondicionais.isNotEmpty) ...[
              const Text('⚠️ Alertas Importantes',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              ..._alertasCondicionais.map((c) => Card(
                    color: const Color(0xFFFFF3CD),
                    child: ListTile(
                      leading:
                          const Icon(Icons.warning_amber, color: Colors.orange),
                      title: const Text('Condicional Vencendo!',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          'Condicional #${c['id']} para ${c['cliente']?['nome'] ?? ''} vence hoje.'),
                    ),
                  )),
              const SizedBox(height: 16),
            ],
            const Text('Produtos com Estoque Baixo',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            if (_estoqueBaixo.isEmpty)
              const EmptyWidget(message: 'Nenhum produto com estoque baixo')
            else
              Card(
                child: Column(
                  children: _estoqueBaixo.map((p) => ListTile(
                        title: Text(p['nome'] ?? ''),
                        trailing: Chip(
                          label: Text('Estoque: ${p['quantidadeEstoque']}'),
                          backgroundColor: Colors.red[100],
                        ),
                        subtitle: Text(p['tipo'] ?? ''),
                      )).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, value, subtitle;
  final double width;

  const _KpiCard({
    required this.icon, required this.color, required this.title,
    required this.value, required this.subtitle, required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.15),
                radius: 28,
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontSize: 13, color: Colors.grey)),
                    Text(value,
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    Text(subtitle,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
