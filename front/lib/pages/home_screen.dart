// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'dashboard_screen.dart';
import 'clientes_screen.dart';
import 'produtos_screen.dart';
import 'vendas_screen.dart';
import 'condicional_screen.dart';
import 'descontos_screen.dart';
import 'funcionarios_screen.dart';
import 'fornecedores_screen.dart';
import 'lojas_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<_NavItem> _items = [
    _NavItem(Icons.speed, 'Dashboard', const DashboardScreen()),
    _NavItem(Icons.inventory_2_outlined, 'Produtos', const ProdutosScreen()),
    _NavItem(Icons.shopping_cart_outlined, 'Vendas', const VendasScreen()),
    _NavItem(Icons.people_outline, 'Clientes', const ClientesScreen()),
    _NavItem(Icons.loop, 'Condicional', const CondicionalScreen()),
    _NavItem(Icons.local_offer_outlined, 'Descontos', const DescontosScreen()),
    _NavItem(Icons.badge_outlined, 'Funcionários', const FuncionariosScreen()),
    _NavItem(Icons.local_shipping_outlined, 'Fornecedores', const FornecedoresScreen()),
    _NavItem(Icons.store_outlined, 'Lojas', const LojasScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: isWide
          ? null
          : AppBar(
        title: Text(_items[_selectedIndex].label),
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
      ),
      drawer: isWide ? null : _buildDrawer(),
      body: isWide
          ? Row(
        children: [
          _buildSideNav(),
          Expanded(child: _items[_selectedIndex].screen),
        ],
      )
          : _items[_selectedIndex].screen,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: kPrimary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(Icons.checkroom, size: 40, color: Colors.white),
                SizedBox(height: 8),
                Text('Vestock',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (ctx, i) => ListTile(
                leading: Icon(_items[i].icon,
                    color: i == _selectedIndex ? kPrimary : Colors.grey[600]),
                title: Text(_items[i].label),
                selected: i == _selectedIndex,
                selectedTileColor: const Color(0xFFEDE7FF),
                onTap: () {
                  setState(() => _selectedIndex = i);
                  Navigator.pop(ctx);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideNav() {
    return Container(
      width: 220,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 80,
            color: kPrimary,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Row(
              children: [
                Icon(Icons.checkroom, color: Colors.white, size: 28),
                SizedBox(width: 10),
                Text('Vestock',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (ctx, i) => ListTile(
                dense: true,
                leading: Icon(_items[i].icon,
                    color: i == _selectedIndex ? kPrimary : Colors.grey[600]),
                title: Text(_items[i].label,
                    style: TextStyle(
                        color:
                        i == _selectedIndex ? kPrimary : Colors.grey[800])),
                selected: i == _selectedIndex,
                selectedTileColor: const Color(0xFFEDE7FF),
                onTap: () => setState(() => _selectedIndex = i),
              ),
            ),
          ),
        ],
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