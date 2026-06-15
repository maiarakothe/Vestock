// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:front/widgets/shared_widgets.dart';
import '../../../services/api_service.dart';
import '../../../app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _totalClientes = 0;
  int _totalEstoque = 0;
  int _condicionaisAtivas = 0;
  List _estoqueBaixo = <dynamic>[];
  List _alertasCondicionais = <dynamic>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final List<dynamic> results = await Future.wait(<Future<dynamic>>[
        ApiService.get('/api/clientes/total'),
        ApiService.get('/api/condicionais/total-ativas'),
        ApiService.get('/api/produtos/total'),
        ApiService.get('/api/condicionais/vencendo-hoje'),
      ]);

      setState(() {
        _totalClientes = results[0]['totalClientes'] ?? 0;
        _condicionaisAtivas = results[1]['totalAtivas'] ?? 0;
        _totalEstoque = results[2]['totalEstoque'] ?? 0;
        _estoqueBaixo = results[2]['estoqueBaixo'] ?? <dynamic>[];
        _alertasCondicionais = results[3] ?? <dynamic>[];
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        showError(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const LoadingWidget()
          : RefreshIndicator(
              onRefresh: _load,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildKpiSection(),
                    const SizedBox(height: 40),
                    _buildAlertsSection(),
                    const SizedBox(height: 40),
                    _buildStockSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1C1E),
          ),
        ),
        Text(
          'Visão geral da sua loja hoje',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildKpiSection() {
    return LayoutBuilder(
      builder: (BuildContext ctx, BoxConstraints constraints) {
        final double w = constraints.maxWidth;
        final bool isMobile = w < 800;
        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: <Widget>[
            _KpiCard(
              icon: Icons.people_alt_outlined,
              color: const Color(0xFF0061A4),
              title: 'Clientes',
              value: _totalClientes.toString(),
              subtitle: 'Base cadastrada',
              width: isMobile ? w : (w - 40) / 3,
            ),
            _KpiCard(
              icon: Icons.inventory_2_outlined,
              color: DefaultColors.primary,
              title: 'Estoque',
              value: _totalEstoque.toString(),
              subtitle: 'Itens disponíveis',
              width: isMobile ? w : (w - 40) / 3,
            ),
            _KpiCard(
              icon: Icons.loop_rounded,
              color: const Color(0xFF914D00),
              title: 'Condicionais',
              value: _condicionaisAtivas.toString(),
              subtitle: 'Retiradas ativas',
              width: isMobile ? w : (w - 40) / 3,
            ),
          ],
        );
      },
    );
  }

  Widget _buildAlertsSection() {
    if (_alertasCondicionais.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Icon(
              Icons.notification_important_outlined,
              color: Color(0xFFBA1A1A),
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Alertas de Devolução',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF1A1C1E),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._alertasCondicionais.map(
          (dynamic c) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFDAD6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFBA1A1A),
                child: Icon(
                  Icons.timer_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              title: Text(
                'Vencendo hoje: Condicional #${c['id']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF410002),
                ),
              ),
              subtitle: Text(
                'Cliente: ${c['cliente']?['nome'] ?? 'Não identificado'}',
                style: const TextStyle(color: Color(0xFF410002)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStockSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Estoque Crítico',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF1A1C1E),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFF1F1F1)),
          ),
          child: _estoqueBaixo.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: EmptyWidget(message: 'Nenhum alerta de estoque'),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _estoqueBaixo.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(height: 1),
                  itemBuilder: (BuildContext context, int index) {
                    final dynamic p = _estoqueBaixo[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      title: Text(
                        p['nome'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(p['tipo'] ?? ''),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFDAD6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${p['quantidadeEstoque']} un',
                          style: const TextStyle(
                            color: Color(0xFFBA1A1A),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, value, subtitle;
  final double width;

  const _KpiCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                radius: 28,
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1C1E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                    ),
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
