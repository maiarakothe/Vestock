import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import '../../../app_theme.dart';
import '../../services/api_service.dart';
import '../../widgets/desktop_app_bar.dart';
import '../../widgets/floating_bottom_bar.dart';
import '../../widgets/modern_side_nav.dart';
import '../../widgets/top_bar.dart';
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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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
      final dynamic funcionarios = await ApiService.get('/api/funcionarios');

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
    await _verificarFuncionario();
  }

  List<NavItem> get _items => <NavItem>[
    NavItem(
      Icons.space_dashboard_rounded,
      'Dashboard',
      const DashboardScreen(),
      primary: true,
    ),
    NavItem(
      Icons.inventory_2_rounded,
      'Produtos',
      ProdutosScreen(),
      primary: true,
    ),
    NavItem(Icons.sync_alt_rounded, 'Condicional', CondicionalScreen()),
    NavItem(
      Icons.point_of_sale_rounded,
      'Vendas',
      VendasScreen(),
      primary: true,
    ),
    NavItem(Icons.groups_rounded, 'Clientes', ClientesScreen(), primary: true),
    NavItem(Icons.local_offer_rounded, 'Descontos', DescontosScreen()),
    NavItem(Icons.badge_rounded, 'Funcionários', FuncionariosScreen()),
    NavItem(Icons.local_shipping_rounded, 'Fornecedores', FornecedoresScreen()),
    NavItem(Icons.storefront_rounded, 'Minha Loja', const LojasScreen()),
  ];

  List<int> get _bottomItems => <int>[
    for (int i = 0; i < _items.length; i++)
      if (_items[i].primary) i,
  ];

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  void _toggleTheme() {
    themeNotifier.value = themeNotifier.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  void _irParaLojas() {
    setState(() => _selectedIndex = 8);
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void _logout() {
    ApiService.lojaId = null;
    ApiService.lojaNome = null;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<dynamic>(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < kMobileBreakpoint;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: isMobile
          ? TopBar(
              title: _items[_selectedIndex].label,
              isDark: _isDark,
              onToggleTheme: _toggleTheme,
              onAvatarTap: _irParaLojas,
            )
          : null,
      drawer: isMobile
          ? Drawer(
              backgroundColor: Theme.of(context).cardColor,
              child: SafeArea(
                child: ModernSideNav(
                  items: _items
                      .where((NavItem i) => i.label != 'Minha Loja')
                      .toList(),
                  selectedIndex: _selectedIndex,
                  onSelect: (int i) {
                    setState(() => _selectedIndex = i);
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  onAvatarTap: _irParaLojas,
                  onLogout: _logout,
                ),
              ),
            )
          : null,
      body: !isMobile
          ? Row(
              children: <Widget>[
                ModernSideNav(
                  items: _items
                      .where((NavItem i) => i.label != 'Minha Loja')
                      .toList(),
                  selectedIndex: _selectedIndex,
                  onSelect: (int i) => setState(() => _selectedIndex = i),
                  onAvatarTap: _irParaLojas,
                  onLogout: _logout,
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      DesktopAppBar(
                        title: _items[_selectedIndex].label,
                        isDark: _isDark,
                        onAvatarTap: _irParaLojas,
                        onToggleTheme: _toggleTheme,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 16, 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withOpacity(.04),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: _items[_selectedIndex].screen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : _items[_selectedIndex].screen,
      bottomNavigationBar: isMobile
          ? FloatingBottomBar(
              items: _items,
              indices: _bottomItems,
              selectedIndex: _selectedIndex,
              onSelect: (int i) => setState(() => _selectedIndex = i),
            )
          : null,
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;
  final Widget screen;
  final bool primary;
  const NavItem(this.icon, this.label, this.screen, {this.primary = false});
}
