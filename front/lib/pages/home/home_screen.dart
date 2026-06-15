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
import '../../widgets/theme_switcher_tile.dart';

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

  final List<_NavItem> _items = <_NavItem>[
    _NavItem(Icons.speed, 'Dashboard', const DashboardScreen()),
    _NavItem(Icons.inventory_2_outlined, 'Produtos', const ProdutosScreen()),
    _NavItem(Icons.loop, 'Condicional', const CondicionalScreen()),
    _NavItem(Icons.shopping_cart_outlined, 'Vendas', const VendasScreen()),
    _NavItem(Icons.people_outline, 'Clientes', const ClientesScreen()),
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
    final bool isWide = MediaQuery.of(context).size.width >= 1100;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: isWide
          ? null
          : AppBar(
              title: Text(
                _items[_selectedIndex].label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.white,
              foregroundColor: DefaultColors.primary,
              elevation: 0,
              centerTitle: true,
            ),
      drawer: isWide ? null : _buildDrawer(),
      body: isWide
          ? Row(
              children: <Widget>[
                _buildSideNav(),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: _items[_selectedIndex].screen,
                  ),
                ),
              ],
            )
          : _items[_selectedIndex].screen,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Theme.of(context).primaryColor,
      child: _buildSideNavContent(),
    );
  }

  Widget _buildSideNav() {
    return Container(
      width: 290,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[DefaultColors.primary, DefaultColors.secondary],
        ),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: _buildSideNavContent(),
    );
  }

  Widget _buildSideNavContent() {
    return Column(
      children: <Widget>[
        _buildSideHeader(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _items.length,
            itemBuilder: (BuildContext ctx, int i) => _buildMenuItem(i),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
          child: ThemeSwitcherTile(),
        ),
        _buildLogoutSection(),
      ],
    );
  }

  Widget _buildSideHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Image.asset('assets/images/logo-2-cortado.png', width: 170),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(int i) {
    final bool selected = _selectedIndex == i;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          setState(() {
            _selectedIndex = i;
          });
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: selected
                      ? DefaultColors.primary.withOpacity(.12)
                      : Colors.white.withOpacity(.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _items[i].icon,
                  color: selected ? DefaultColors.primary : Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  _items[i].label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: selected ? DefaultColors.primary : Colors.white,
                  ),
                ),
              ),
              if (selected)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: DefaultColors.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          ApiService.lojaId = null;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<dynamic>(builder: (_) => const LoginScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.12),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Row(
            children: <Widget>[
              Icon(Icons.logout_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text(
                'Sair',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
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
