import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/features/auth/provider/auth_provider.dart';
import 'package:poke_app/services/router/router_provider.dart';
import 'package:poke_app/user/provider/provider.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key, this.tutorialData});
  final Map<String, dynamic>? tutorialData;

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String? _error;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logo_pokemon.png',
                  width: double.infinity,
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator:
                    (value) =>
                        value == null || !value.contains('@')
                            ? 'Invalid email'
                            : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator:
                    (value) =>
                        value == null || value.length < 6
                            ? 'Minimum 6 characters'
                            : null,
              ),
              TextFormField(
                controller: _confirmController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                ),
                obscureText: true,
                validator:
                    (value) =>
                        value != _passwordController.text
                            ? 'Passwords do not match'
                            : null,
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  try {
                    await ref
                        .read(authControllerProvider.notifier)
                        .signUpWithEmail(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                    if (!context.mounted) return;
                    context.goNamed(
                      rCompleteProfile,
                      extra: widget.tutorialData,
                    );
                  } catch (e) {
                    setState(() => _error = e.toString());
                  }
                },
                child: const Text('Sign Up'),
              ),
              Text('Or'),
              IconButton.outlined(
                icon: Image.asset(
                  'assets/images/google_logo.png',
                  width: 24,
                  height: 24,
                ),
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                  backgroundColor: Colors.white,
                  shadowColor: Colors.black12,
                  elevation: 2,
                  side: const BorderSide(
                    color: Color(0xFF747775), // border color
                    width: 1,
                  ),
                ),
                onPressed: () async {
                  try {
                    await ref
                        .read(authControllerProvider.notifier)
                        .signInWithGoogle();
                  } catch (e) {
                    setState(() => _error = e.toString());
                  }
                },
              ),
              Divider(),
              TextButton(
                onPressed: () => context.goNamed(rSignIn),
                child: const Text(
                  'Already have an account?\nSign In',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
