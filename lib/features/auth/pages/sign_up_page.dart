import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:poke_app/components/common/constants.dart';
import 'package:poke_app/features/auth/provider/auth_provider.dart';
import 'package:poke_app/services/router/router_provider.dart';

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

  final _scrollController = ScrollController();
  final _signUpKey = GlobalKey(); // for ensuring visibility
  //Nodes
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _confirmNode = FocusNode();

  String? _error;
  @override
  void dispose() {
    for (var e in [
      _emailController,
      _passwordController,
      _confirmController,
      _scrollController,
    ]) {
      e.dispose();
    }
    for (var e in [_emailNode, _passwordNode, _confirmNode]) {
      e.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    for (var element in [_emailNode, _passwordNode, _confirmNode]) {
      element.addListener(_onFocusChange);
    }
  }

  void _onFocusChange() {
    if ([_emailNode, _passwordNode, _confirmNode].any((e) => e.hasFocus)) {
      _scrollToEndIfNeeded();
    }
  }

  void _scrollToEndIfNeeded() async {
    await Future.delayed(
      const Duration(milliseconds: 400),
    ); // allow keyboard to appear
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _signUpKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 1.0,
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo_pokemon.png',
                  width: double.infinity,
                ),
                TextFormField(
                  focusNode: _emailNode,
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator:
                      (value) =>
                          value == null || !value.contains('@')
                              ? 'Invalid email'
                              : null,
                ),
                Gaps.h16,
                TextFormField(
                  focusNode: _passwordNode,
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator:
                      (value) =>
                          value == null || value.length < 6
                              ? 'Minimum 6 characters'
                              : null,
                ),
                Gaps.h16,
                TextFormField(
                  focusNode: _confirmNode,
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
                  Gaps.h12,
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                ],
                Gaps.h24,
                NesButton(
                  type: NesButtonType.primary,
                  key: _signUpKey,
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
                      context.goNamed(rSplash);
                    } catch (e) {
                      setState(() => _error = e.toString());
                    }
                  },
                  child: const Text('Sign Up'),
                ),
                Gaps.h4,
                const Center(child: Text('Or')),
                Gaps.h4,
                Center(
                  child: IconButton.outlined(
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
                        color: Color(0xFF747775),
                        width: 1,
                      ),
                    ),
                    onPressed: () async {
                      try {
                        await ref
                            .read(authControllerProvider.notifier)
                            .signInWithGoogle();
                        context.goNamed(rSplash);
                      } catch (e) {
                        setState(() => _error = e.toString());
                      }
                    },
                  ),
                ),
                const Divider(),
                NesButton(
                  type: NesButtonType.normal,
                  onPressed: () => context.goNamed(rSignIn),
                  child: const Text(
                    'Already have an account?\nSign In',
                    textAlign: TextAlign.center,
                  ),
                ),
                Gaps.h32,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
