import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import 'auth_controller.dart';

class SignUpScreen extends StatefulWidget {
  final AuthController authController;
  const SignUpScreen({super.key, required this.authController});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _accepted = false;

  String _passwordStrength(String value) {
    if (value.length > 10) return 'Strong';
    if (value.length > 6) return 'Medium';
    return 'Weak';
  }

  Color _strengthColor(String value) {
    switch (value) {
      case 'Strong':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    final strength = _passwordStrength(_passCtrl.text);
    return Scaffold(
      appBar: AppBar(title: Text(t('signup'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(labelText: t('name')),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailCtrl,
                decoration: InputDecoration(labelText: t('email')),
                validator: widget.authController.validateEmail,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passCtrl,
                decoration: InputDecoration(labelText: t('password')),
                obscureText: true,
                onChanged: (_) => setState(() {}),
                validator: widget.authController.validatePassword,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  strength,
                  style: TextStyle(color: _strengthColor(strength), fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmCtrl,
                decoration: InputDecoration(labelText: t('confirm_password')),
                obscureText: true,
                validator: (v) => v == _passCtrl.text ? null : 'Mismatch',
              ),
              CheckboxListTile(
                value: _accepted,
                onChanged: (v) => setState(() => _accepted = v ?? false),
                title: const Text('Accept terms'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!(_formKey.currentState?.validate() ?? false) || !_accepted) return;
                    await widget.authController.signup(_nameCtrl.text, _emailCtrl.text, _passCtrl.text);
                    if (!mounted) return;
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: Text(t('signup')),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
