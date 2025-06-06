import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/components/common/constants.dart';
import 'package:poke_app/features/auth/provider/auth_provider.dart';
import 'package:poke_app/services/router/router_provider.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _error;

  final _scrollController = ScrollController();
  final _signInKey = GlobalKey(); // for ensuring visibility
  //Nodes
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

  @override
  void dispose() {
    for (var e in [_emailController, _passwordController, _scrollController]) {
      e.dispose();
    }
    for (var e in [_emailNode, _passwordNode]) {
      e.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    for (var element in [_emailNode, _passwordNode]) {
      element.addListener(_onFocusChange);
    }
  }

  void _onFocusChange() {
    if ([_emailNode, _passwordNode].any((e) => e.hasFocus)) {
      _scrollToEndIfNeeded();
    }
  }

  void _scrollToEndIfNeeded() async {
    //Delay for keyboard appearing on screen
    //Default animation in iOS around 300 ms
    //
    await Future.delayed(
      const Duration(milliseconds: 400),
    ); // allow keyboard to appear
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _signInKey.currentContext;
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
      appBar: AppBar(title: const Text('Sign In')),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                if (_error != null) ...[
                  Gaps.h12,
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                ],
                Gaps.h24,
                ElevatedButton(
                  key: _signInKey,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    try {
                      await ref
                          .read(authControllerProvider.notifier)
                          .signInWithEmail(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );
                    } catch (e) {
                      setState(() => _error = e.toString());
                    }
                  },
                  child: const Text('Sign In'),
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
                const Divider(),
                TextButton(
                  onPressed: () => context.goNamed(rSignUp),
                  child: const Text(
                    'Don\'t have an account?\nSign up',
                    textAlign: TextAlign.center,
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
