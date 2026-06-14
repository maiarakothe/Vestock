import 'package:awidgets/fields/a_field_cnpj.dart';
import 'package:awidgets/fields/a_field_email.dart';
import 'package:awidgets/fields/a_field_password.dart';
import 'package:awidgets/fields/a_field_phone.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/general/a_button.dart';
import 'package:awidgets/general/a_form.dart';
import 'package:flutter/material.dart';
import 'package:front/pages/home/home_screen.dart';
import '../../../services/api_service.dart';
import '../../app_theme.dart';
import '../../widgets/auth_card.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<AFormState<Map<String, dynamic>?>> formKey =
      GlobalKey<AFormState<Map<String, dynamic>?>>();

  final bool _loading = false;

  Future<String?> _submit(Map<String, dynamic>? data) async {
    try {
      final dynamic response =
          await ApiService.post('/api/auth/cadastro', <String, dynamic>{
            'nome': data?['company'],
            'cnpj': data?['cnpj'],
            'telefone': data?['phone'],
            'email': data?['email'],
            'senha': data?['password'],
            'rua': data?['street'],
            'bairro': data?['bairro'],
            'cidade': data?['city'],
          });
      ApiService.lojaId = response['id'];
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Widget form() {
    return AForm<Map<String, dynamic>?>(
      key: formKey,
      showDefaultAction: false,
      fields: <Widget>[
        AFieldText(
          label: 'Nome da Empresa',
          identifier: 'company',
          required: true,
          autofocus: true,
        ),
        AFieldCNPJ(label: 'CNPJ', identifier: 'cnpj', required: true),
        AFieldPhone(label: 'Telefone', identifier: 'phone', required: true),
        AFieldEmail(label: 'Email', identifier: 'email', required: true),
        AFieldPassword(label: 'Senha', identifier: 'password'),
        AFieldText(label: 'Rua', identifier: 'street', required: true),
        AFieldText(label: 'Bairro', identifier: 'bairro', required: true),
        AFieldText(label: 'Cidade', identifier: 'city', required: true),
      ],
      actions: <Widget>[
        Row(
          children: <Widget>[
            AButton(
              text: 'Cadastrar Empresa',
              expanded: true,
              height: 40,
              loading: _loading,
              onPressed: () {
                formKey.currentState?.onSubmit();
              },
            ),
          ],
        ),
      ],
      onSuccess: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<dynamic>(builder: (_) => const HomeScreen()),
        );
      },
      onSubmit: _submit,
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
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Já possui conta? Entrar',
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
