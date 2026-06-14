import 'package:awidgets/fields/a_field_email.dart';
import 'package:awidgets/fields/a_field_password.dart';
import 'package:awidgets/general/a_button.dart';
import 'package:awidgets/general/a_form.dart';
import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../app_theme.dart';
import '../../widgets/auth_card.dart';
import '../home/home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<AFormState<dynamic>> formKey =
      GlobalKey<AFormState<dynamic>>();

  Future<String?> _login(dynamic data) async {
    try {
      final dynamic response = await ApiService.login(
        data['email']?.toString().trim() ?? '',
        data['password']?.toString() ?? '',
      );
      if (response != null) {
        ApiService.lojaId =
            response['lojaId'] ??
            response['idLoja'] ??
            response['loja']?['id'] ??
            response['id'];
        debugPrint('ID da Loja definido como: ${ApiService.lojaId}');
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Widget form() {
    return AForm<dynamic>(
      key: formKey,
      showDefaultAction: false,
      fields: <Widget>[
        AFieldEmail(
          label: 'Email',
          identifier: 'email',
          required: true,
          autofocus: true,
        ),
        AFieldPassword(label: 'Senha', identifier: 'password'),
      ],
      actions: <Widget>[
        AButton(
          text: 'Entrar',
          expanded: true,
          height: 40,
          onPressed: () => formKey.currentState?.onSubmit(),
        ),
      ],
      onSubmit: _login,
      onSuccess: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<dynamic>(builder: (_) => const HomeScreen()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EEFF),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: AuthCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Icons.checkroom, size: 64, color: kPrimary),
                const SizedBox(height: 8),
                const Text(
                  'Vestock',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: kPrimary,
                  ),
                ),
                form(),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (_) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Criar conta',
                    style: TextStyle(color: kPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
