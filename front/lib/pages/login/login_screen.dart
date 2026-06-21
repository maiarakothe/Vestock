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
        ApiService.lojaNome = response['nome'] ?? response['loja']?['nome'];
        debugPrint('ID da Loja definido como: ${ApiService.lojaId}');
        debugPrint('Nome da Loja definido como: ${ApiService.lojaNome}');
      }
      return null;
    } catch (e, stack) {
      debugPrint('ERRO LOGIN: $e');
      debugPrint(
        'DICA: Verifique se o IP ${ApiService.baseUrl} está correto e acessível pelo celular.',
      );
      debugPrintStack(stackTrace: stack);
      return e.toString();
    }
  }

  Widget form() {
    return AForm<dynamic>(
      key: formKey,
      showDefaultAction: false,
      padding: const EdgeInsets.all(0),
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
        const SizedBox(height: 18),
        Container(
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: <Color>[DefaultColors.primary, DefaultColors.secondary],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: DefaultColors.primary.withOpacity(.25),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: AButton(
            text: 'Entrar',
            expanded: true,
            fontSize: 14,
            elevation: 0,
            color: Colors.transparent,
            onPressed: () => formKey.currentState?.onSubmit(),
          ),
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
    return Theme(
      data: themeLightData(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[DefaultColors.primary, DefaultColors.secondary],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: AuthCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset('assets/images/logo-2-cortado.png', width: 280),

                    form(),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Não possui conta?',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: DefaultColors.secondary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
