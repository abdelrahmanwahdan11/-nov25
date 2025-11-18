import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import 'auth_controller.dart';

class LoginScreen extends StatefulWidget {
  final AuthController authController;
  const LoginScreen({super.key, required this.authController});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(t('login'), style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold))
                    .animate()
                    .slideY(begin: 0.2, duration: const Duration(milliseconds: 350)),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: InputDecoration(labelText: t('email')),
                  validator: widget.authController.validateEmail,
                ).animate().fadeIn(delay: const Duration(milliseconds: 150)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passCtrl,
                  decoration: InputDecoration(
                    labelText: t('password'),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  obscureText: _obscure,
                  validator: widget.authController.validatePassword,
                ).animate().fadeIn(delay: const Duration(milliseconds: 200)),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/auth/forgot'),
                    child: Text(t('forgot_password')),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        await widget.authController.login(_emailCtrl.text, _passCtrl.text);
                        if (!mounted) return;
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                    ),
                    child: Text(t('login')),
                  ).animate().scale(delay: const Duration(milliseconds: 250)),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      widget.authController.loginAsGuest();
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                    ),
                    child: Text(t('login_as_guest')),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(t('signup')),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/auth/signup'),
                      child: Text(t('signup')),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
