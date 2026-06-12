// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:front/widgets/shred_widgets.dart';
import 'package:http/http.dart' as http2;
import '../../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _c = <String, TextEditingController>{
    for (var k in [
      'nome', 'cpf', 'cargo', 'telefone', 'email',
      'dataAdmissao', 'rua', 'bairro', 'cidade', 'estado',
      'username', 'senha'
    ])
      k: TextEditingController()
  };
  String _sexo = 'M';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _c['dataAdmissao']!.text =
        DateTime.now().toIso8601String().substring(0, 10);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final resFunc = await ApiService.post('/api/funcionarios', {
        'nome': _c['nome']!.text,
        'cpf': _c['cpf']!.text,
        'cargo': _c['cargo']!.text,
        'telefone': _c['telefone']!.text,
        'email': _c['email']!.text,
        'sexo': _sexo,
        'dataAdmissao': _c['dataAdmissao']!.text + 'T00:00:00',
        'rua': _c['rua']!.text,
        'bairro': _c['bairro']!.text,
        'cidade': _c['cidade']!.text,
        'estado': _c['estado']!.text,
      });

      final codpes = resFunc['pessoa']?['codpes'] ?? resFunc['id'];

      final res = await ApiService.post('/api/auth/criar', {
        // sent as form but API accepts json too; if not, use http directly
      });
      // Use raw http for form data
      import_workaround:
      {
        final http = await _postForm(
          '/api/auth/criar',
          {
            'username': _c['username']!.text,
            'senha': _c['senha']!.text,
            'codpes': codpes.toString(),
          },
        );
      }

      if (mounted) {
        showSuccess(context, 'Conta criada com sucesso!');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) showError(context, e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _postForm(String path, Map<String, String> body) async {
    final res = await http2.post(
      Uri.parse('${ApiService.baseUrl}$path'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );
    if (res.statusCode >= 400) throw Exception(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Conta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Dados do Funcionário',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              FormField2(label: 'Nome', controller: _c['nome']!, required: true),
              const SizedBox(height: 12),
              FormField2(label: 'CPF', controller: _c['cpf']!, required: true),
              const SizedBox(height: 12),
              FormField2(label: 'Cargo', controller: _c['cargo']!, required: true),
              const SizedBox(height: 12),
              FormField2(label: 'Telefone', controller: _c['telefone']!, required: true),
              const SizedBox(height: 12),
              FormField2(label: 'Email', controller: _c['email']!, required: true),
              const SizedBox(height: 12),
              FormField2(label: 'Data de Admissão (AAAA-MM-DD)', controller: _c['dataAdmissao']!, required: true),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _sexo,
                decoration: const InputDecoration(labelText: 'Sexo'),
                items: const [
                  DropdownMenuItem(value: 'M', child: Text('Masculino')),
                  DropdownMenuItem(value: 'F', child: Text('Feminino')),
                ],
                onChanged: (v) => setState(() => _sexo = v!),
              ),
              buildAddressSection(_c),
              const Divider(height: 32),
              const Text('Dados do Usuário',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              FormField2(label: 'Usuário', controller: _c['username']!, required: true),
              const SizedBox(height: 12),
              FormField2(label: 'Senha', controller: _c['senha']!, required: true),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Criar Funcionário e Usuário'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}