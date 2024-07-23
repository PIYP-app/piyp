import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FadingAppBar extends StatefulWidget implements PreferredSizeWidget {
  const FadingAppBar({super.key, required this.visibility});

  final bool visibility;

  @override
  State<FadingAppBar> createState() => _FadingAppBarState();

  @override
  Size get preferredSize => const Size(double.infinity, 50);
}

class _FadingAppBarState extends State<FadingAppBar>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.visibility) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    return FadeTransition(
      opacity: _animation,
      child: const Padding(padding: EdgeInsets.all(8), child: FlutterLogo()),
    );
  }
}
