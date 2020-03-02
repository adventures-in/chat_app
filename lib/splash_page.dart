import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(body: Center(child: CircularProgressIndicator()));
  }
}
