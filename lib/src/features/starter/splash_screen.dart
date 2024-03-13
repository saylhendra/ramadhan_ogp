import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ramadhan_ogp/src/features/home/home_screen.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  static const String routeName = 'splash-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _delay = useState(1);

    useEffect(() {
      Future.delayed(
        Duration(seconds: _delay.value),
        () => context.pushReplacementNamed(
          HomeScreen.routeName,
        ),
      );
      return null;
    }, [_delay.value]);

    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
