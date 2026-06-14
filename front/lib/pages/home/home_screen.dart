// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../services/api_service.dart';
import '../dashboard/dashboard_screen.dart';
import '../cliente/clientes_screen.dart';
import '../funcionario/funcionario_form.dart';
import '../produto/produtos_screen.dart';
import '../venda/vendas_screen.dart';
import '../condicional/condicional_screen.dart';
import '../desconto/descontos_screen.dart';
import '../funcionario/funcionarios_screen.dart';
import '../fornecedor/fornecedores_screen.dart';
import '../loja/lojas_screen.dart';
import '../login/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verificarFuncionario();
    });
  }

  Future<void> _verificarFuncionario() async {
    // Se não houver lojaId, não tentamos carregar para evitar vir dados de outras lojas
    if (ApiService.lojaId == null) {
      return;
    }
    try {
      final funcionarios = await ApiService.get('/api/funcionarios');

      if (funcionarios is List && funcionarios.isEmpty) {
        _abrirCadastroFuncionario();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _abrirCadastroFuncionario() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const FuncionarioForm(persistent: true),
    );
    _verificarFuncionario();
  }

  final List<_NavItem> _items = [
    _NavItem(Icons.speed, 'Dashboard', const DashboardScreen()),
    _NavItem(Icons.inventory_2_outlined, 'Produtos', const ProdutosScreen()),
    _NavItem(Icons.shopping_cart_outlined, 'Vendas', const VendasScreen()),
    _NavItem(Icons.people_outline, 'Clientes', const ClientesScreen()),
    _NavItem(Icons.loop, 'Condicional', const CondicionalScreen()),
    _NavItem(Icons.local_offer_outlined, 'Descontos', const DescontosScreen()),
    _NavItem(Icons.badge_outlined, 'Funcionários', const FuncionariosScreen()),
    _NavItem(
      Icons.local_shipping_outlined,
      'Fornecedores',
      const FornecedoresScreen(),
    ),
    _NavItem(Icons.store_outlined, 'Lojas', const LojasScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1100;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: isWide
          ? null
          : AppBar(
              title: Text(
                _items[_selectedIndex].label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1C1E),
                ),
              ),
              backgroundColor: Colors.white,
              foregroundColor: kPrimary,
              elevation: 0,
              centerTitle: true,
            ),
      drawer: isWide ? null : _buildDrawer(),
      body: isWide
          ? Row(
              children: [
                _buildSideNav(),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(-5, 0),
                          ),
                        ],
                      ),
                      child: _items[_selectedIndex].screen,
                    ),
                  ),
                ),
              ],
            )
          : _items[_selectedIndex].screen,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.checkroom, color: kPrimary, size: 30),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Vestock',
                  style: TextStyle(
                    color: kPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _items.length,
              itemBuilder: (ctx, i) => _buildMenuItem(i),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideNav() {
    return Container(
      width: 260,
      color: const Color(0xFFF8F9FE),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.checkroom, color: kPrimary, size: 28),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Vestock',
                  style: TextStyle(
                    color: Color(0xFF1A1C1E),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _items.length,
              itemBuilder: (ctx, i) => _buildMenuItem(i),
            ),
          ),
          _buildLogoutSection(),
        ],
      ),
    );
  }

  Widget _buildMenuItem(int i) {
    final isSelected = _selectedIndex == i;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        onTap: () {
          setState(() => _selectedIndex = i);
          if (Navigator.canPop(context)) Navigator.pop(context);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        selected: isSelected,
        selectedTileColor: kPrimary.withOpacity(0.08),
        leading: Icon(
          _items[i].icon,
          color: isSelected ? kPrimary : const Color(0xFF74777F),
          size: 22,
        ),
        title: Text(
          _items[i].label,
          style: TextStyle(
            color: isSelected ? kPrimary : const Color(0xFF44474E),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F1F1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFFFEBEE),
          child: Icon(Icons.logout_rounded, color: Colors.red, size: 20),
        ),
        title: const Text(
          'Sair',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: const Text(
          'Finalizar sessão',
          style: TextStyle(fontSize: 11),
        ),
        onTap: () {
          ApiService.lojaId = null; // IMPORTANTE: Limpa o ID da loja ao sair
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final Widget screen;
  const _NavItem(this.icon, this.label, this.screen);
}
