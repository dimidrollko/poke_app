import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/components/common/constants.dart';
import 'package:poke_app/components/extensions/material_extensions.dart';
import 'package:poke_app/services/router/router_provider.dart';

class ErrorRouterScreen extends StatefulWidget {
  final String location;

  const ErrorRouterScreen(this.location, {super.key});

  @override
  State<ErrorRouterScreen> createState() => _ErrorRouterScreenState();
}

class _ErrorRouterScreenState extends State<ErrorRouterScreen> {
  late String _title;
  late String? _subtitle;
  late String _buttonTitle;

  @override
  void initState() {
    _title = 'Incorrect router';
    _subtitle = "Page ${widget.location} not found";
    _buttonTitle = lastPage != null ? 'Back' : 'Go to Home screen';
    setState(() {});
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Gaps.h24,
        Align(
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              width: (context.width - (context.isLargeScreen ? 32 : 16)) / 1.5,
            ),
            child: Text(
              _title,
              style: context.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        if (_subtitle != null)
          Align(
            child: ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                width:
                    (context.width - (context.isLargeScreen ? 32 : 16)) / 1.5,
              ),
              child: Text(
                _subtitle!,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge!.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        Gaps.h24,
        Align(
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              width: (context.width - (context.isLargeScreen ? 32 : 16)) / 2,
            ),
            child: ElevatedButton(
              onPressed: () {
                context.goNamed(rSignIn);
              },
              child: Text(_buttonTitle),
            ),
          ),
        ),
      ],
    );
    child = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 240),
      child: child,
    );
    child = SizedBox(width: double.infinity, child: child);
    child = Padding(padding: EdgeInsets.all(0), child: child);
    child = SafeArea(child: child);
    return child;
  }
}
